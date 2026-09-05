###############################################################################
# Script 04a — EWAS Array Execution (Map step)
# (Ejecuta una sola comparación basada en el SLURM_ARRAY_TASK_ID)
###############################################################################

rm(list = ls())
suppressPackageStartupMessages({
  library(meffil)
  library(dplyr)
  library(ggplot2)
  library(readr)
  library(stringr)
  library(purrr)
  library(tibble)
  library(ggrepel)
  library(tidyr)
})

# ---- Recibir argumento de SLURM ----
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("ERROR: Se requiere el SLURM_ARRAY_TASK_ID como argumento.")
}
task_id <- as.integer(args[1])

# ---- Enable full parallelization ----
n_cores <- as.integer(Sys.getenv("SLURM_CPUS_PER_TASK", unset = 4))
Sys.setenv(OMP_NUM_THREADS="1", MKL_NUM_THREADS="1", OPENBLAS_NUM_THREADS="1")

# ---- Publication-ready figure titles (edit the wording here) ----------------
# Keyed by contrast code (A1-A14, matching the manuscript numbering). Used on the
# volcano and Manhattan plots so the reader sees the biological comparison rather
# than an internal label. Any code not listed falls back to a prettified label.
PUBLICATION_TITLES <- c(
  A1  = "Asthma versus non-asthmatic controls",
  A2  = "Atopic asthma versus atopic controls",
  A3  = "Non-atopic asthma versus non-atopic controls",
  A4  = "Atopy among controls",
  A5  = "Atopy within asthma",
  A6  = "Atopy overall",
  A7  = "Severe or uncontrolled versus mild or well-controlled asthma",
  A8  = "Severe versus mild atopic asthma",
  A9  = "Severe atopic asthma (C1) versus all other participants",
  A10 = "Severe non-atopic asthma (C2) versus all other participants",
  A11 = "Mild atopic asthma (C3) versus all other participants",
  A12 = "Non-atopic controls (C4) versus all other participants",
  A13 = "Mild non-atopic asthma (C5) versus all other participants",
  A14 = "Atopic controls (C6) versus all other participants"
)
pretty_label <- function(label) {
  s <- gsub("_", " ", label); s <- gsub("\\bvs\\b", "versus", s)
  paste0(toupper(substr(s, 1, 1)), substr(s, 2, nchar(s)))
}
pub_title_of <- function(code, label) {
  if (!is.null(code) && !is.na(code) && code %in% names(PUBLICATION_TITLES))
    unname(PUBLICATION_TITLES[code]) else pretty_label(label)
}
options(mc.cores = n_cores)

cat("Using", n_cores, "cores via mclapply for Task ID:", task_id, "\n")

# ---------------------- Rutas principales ----------------------
source("scripts_R/00_config.R")
data_folder <- DATA_DIR
report_dir  <- EWAS_TAB_DIR
if (!dir.exists(report_dir)) dir.create(report_dir, recursive = TRUE)

# ---------------------- Helpers robustos ----------------------
pick_first <- function(df, candidates, default = NA) {
  nm <- candidates[candidates %in% names(df)][1]
  if (length(nm) == 0) return(rep(default, nrow(df)))
  df[[nm]]
}

coalesce_cols_chr <- function(df, candidates) {
  out <- rep(NA_character_, nrow(df))
  for (nm in candidates) if (nm %in% names(df)) {
    v <- as.character(df[[nm]])
    out[is.na(out) | out == ""] <- v[is.na(out) | out == ""]
  }
  out
}
coalesce_cols_num <- function(df, candidates) {
  out <- rep(NA_real_, nrow(df))
  for (nm in candidates) if (nm %in% names(df)) {
    v <- suppressWarnings(as.numeric(df[[nm]]))
    take <- is.na(out) & !is.na(v)
    out[take] <- v[take]
  }
  out
}

std_annot <- function(annot) {
  a <- as.data.frame(annot, stringsAsFactors = FALSE)
  if (!("chromosome" %in% names(a))) {
    if ("chr" %in% names(a)) a$chromosome <- a$chr
    else if ("seqnames" %in% names(a)) a$chromosome <- a$seqnames
  }
  if (!("position" %in% names(a))) {
    if ("pos" %in% names(a)) a$position <- a$pos
    else if ("mapinfo" %in% names(a)) a$position <- a$mapinfo
    else if ("bp" %in% names(a)) a$position <- a$bp
  }
  a
}

log10_line_for_fdr <- function(p, fdr, q){
  p_ok <- p[fdr < q & is.finite(p)]
  if (length(p_ok)) -log10(max(p_ok, na.rm = TRUE)) else NA_real_
}

# EWAS FUNCTION 
run_one_ewas <- function(rdata_path, label, code = NULL) {
  load(rdata_path)
  stopifnot(exists("beta_sub"), exists("keep"))
  
  keep <- keep %>% mutate(comparison = droplevels(factor(comparison)))

  ## ---- optional participant subset by study centre (sensitivity analyses) ----
  ## EWAS_KEEP_CENTRES / EWAS_DROP_CENTRES = comma-separated centre_name values.
  ## Lets the primary EWAS be repeated within income strata or leave-one-centre-out
  ## without rebuilding step 03. Underpowered contrasts (an arm with <3) are skipped.
  .keep_centres <- Sys.getenv("EWAS_KEEP_CENTRES", unset = "")
  .drop_centres <- Sys.getenv("EWAS_DROP_CENTRES", unset = "")
  if (nzchar(.keep_centres) || nzchar(.drop_centres)) {
    if (!"centre_name" %in% names(keep))
      stop("EWAS subset requested but 'centre_name' is absent from keep; rebuild step 03.")
    cn  <- as.character(keep$centre_name)
    sel <- rep(TRUE, length(cn))
    if (nzchar(.keep_centres)) sel <- sel & cn %in% trimws(strsplit(.keep_centres, ",")[[1]])
    if (nzchar(.drop_centres)) sel <- sel & !(cn %in% trimws(strsplit(.drop_centres, ",")[[1]]))
    keep     <- keep[sel, , drop = FALSE]
    beta_sub <- beta_sub[, keep$Sample_Name, drop = FALSE]
    keep$comparison <- droplevels(factor(keep$comparison))
    cat(sprintf("[SUBSET] %s | centres {%s} | N=%d\n", label,
                paste(sort(unique(cn[sel])), collapse = ", "), nrow(keep)))
    .tb <- table(keep$comparison)
    if (length(.tb) < 2 || any(.tb < 3)) {
      cat(sprintf("[SUBSET-SKIP] %s: too few after subset (%s)\n", label,
                  paste(sprintf("%s=%d", names(.tb), as.integer(.tb)), collapse = ", ")))
      return(invisible(NULL))
    }
  }

  covar_names <- c("sex","age",
                   "neutrophils1_ratio","lymphocytes1_ratio",
                   "monocytesmacrophages1_ratio","eosinophils1_ratio",
                   "squamouscells1_ratio")
  
  ok <- complete.cases(keep[, c("comparison", covar_names)])
  if (!all(ok)) {
    beta_sub <- beta_sub[, ok, drop = FALSE]
    keep     <- keep[ok, , drop = FALSE]
  }

  ## Drop covariates that are constant in this (possibly subset) sample: on a
  ## single-centre subset a cell-fraction or sex column can collapse to one value,
  ## making the design rank-deficient and crashing meffil.ewas/SVA.
  covar_use <- covar_names[vapply(covar_names,
    function(cn) length(unique(stats::na.omit(keep[[cn]]))) > 1, logical(1))]
  if (!length(covar_use)) covar_use <- covar_names

  ## Robust fit: SVA can fail on small subsets (too few residual df). Fall back to
  ## no-SVA, and if the contrast still cannot be fitted, skip it cleanly so a single
  ## failing stratum/contrast does not abort the whole SLURM array (which would leave
  ## the dependent summary job in DependencyNeverSatisfied).
  set.seed(12345)
  ew <- tryCatch(
    meffil.ewas(beta_sub, variable = keep$comparison,
                covariates = keep[, covar_use, drop = FALSE], sva = TRUE),
    error = function(e) {
      cat(sprintf("[EWAS-WARN] %s: SVA fit failed (%s); retrying without SVA\n",
                  label, conditionMessage(e)))
      tryCatch(
        meffil.ewas(beta_sub, variable = keep$comparison,
                    covariates = keep[, covar_use, drop = FALSE], sva = FALSE),
        error = function(e2) {
          cat(sprintf("[EWAS-SKIP] %s: model failed without SVA too (%s); skipping\n",
                      label, conditionMessage(e2)))
          NULL
        })
    })
  if (is.null(ew)) return(invisible(NULL))

  res <- ew$analyses$all$table %>% as.data.frame(stringsAsFactors = FALSE)
  res$probeID <- rownames(res)
  
  cand_beta <- c("coefficient","beta","estimate","Estimate","Effect")
  cand_p    <- c("p.value","P.Value","p","pvalue","p_value")
  res$beta  <- as.numeric(pick_first(res, cand_beta, NA_real_))
  res$p     <- as.numeric(pick_first(res, cand_p,    NA_real_))
  res$log10p <- -log10(res$p); res$log10p[!is.finite(res$log10p)] <- NA_real_
  
  annot <- std_annot(meffil.get.features("epic"))
  keep_annot <- intersect(c("name","chromosome","position","UCSC_RefGene_Name","gene","gene.symbol","Symbol"), names(annot))
  annot <- annot[, keep_annot, drop = FALSE]
  res <- res %>% left_join(annot, by = c("probeID" = "name"))
  
  res$chromosome <- coalesce_cols_chr(res, c("chromosome","chromosome.x","chromosome.y","chr","CHR"))
  res$position <- coalesce_cols_num(res, c("position","position.x","position.y","pos","mapinfo","bp","BP"))
  
  if (is.character(res$chromosome)) {
    res$chromosome <- gsub("^chr", "", res$chromosome, ignore.case = TRUE)
    res$chromosome[res$chromosome %in% c("X","x")] <- "23"
    res$chromosome[res$chromosome %in% c("Y","y")] <- "24"
  }
  res$chromosome <- suppressWarnings(as.integer(res$chromosome))
  
  # Limpiar nombre del gen 
  res$gene <- coalesce_cols_chr(res, c("gene","gene.symbol","Symbol","UCSC_RefGene_Name"))
  res$gene <- ifelse(!is.na(res$gene) & res$gene != "", sub(";.*","", res$gene), NA_character_)
  
  res <- res[order(res$p), , drop = FALSE]
  res$fdr  <- p.adjust(res$p, "fdr")
  res$bonf <- p.adjust(res$p, "bonferroni")
  
  code_prefix <- if (!is.null(code) && nzchar(code)) paste0(code, "_") else ""
  title_prefix <- if (!is.null(code) && nzchar(code)) paste0(code, ": ") else ""
  
  stem  <- paste0("EWAS_", code_prefix, label)
  csv_main      <- file.path(report_dir, paste0(stem, ".csv"))
  csv_fdr       <- file.path(report_dir, paste0(stem, "_FDR.csv"))
  csv_hits      <- file.path(report_dir, paste0(stem, "_HITS.csv")) 
  csv_top       <- file.path(report_dir, paste0(stem, "_Top20.csv"))
  csv_top_genes <- file.path(report_dir, paste0(stem, "_Top20_genes.csv"))
  
  # Exportaciones (El main CSV es vital para el Script 8)
  write_csv(res, csv_main)
  write_csv(res %>% filter(fdr < 0.05), csv_fdr)
  write_csv(res %>% filter(fdr < 0.05 & abs(beta) > 0.01), csv_hits) 
  write_csv(res %>% arrange(desc(abs(beta)), p) %>% slice_head(n = 20) %>% relocate(gene, .after = probeID), csv_top)
  write_csv(res %>% filter(!is.na(gene), gene != "") %>% arrange(desc(abs(beta)), p) %>% slice_head(n = 20) %>% relocate(gene, .after = probeID), csv_top_genes)
  
  png_qq   <- file.path(EWAS_FIG_DIR, paste0("QQ_",        code_prefix, label, ".png"))
  png_volc <- file.path(EWAS_FIG_DIR, paste0("VOLCANO_",   code_prefix, label, ".png"))
  png_manh <- file.path(EWAS_FIG_DIR, paste0("MANHATTAN_", code_prefix, label, ".png"))
  
  qq <- meffil.ewas.qq.plot(ew)
  ggsave(png_qq, qq$all, width = 8, height = 6)
  
  thr_log10_fdr05 <- log10_line_for_fdr(res$p, res$fdr, 0.05)
  thr_log10_fdr10 <- log10_line_for_fdr(res$p, res$fdr, 0.10)
  thr_log10_fdr20 <- log10_line_for_fdr(res$p, res$fdr, 0.20)
  
  # ---------------- VOLCANO PLOT ----------------
  plot_df <- res %>% filter(is.finite(beta), is.finite(log10p), is.finite(fdr))
  FDR05 <- 0.05; FDR10 <- 0.10; FDR20 <- 0.20
  
  catg <- ifelse(
    abs(plot_df$beta) > 0.01 & plot_df$fdr < FDR05,
    ifelse(plot_df$beta > 0, "Up GW", "Down GW"),
    ifelse(
      abs(plot_df$beta) > 0.01 & plot_df$fdr < FDR10,
      ifelse(plot_df$beta > 0, "Up strong", "Down strong"),
      ifelse(
        abs(plot_df$beta) > 0.01 & plot_df$fdr < FDR20,
        ifelse(plot_df$beta > 0, "Up medium", "Down medium"),
        "Not Sig"
      )
    )
  )
  plot_df$category <- factor(catg, levels = c("Down GW","Down strong","Down medium","Not Sig","Up medium","Up strong","Up GW"))
  
  cols <- c("Down GW"="#84D2F6", "Down strong"="#6BAED6", "Down medium"="#2C7FB8", "Not Sig"="#54494B", "Up medium"="#B22222", "Up strong"="#E6550D", "Up GW"="#FF8C00")
  # PUNTOS FINOS
  sizes <- c("Down GW"=1.2, "Down strong"=1.0, "Down medium"=0.7, "Not Sig"=0.3, "Up medium"=0.7, "Up strong"=1.0, "Up GW"=1.2)
  
  # COLUMNA HÍBRIDA PARA ETIQUETAS
  plot_df <- plot_df %>% mutate(label_txt = ifelse(!is.na(gene) & gene != "", gene, probeID))
  
  volcano <- ggplot(plot_df, aes(x = beta, y = log10p, color = category)) +
    geom_point(aes(size = category), alpha = 0.85) +
    { if (is.finite(thr_log10_fdr20)) geom_hline(yintercept = thr_log10_fdr20, colour = "red",  linetype = "dotted", linewidth = 0.8) } +
    { if (is.finite(thr_log10_fdr10)) geom_hline(yintercept = thr_log10_fdr10, colour = "red",  linetype = "dashed", linewidth = 0.8) } +
    { if (is.finite(thr_log10_fdr05)) geom_hline(yintercept = thr_log10_fdr05, colour = "#B22222",  linetype = "dashed", linewidth = 1.2) } +
    geom_vline(xintercept = c(-0.01, 0.01), linetype = "dotted", color = "black", linewidth = 0.8) +
    scale_color_manual(values = cols, drop = FALSE, name = "Significance\n(|Beta|>0.01)") +
    scale_size_manual(values = sizes, drop = FALSE, guide = "none") +
    guides(color = guide_legend(override.aes = list(size = 4))) + # Puntos grandes en leyenda
    theme_classic(base_size = 18) +
    ylab(expression(bold(-log[10](p-value)))) + 
    xlab(expression(bold("Effect size (" * beta * ")"))) +
    ggtitle(pub_title_of(code, label)) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 22, face = "bold"),
      axis.title = element_text(size = 18, face = "bold"),
      axis.text = element_text(size = 14, color = "black"),
      legend.title = element_text(size = 16, face = "bold"),
      legend.text = element_text(size = 14)
    )
  
  # ETIQUETAS SIMÉTRICAS HÍBRIDAS
  lab_up <- plot_df %>% filter(category != "Not Sig", beta > 0.01) %>% arrange(fdr, desc(abs(beta))) %>% slice_head(n = 8)
  lab_down <- plot_df %>% filter(category != "Not Sig", beta < -0.01) %>% arrange(fdr, desc(abs(beta))) %>% slice_head(n = 8)
  lab_df <- bind_rows(lab_up, lab_down)
  
  if (nrow(lab_df)) {
    volcano <- volcano + ggrepel::geom_label_repel(
      data = lab_df, aes(x = beta, y = log10p, label = label_txt), 
      size = 5.0, label.size = 0.3, box.padding = 0.5, point.padding = 0.5, 
      max.overlaps = 50, min.segment.length = 0, segment.alpha = 0.7, fontface = "bold"
    )
  }
  ggsave(png_volc, volcano, width = 11, height = 8, dpi = 300)
  
  # ---------------- MANHATTAN PLOT ----------------
  have_chrpos <- all(c("chromosome","position") %in% names(res))
  if (have_chrpos) {
    man_df <- res %>%
      mutate(chr_str = toupper(as.character(chromosome)), chr_str = gsub("^CHR|^CHROMOSOME", "", chr_str),
             chr_idx = dplyr::case_when(suppressWarnings(!is.na(as.integer(chr_str))) & as.integer(chr_str) %in% 1:24 ~ as.integer(chr_str), chr_str %in% as.character(1:22) ~ as.integer(chr_str), chr_str %in% c("X","23") ~ 23L, chr_str %in% c("Y","24") ~ 24L, TRUE ~ NA_integer_)) %>%
      filter(!is.na(chr_idx), !is.na(position), is.finite(log10p)) %>% arrange(chr_idx, position)
    
    if (nrow(man_df) > 0) {
      chrom_sizes <- man_df %>% group_by(chr_idx) %>% summarise(chr_len = max(position, na.rm = TRUE), .groups = "drop") %>% arrange(chr_idx) %>% mutate(offset = dplyr::lag(cumsum(chr_len), default = 0))
      man_df <- man_df %>% left_join(chrom_sizes[, c("chr_idx","offset")], by = "chr_idx") %>% mutate(pos_cum = position + offset)
      axis_df <- chrom_sizes %>% mutate(center = offset + chr_len/2, chr_txt = dplyr::case_when(chr_idx == 23L ~ "X", chr_idx == 24L ~ "Y", TRUE ~ as.character(chr_idx)))
      
      base_dark   <- "#133C55"; mid_dark    <- "#17557B"; strong_dark <- "#2B80B5"; gw_dark <- "#2B80B5"
      base_light  <- "#386FA4"; mid_light   <- "#59A5D8"; strong_light<- "#84D2F6"; gw_light<- "#91E5F6"
      parity  <- man_df$chr_idx %% 2
      col_base <- ifelse(parity == 1, base_dark,  base_light); col_med  <- ifelse(parity == 1, mid_dark,   mid_light); col_str  <- ifelse(parity == 1, strong_dark,strong_light); col_gw   <- ifelse(parity == 1, gw_dark,    gw_light)
      
      man_df$col_pick <- ifelse(man_df$fdr < FDR05 & abs(man_df$beta) > 0.01, col_gw, ifelse(man_df$fdr < FDR10 & abs(man_df$beta) > 0.01, col_str, ifelse(man_df$fdr < FDR20 & abs(man_df$beta) > 0.01, col_med, col_base)))
      man_df$pt_size <- ifelse(man_df$fdr < FDR05 & abs(man_df$beta) > 0.01, 1.2, ifelse(man_df$fdr < FDR10 & abs(man_df$beta) > 0.01, 0.9, ifelse(man_df$fdr < FDR20 & abs(man_df$beta) > 0.01, 0.6, 0.3)))
      
      # COLUMNA HÍBRIDA PARA MANHATTAN
      man_df <- man_df %>% mutate(label_txt = ifelse(!is.na(gene) & gene != "", gene, probeID))
      
      manhattan <- ggplot(man_df, aes(x = pos_cum, y = log10p)) +
        geom_point(aes(color = col_pick, size = pt_size), alpha = 0.85) + scale_color_identity() + scale_size_identity() +
        { if (is.finite(thr_log10_fdr20)) geom_hline(yintercept = thr_log10_fdr20, colour = "red",  linetype = "dotted", linewidth=0.8) } +
        { if (is.finite(thr_log10_fdr10)) geom_hline(yintercept = thr_log10_fdr10, colour = "red",  linetype = "dashed", linewidth=0.8) } +
        { if (is.finite(thr_log10_fdr05)) geom_hline(yintercept = thr_log10_fdr05, colour = "#B22222",  linetype = "dashed", linewidth=1.2) } +
        scale_x_continuous(labels = axis_df$chr_txt, breaks = axis_df$center, expand = expansion(mult = c(0.01, 0.01))) +
        theme_classic(base_size = 18) + xlab(expression(bold("Chromosome"))) + ylab(expression(bold(-log[10](p-value)))) +
        ggtitle(pub_title_of(code, label)) +
        theme(plot.title = element_text(hjust = 0.5, size = 22, face = "bold"), axis.title = element_text(size = 18, face = "bold"), axis.text.x = element_text(angle = 0, vjust = 1, hjust = 0.5, margin = margin(t = 6), size = 12, color="black"), axis.text.y = element_text(size = 14, color="black"))
      
      man_lab <- man_df %>% filter(fdr < 0.10 & abs(beta) > 0.01) %>% arrange(p) %>% slice_head(n = 10)
      if (nrow(man_lab)) {
        manhattan <- manhattan + ggrepel::geom_label_repel(
          data = man_lab, aes(x = pos_cum, y = log10p, label = label_txt), 
          size = 4.5, label.size = 0.3, box.padding = 0.5, point.padding = 0.5, 
          max.overlaps = 200, min.segment.length = 0, segment.alpha = 0.7, fontface = "bold"
        )
      }
      ggsave(png_manh, manhattan, width = 13, height = 8, dpi = 300)
    }
  }
  
  # Resumen final por comparación
  summary_tbl <- tibble(
    comparison        = if (!is.null(code) && nzchar(code)) paste0(code, " — ", label) else label,
    n_tested          = sum(is.finite(res$p)),
    n_p_lt_0_05       = sum(res$p < 0.05, na.rm = TRUE),
    n_FDR_lt_0_20     = sum(res$fdr < 0.20, na.rm = TRUE),
    n_FDR_lt_0_10     = sum(res$fdr < 0.10, na.rm = TRUE),
    n_FDR_lt_0_05     = sum(res$fdr < 0.05, na.rm = TRUE),
    n_Hits_05_Beta01  = sum(res$fdr < 0.05 & abs(res$beta) > 0.01, na.rm = TRUE), 
    n_Bonf_lt_0_05    = sum(res$bonf < 0.05, na.rm = TRUE),
    lambda_GC         = {
      valid_p   <- res$p[is.finite(res$p) & res$p > 0 & res$p <= 1]
      chisq_obs <- suppressWarnings(qchisq(1 - valid_p, df = 1))
      if (length(chisq_obs)) median(chisq_obs, na.rm = TRUE) / 0.456 else NA_real_
    },
    results_csv       = csv_main, fdr_csv = csv_fdr, hits_csv = csv_hits, top20_csv = csv_top, top20_genes_csv = csv_top_genes, qq_png = png_qq, volcano_png = png_volc, manhattan_png = png_manh
  )
  summary_csv <- file.path(report_dir, paste0("EWAS_", code_prefix, label, "_SUMMARY.csv"))
  write_csv(summary_tbl, summary_csv)
  
  cat("\n[OK] Task completada para", label, "!\n")
}

# ---------------------- Listas y Mapeo ----------------------
inputs <- list(
  "df_A1_asthma_GLOBAL_vs_CONTROLS"             = "asthma_GLOBAL_vs_CONTROLS",
  "df_A2_asthma_ATOPIC_vs_Control_Atopic"       = "asthma_ATOPIC_vs_Control_Atopic",
  "df_A3_asthma_NONATOPIC_vs_Control_NonAtopic" = "asthma_NONATOPIC_vs_Control_NonAtopic",
  "df_B5_atopy_CONTROLS_C6_vs_C4"               = "atopy_CONTROLS_C6_vs_C4",
  "df_B6_atopy_IN_ASTHMA"                       = "atopy_IN_ASTHMA",
  "df_B7_atopy_GLOBAL"                          = "atopy_GLOBAL",
  "df_A7_severity_INDEPENDENT"                  = "severity_INDEPENDENT",
  "df_A8_severity_ATOPIC_C1_vs_C3"             = "severity_ATOPIC_C1_vs_C3",
  "df_A9_phenotype_signature_C1_vs_rest"       = "phenotype_signature_C1_vs_rest",
  "df_A10_phenotype_signature_C2_vs_rest"       = "phenotype_signature_C2_vs_rest",
  "df_A11_phenotype_signature_C3_vs_rest"       = "phenotype_signature_C3_vs_rest",
  "df_A12_phenotype_signature_C4_vs_rest"       = "phenotype_signature_C4_vs_rest",
  "df_A13_phenotype_signature_C5_vs_rest"       = "phenotype_signature_C5_vs_rest",
  "df_A14_phenotype_signature_C6_vs_rest"       = "phenotype_signature_C6_vs_rest"
)

code_map <- c(
  "asthma_GLOBAL_vs_CONTROLS" = "A1", "asthma_ATOPIC_vs_Control_Atopic" = "A2", "asthma_NONATOPIC_vs_Control_NonAtopic" = "A3",
  "atopy_CONTROLS_C6_vs_C4" = "A4", "atopy_IN_ASTHMA" = "A5", "atopy_GLOBAL" = "A6",
  "severity_INDEPENDENT" = "A7", "severity_ATOPIC_C1_vs_C3" = "A8",
  "phenotype_signature_C1_vs_rest" = "A9", "phenotype_signature_C2_vs_rest" = "A10", "phenotype_signature_C3_vs_rest" = "A11", "phenotype_signature_C4_vs_rest" = "A12", "phenotype_signature_C5_vs_rest" = "A13", "phenotype_signature_C6_vs_rest" = "A14"
)

# ---- Ejecutar el que toca según TASK_ID ----
if (task_id < 1 || task_id > length(inputs)) {
  stop(paste("ERROR: SLURM_ARRAY_TASK_ID debe estar entre 1 y", length(inputs)))
}

nm <- names(inputs)[task_id]
label <- inputs[[nm]]
code  <- unname(code_map[label])

rpath <- file.path(data_folder, paste0(nm, ".RData"))
cat("\n[EWAS] Running Task", task_id, ":", if (!is.na(code)) paste0(code, " — "), label, "\n")
run_one_ewas(rpath, label, code = ifelse(is.na(code), NULL, code))