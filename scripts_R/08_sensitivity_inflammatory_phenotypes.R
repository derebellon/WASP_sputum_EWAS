###############################################################################
# Script 04c - Sensitivity EWAS by sputum inflammatory phenotype
#              (one-vs-rest EWAS + enrichment + cross-signature overlap)
#
# This is the expanded version of the earlier eosinophilic/neutrophilic
# sensitivity script. It now:
#   1. Runs a one-versus-rest EWAS for every sputum inflammatory phenotype
#      (eosinophilic, neutrophilic, mixed-granulocytic, paucigranulocytic),
#      WITHOUT cell-fraction adjustment (age + sex + SVA only), using the same
#      meffil.ewas engine as the main pipeline.
#   2. Runs KEGG and GO enrichment for each phenotype signature with the same
#      adaptive-tier missMethyl::gometh procedure used in the main enrichment.
#   3. Quantifies how many CpG Hits are shared (a) between each inflammatory
#      phenotype and each of the others, and (b) between the union of the four
#      inflammatory signatures and the primary LCA phenotype signatures.
#   4. Produces the overlap figures: one TOTAL figure (inflammatory union vs
#      primary phenotype union) and one PER-phenotype figure (each phenotype vs
#      every other phenotype), plus a four-set Venn and a shared-count heatmap.
#
# Design note: the inflammatory phenotypes are defined by the sputum differential
# cell count, so adjusting for estimated cell fractions would be partly circular
# and would remove the biology under study. These models therefore omit cell
# fractions by design and are treated as hypothesis-generating.
#
# Runs on the HPC. Paths default to the cluster layout and can be overridden with
# environment variables (see the CONFIG block).
#
# Author: David Esteban Rebellon-Sanchez  |  WASP Study
###############################################################################

rm(list = ls())

# --- Install optional packages if missing (matches original script behaviour) -
for (pkg in c("ggVennDiagram")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    install.packages(pkg, repos = "http://cran.us.r-project.org")
}

suppressPackageStartupMessages({
  library(meffil)
  library(dplyr)
  library(ggplot2)
  library(stringr)
  library(purrr)
  library(tibble)
  library(ggrepel)
  library(tidyr)
  library(ggVennDiagram)
  library(missMethyl)
  library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)
})

# ---- Parallelisation (same as the rest of the pipeline) ----
n_cores <- as.integer(Sys.getenv("SLURM_CPUS_PER_TASK", unset = 4))
Sys.setenv(OMP_NUM_THREADS = "1", MKL_NUM_THREADS = "1", OPENBLAS_NUM_THREADS = "1")
options(mc.cores = n_cores)

cat("=======================================================\n")
cat("Sensitivity EWAS by sputum inflammatory phenotype\n")
cat("Using", n_cores, "cores via mclapply\n")
cat("=======================================================\n\n")

# ---------------------- CONFIG (env-overridable) ----------------------
cfg <- function(name, default) {
  v <- Sys.getenv(name, unset = NA); if (is.na(v) || v == "") default else v
}
source("scripts_R/00_config.R")
data_folder <- DATA_DIR
main_dir    <- EWAS_TAB_DIR
sens_dir    <- SENS_TAB_DIR
venn_dir    <- OVERLAP_TAB_DIR
sens_fig    <- SENS_FIG_DIR
venn_fig    <- SENS_FIG_DIR
# Which primary-EWAS CSVs count as the "primary phenotype signatures". Default:
# the one-vs-rest LCA phenotype fingerprints, which in the manuscript numbering
# are A9-A14 (classes C1-C6). Set to "^EWAS_A[0-9]+_" to use all primary contrasts.
primary_pattern <- cfg("PRIMARY_PATTERN", "^EWAS_A(9|1[0-4])_.*\\.csv$")

FDR_THR   <- as.numeric(cfg("FDR_THRESHOLD",   "0.05"))
BETA_THR  <- as.numeric(cfg("DBETA_THRESHOLD", "0.01"))

for (d in c(sens_dir, venn_dir)) if (!dir.exists(d)) dir.create(d, recursive = TRUE)

# Publication-ready display names for the inflammatory phenotypes.
pub_name <- c(
  Eosinophilic          = "Eosinophilic asthma",
  Neutrophilic          = "Neutrophilic asthma",
  Mixed                 = "Mixed-granulocytic asthma",
  Mixed_granulocytic    = "Mixed-granulocytic asthma",
  "Mixed granulocytic"  = "Mixed-granulocytic asthma",
  Paucigranulocytic     = "Paucigranulocytic asthma"
)
pub_of <- function(x) ifelse(x %in% names(pub_name), pub_name[x], x)

###############################################################################
# PART 1 - ONE-VS-REST EWAS FOR EACH INFLAMMATORY PHENOTYPE
###############################################################################
cat("\n[INFO] --- PART 1: sensitivity EWAS ---\n")

cat("[INFO] Loading harmonised data...\n")
load(file.path(data_folder, "beta_total_meffil.RData"))          # -> beta_total_meffil
load(file.path(data_folder, "clinical_QC-EPIGEN_meffil.RData"))  # -> qc_epigen_df

# Resolve the .x / .y suffix collision on the phenotype column, as in the original.
if ("sputum_phenotype1_first.x" %in% names(qc_epigen_df)) {
  qc_epigen_df <- qc_epigen_df %>%
    dplyr::rename(sputum_phenotype1_first = sputum_phenotype1_first.x) %>%
    dplyr::select(-dplyr::any_of("sputum_phenotype1_first.y"))
}

asthma_sputum_df <- qc_epigen_df %>%
  filter(group == "Current asthma", !is.na(sputum_phenotype1_first)) %>%
  mutate(sputum_phenotype1_first = as.character(sputum_phenotype1_first))

cat(sprintf("\n[INFO] N asthmatics with valid sputum = %d\n", nrow(asthma_sputum_df)))
print(table(asthma_sputum_df$sputum_phenotype1_first, useNA = "ifany"))

beta_sputum <- beta_total_meffil[, asthma_sputum_df$Sample_Name, drop = FALSE]
stopifnot(identical(colnames(beta_sputum), asthma_sputum_df$Sample_Name))

# --- Column helpers (kept from the original for robustness) ---
pick_first <- function(df, cand, def = NA) {
  matches <- cand[cand %in% names(df)]
  if (length(matches) == 0) return(rep(def, nrow(df)))
  df[[matches[1]]]
}
coalesce_cols_chr <- function(df, candidates) {
  out <- rep(NA_character_, nrow(df))
  for (nm in candidates) if (nm %in% names(df)) {
    v <- as.character(df[[nm]]); out[is.na(out) | out == ""] <- v[is.na(out) | out == ""]
  }
  out
}
coalesce_cols_num <- function(df, candidates) {
  out <- rep(NA_real_, nrow(df))
  for (nm in candidates) if (nm %in% names(df)) {
    v <- suppressWarnings(as.numeric(df[[nm]])); take <- is.na(out) & !is.na(v); out[take] <- v[take]
  }
  out
}
log10_line_for_fdr <- function(p, fdr, q) {
  p_ok <- p[fdr < q & is.finite(p)]; if (length(p_ok)) -log10(max(p_ok, na.rm = TRUE)) else NA_real_
}
std_annot <- function(annot) {
  a <- as.data.frame(annot, stringsAsFactors = FALSE)
  if (!"chromosome" %in% names(a)) {
    if ("chr" %in% names(a)) a$chromosome <- a$chr else if ("seqnames" %in% names(a)) a$chromosome <- a$seqnames
  }
  if (!"position" %in% names(a)) {
    if ("pos" %in% names(a)) a$position <- a$pos else if ("mapinfo" %in% names(a)) a$position <- a$mapinfo
  }
  a
}

# --- Main EWAS function (same engine as the original, publication title added) -
run_sensitivity_ewas <- function(pheno_target) {
  label <- paste0("Sputum_", pheno_target, "_vs_Rest")
  cat("\n[EWAS] Running:", label, "\n")

  keep <- asthma_sputum_df %>%
    mutate(comparison = ifelse(sputum_phenotype1_first == pheno_target, pheno_target, "(rest)"),
           comparison = factor(comparison, levels = c("(rest)", pheno_target)))

  covar_names <- c("sex", "age")            # NO cell fractions, by design
  ok <- complete.cases(keep[, c("comparison", covar_names)])
  beta_sub <- beta_sputum[, ok, drop = FALSE]
  keep     <- keep[ok, , drop = FALSE]

  set.seed(12345)
  ew <- meffil.ewas(beta_sub, variable = keep$comparison,
                    covariates = keep[, covar_names, drop = FALSE], sva = TRUE)

  res <- ew$analyses$all$table %>% as.data.frame(stringsAsFactors = FALSE)
  res$probeID <- rownames(res)
  res$beta   <- as.numeric(pick_first(res, c("coefficient", "beta", "estimate"), NA_real_))
  res$p      <- as.numeric(pick_first(res, c("p.value", "p"), NA_real_))
  res$log10p <- -log10(res$p); res$log10p[!is.finite(res$log10p)] <- NA_real_

  annot <- std_annot(meffil.get.features("epic"))
  keep_annot <- intersect(c("name", "chromosome", "position", "gene", "gene.symbol"), names(annot))
  annot <- annot[, keep_annot, drop = FALSE]
  res <- res %>% left_join(annot, by = c("probeID" = "name"))

  res$chromosome <- coalesce_cols_chr(res, c("chromosome", "chromosome.x", "chromosome.y", "chr", "seqnames"))
  res$position   <- coalesce_cols_num(res, c("position", "position.x", "position.y", "pos", "mapinfo", "bp"))
  res$gene       <- coalesce_cols_chr(res, c("gene.symbol", "gene.symbol.x", "gene.symbol.y", "gene", "gene.x", "gene.y"))
  if (is.character(res$chromosome)) {
    res$chromosome <- gsub("^chr", "", res$chromosome, ignore.case = TRUE)
    res$chromosome[res$chromosome %in% c("X", "x")] <- "23"
    res$chromosome[res$chromosome %in% c("Y", "y")] <- "24"
  }
  res$chromosome <- suppressWarnings(as.integer(res$chromosome))
  res$position   <- suppressWarnings(as.numeric(res$position))
  res$gene       <- ifelse(!is.na(res$gene) & res$gene != "", sub(";.*", "", res$gene), NA_character_)

  res <- res[order(res$p), , drop = FALSE]
  res$fdr <- p.adjust(res$p, "fdr")

  stem <- paste0("EWAS_SENSITIVITY_", label)
  write.csv(res, file.path(sens_dir, paste0(stem, ".csv")), row.names = FALSE)

  # Volcano plot with a publication-ready title (no "Volcano Plot" banner, no jargon).
  png_volc <- file.path(sens_fig, paste0("VOLCANO_", label, ".png"))
  thr_log10_fdr05 <- log10_line_for_fdr(res$p, res$fdr, 0.05)
  plot_df <- res %>% filter(is.finite(beta), is.finite(log10p), is.finite(fdr)) %>%
    mutate(category = factor(ifelse(fdr < FDR_THR & abs(beta) > BETA_THR,
                                    ifelse(beta > 0, "Up", "Down"), "Not Sig"),
                             levels = c("Down", "Not Sig", "Up")),
           label_txt = ifelse(!is.na(gene) & gene != "", gene, probeID))
  volcano <- ggplot(plot_df, aes(x = beta, y = log10p, color = category)) +
    geom_point(alpha = 0.85, size = 1.2) +
    { if (is.finite(thr_log10_fdr05))
        geom_hline(yintercept = thr_log10_fdr05, colour = "#B22222", linetype = "dashed", linewidth = 1.2) } +
    geom_vline(xintercept = c(-BETA_THR, BETA_THR), linetype = "dotted", color = "black", linewidth = 0.8) +
    scale_color_manual(values = c("Down" = "#84D2F6", "Not Sig" = "#54494B", "Up" = "#FF8C00"), drop = FALSE) +
    theme_classic(base_size = 18) +
    labs(x = expression(bold("Methylation difference (" * Delta * beta * ")")),
         y = expression(bold(-log[10](italic(p)))),
         title = paste0(pub_of(pheno_target), " versus other asthma phenotypes")) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"), legend.position = "none")
  lab_df <- plot_df %>% filter(category != "Not Sig", abs(beta) > BETA_THR) %>%
    group_by(category) %>% slice_min(fdr, n = 8)
  if (nrow(lab_df))
    volcano <- volcano + ggrepel::geom_label_repel(data = lab_df, aes(label = label_txt),
                                                   size = 4, fontface = "bold", max.overlaps = 50)
  ggsave(png_volc, volcano, width = 11, height = 8, dpi = 300)

  n_hits <- sum(res$fdr < FDR_THR & abs(res$beta) > BETA_THR, na.rm = TRUE)
  cat("  -> OK. Hits (FDR<", FDR_THR, ", |Beta|>", BETA_THR, "):", n_hits, "\n")
  tibble(Phenotype = pheno_target, Hits = n_hits,
         csv = file.path(sens_dir, paste0(stem, ".csv")))
}

phenotypes <- sort(unique(asthma_sputum_df$sputum_phenotype1_first))
phenotypes <- phenotypes[!is.na(phenotypes)]
summary_sens <- map_dfr(phenotypes, run_sensitivity_ewas)
write.csv(summary_sens, file.path(sens_dir, "SENSITIVITY_SUMMARY.csv"), row.names = FALSE)

###############################################################################
# PART 2 - ENRICHMENT (KEGG + GO) FOR EACH PHENOTYPE SIGNATURE
#          Same adaptive-tier gometh procedure as the main enrichment step.
###############################################################################
cat("\n[INFO] --- PART 2: enrichment (missMethyl gometh) ---\n")

run_adaptive_gometh <- function(csv_path, comp_id, collection) {
  df <- read.csv(csv_path, stringsAsFactors = FALSE)
  all_cpgs <- df$probeID
  tiers <- list(
    list(name = "Tier1_Beta10", fdr = 0.20, beta = 0.10),
    list(name = "Tier2_Beta05", fdr = 0.20, beta = 0.05),
    list(name = "Tier3_Beta02", fdr = 0.20, beta = 0.02)
  )
  selected <- NULL; final <- NULL; final_cpgs <- NULL
  for (t in tiers) {
    cand <- df %>% filter(fdr < t$fdr, abs(beta) >= t$beta) %>% pull(probeID)
    if (length(cand) >= 10) {
      res_try <- tryCatch(
        gometh(sig.cpg = cand, all.cpg = all_cpgs, collection = collection,
               array.type = "EPIC", prior.prob = TRUE, sig.genes = TRUE),
        error = function(e) NULL)
      if (!is.null(res_try)) {
        top <- topGSA(res_try, number = Inf)
        selected <- t; final <- top; final_cpgs <- cand
        if (sum(top$FDR < 0.20, na.rm = TRUE) > 0) break
      }
    }
  }
  if (is.null(final)) {
    return(data.frame(ID = comp_id, Collection = collection, Status = "No_Signal",
                      Used_Tier = "None", Input_CpGs = 0, Terms_Found = 0))
  }
  sig_terms <- final %>% filter(FDR < 0.20)
  if (nrow(sig_terms) > 0) {
    sig_terms$comp_id <- comp_id
    write.csv(sig_terms,
              file.path(sens_dir, paste0(collection, "_SIG_", comp_id, ".csv")),
              row.names = FALSE)
  }
  data.frame(ID = comp_id, Collection = collection, Status = "Success",
             Used_Tier = selected$name, Input_CpGs = length(final_cpgs),
             Terms_Found = nrow(sig_terms))
}

enr_log <- list()
for (i in seq_len(nrow(summary_sens))) {
  ph  <- summary_sens$Phenotype[i]; csvp <- summary_sens$csv[i]
  cid <- paste0("Sputum_", ph)
  for (coll in c("KEGG", "GO")) {
    cat("[ENRICH]", cid, "-", coll, "\n")
    enr_log[[paste(cid, coll)]] <- run_adaptive_gometh(csvp, cid, coll)
  }
}
write.csv(bind_rows(enr_log), file.path(sens_dir, "ENRICHMENT_LOG.csv"), row.names = FALSE)

###############################################################################
# PART 3 - CROSS-SIGNATURE OVERLAP
###############################################################################
cat("\n[INFO] --- PART 3: cross-signature overlap ---\n")

get_hits <- function(filepath) {
  if (!file.exists(filepath)) return(character(0))
  df <- read.csv(filepath, stringsAsFactors = FALSE)
  if (all(c("fdr", "beta") %in% names(df)))
    df <- df[df$fdr < FDR_THR & abs(df$beta) > BETA_THR, , drop = FALSE]
  unique(df$probeID)
}
jaccard <- function(a, b) { u <- length(union(a, b)); if (u == 0) NA_real_ else length(intersect(a, b)) / u }

# Inflammatory-phenotype signatures.
signatures <- setNames(lapply(summary_sens$csv, get_hits), summary_sens$Phenotype)
signatures <- signatures[order(names(signatures))]
phenos     <- names(signatures)
infl_union <- unique(unlist(signatures))

# Primary LCA phenotype signatures (union of the selected primary EWAS CSVs).
primary_files <- list.files(main_dir, pattern = primary_pattern, full.names = TRUE)
primary_sets  <- setNames(lapply(primary_files, get_hits),
                          tools::file_path_sans_ext(basename(primary_files)))
primary_union <- unique(unlist(primary_sets))
cat("[INFO] Primary phenotype signature files:", length(primary_files),
    "| union CpGs:", length(primary_union), "\n")

## 3a. Pairwise overlap between inflammatory phenotypes ------------------------
pair_rows <- data.frame()
for (i in phenos) for (j in phenos) if (i != j) pair_rows <- rbind(pair_rows, data.frame(
  phenotype = i, other = j,
  n_shared = length(intersect(signatures[[i]], signatures[[j]])),
  n_self = length(signatures[[i]]),
  pct_of_self = ifelse(length(signatures[[i]]) == 0, NA,
                       100 * length(intersect(signatures[[i]], signatures[[j]])) / length(signatures[[i]])),
  jaccard = jaccard(signatures[[i]], signatures[[j]])))
write.csv(pair_rows, file.path(venn_dir, "overlap_inflammatory_pairwise.csv"), row.names = FALSE)

## 3b. Each inflammatory phenotype vs the union of the other phenotypes --------
vs_rest_rows <- data.frame()
for (i in phenos) {
  others <- unique(unlist(signatures[setdiff(phenos, i)]))
  vs_rest_rows <- rbind(vs_rest_rows, data.frame(
    phenotype = i, n_self = length(signatures[[i]]),
    n_shared_with_other_infl = length(intersect(signatures[[i]], others)),
    n_unique_to_self = length(setdiff(signatures[[i]], others))))
}
write.csv(vs_rest_rows, file.path(venn_dir, "overlap_inflammatory_vs_others.csv"), row.names = FALSE)

## 3c. Inflammatory signatures vs primary phenotype signatures -----------------
primary_rows <- data.frame(
  comparison = "ALL_inflammatory_union_vs_ALL_primary_union",
  n_inflammatory = length(infl_union), n_primary = length(primary_union),
  n_shared = length(intersect(infl_union, primary_union)),
  pct_of_inflammatory = 100 * length(intersect(infl_union, primary_union)) / max(1, length(infl_union)),
  pct_of_primary = 100 * length(intersect(infl_union, primary_union)) / max(1, length(primary_union)),
  jaccard = jaccard(infl_union, primary_union))
for (i in phenos) primary_rows <- rbind(primary_rows, data.frame(
  comparison = paste0(i, "_vs_ALL_primary_union"),
  n_inflammatory = length(signatures[[i]]), n_primary = length(primary_union),
  n_shared = length(intersect(signatures[[i]], primary_union)),
  pct_of_inflammatory = ifelse(length(signatures[[i]]) == 0, NA,
                               100 * length(intersect(signatures[[i]], primary_union)) / length(signatures[[i]])),
  pct_of_primary = 100 * length(intersect(signatures[[i]], primary_union)) / max(1, length(primary_union)),
  jaccard = jaccard(signatures[[i]], primary_union)))
write.csv(primary_rows, file.path(venn_dir, "overlap_inflammatory_vs_primary.csv"), row.names = FALSE)
writeLines(sort(intersect(infl_union, primary_union)),
           file.path(venn_dir, "shared_cpgs_inflammatory_vs_primary.txt"))

###############################################################################
# PART 4 - FIGURES (total + per-phenotype), all with publication titles
###############################################################################
cat("\n[INFO] --- PART 4: figures ---\n")

## 4a. TOTAL figure: inflammatory union vs primary phenotype union -------------
shared <- length(intersect(infl_union, primary_union))
totdf <- data.frame(
  set = factor(c("Inflammatory only", "Shared", "Primary phenotype only"),
               levels = c("Inflammatory only", "Shared", "Primary phenotype only")),
  n = c(length(setdiff(infl_union, primary_union)), shared,
        length(setdiff(primary_union, infl_union))))
p_tot <- ggplot(totdf, aes(set, n, fill = set)) +
  geom_col(width = 0.65) + geom_text(aes(label = n), vjust = -0.3, size = 5, fontface = "bold") +
  scale_fill_manual(values = c("Inflammatory only" = "#84D2F6", "Shared" = "#8e44ad",
                               "Primary phenotype only" = "#FF8C00")) +
  labs(title = "Shared airway methylation signatures across phenotyping approaches",
       subtitle = sprintf("Inflammatory-phenotype and LCA-phenotype CpG signatures (FDR < %.2f, |Δβ| > %.2f)", FDR_THR, BETA_THR),
       x = NULL, y = "Differentially methylated CpGs") +
  theme_classic(base_size = 16) +
  theme(plot.title = element_text(face = "bold"), legend.position = "none")
ggsave(file.path(venn_fig, "overlap_TOTAL_inflammatory_vs_primary.png"), p_tot, width = 9, height = 6, dpi = 300)

## 4b. PER-phenotype figure: each phenotype vs each other phenotype ------------
per_rows <- pair_rows[, c("phenotype", "other", "n_shared")]
per_rows$phenotype_lab <- pub_of(per_rows$phenotype)
per_rows$other_lab     <- pub_of(per_rows$other)
p_per <- ggplot(per_rows, aes(other_lab, n_shared, fill = other_lab)) +
  geom_col(width = 0.7) + geom_text(aes(label = n_shared), vjust = -0.3, size = 3.5, fontface = "bold") +
  facet_wrap(~ phenotype_lab, scales = "free_y") +
  labs(title = "Shared differentially methylated CpGs between inflammatory asthma phenotypes",
       subtitle = "Each panel shows one phenotype's signature against every other phenotype",
       x = NULL, y = "Shared CpGs") +
  theme_bw(base_size = 12) +
  theme(plot.title = element_text(face = "bold"), legend.position = "none",
        axis.text.x = element_text(angle = 30, hjust = 1))
ggsave(file.path(venn_fig, "overlap_PER_phenotype.png"), p_per, width = 10, height = 8, dpi = 300)

## 4c. Four-set Venn across inflammatory phenotypes ----------------------------
if (length(phenos) >= 2 && length(phenos) <= 4) {
  venn_list <- setNames(signatures, pub_of(phenos))
  p_venn <- ggVennDiagram(venn_list, label_alpha = 0, set_color = "black") +
    scale_fill_gradient(low = "#F7FBFF", high = "#08306B", name = "CpGs") +
    labs(title = "Overlap of inflammatory-phenotype methylation signatures",
         subtitle = sprintf("Differentially methylated CpGs (FDR < %.2f, |Δβ| > %.2f)", FDR_THR, BETA_THR)) +
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
          plot.subtitle = element_text(size = 12, hjust = 0.5, color = "grey30"))
  ggsave(file.path(venn_fig, "Venn_inflammatory_phenotypes.png"), p_venn, width = 10, height = 8, dpi = 300)
}

## 4d. Shared-count heatmap between inflammatory phenotypes --------------------
hm <- expand.grid(a = phenos, b = phenos, stringsAsFactors = FALSE)
hm$n_shared <- mapply(function(a, b) length(intersect(signatures[[a]], signatures[[b]])), hm$a, hm$b)
hm$a_lab <- pub_of(hm$a); hm$b_lab <- pub_of(hm$b)
p_hm <- ggplot(hm, aes(a_lab, b_lab, fill = n_shared)) +
  geom_tile(colour = "white") + geom_text(aes(label = n_shared), size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#f2f4f4", high = "#1f618d", name = "Shared CpGs") +
  labs(title = "Shared CpGs between inflammatory asthma phenotypes", x = NULL, y = NULL) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"), axis.text.x = element_text(angle = 30, hjust = 1))
ggsave(file.path(venn_fig, "overlap_inflammatory_heatmap.png"), p_hm, width = 8, height = 7, dpi = 300)

## 4e. Total three-way Venn (inflammatory union vs primary union) as a set view -
p_setvenn <- ggVennDiagram(list("Inflammatory phenotypes" = infl_union,
                                 "LCA phenotypes" = primary_union),
                           label_alpha = 0, set_color = "black") +
  scale_fill_gradient(low = "#F7FBFF", high = "#08306B", name = "CpGs") +
  labs(title = "Total overlap: inflammatory-phenotype vs LCA-phenotype signatures") +
  theme(plot.title = element_text(face = "bold", size = 16, hjust = 0.5))
ggsave(file.path(venn_fig, "Venn_TOTAL_inflammatory_vs_primary.png"), p_setvenn, width = 9, height = 7, dpi = 300)

cat("\n=======================================================\n")
cat("Done. Outputs in:\n  ", sens_dir, "\n  ", venn_dir, "\n")
cat("=======================================================\n")
