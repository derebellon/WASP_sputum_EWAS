###############################################################################
# Script 08 — THE FINAL ANALYSIS (Broad Discovery - KEGG & GO)
# Lógica Híbrida Solicitada: 
# - Enriquecer con HITS Oficiales (FDR < 0.05 y |Beta| > 0.01).
# - Si hay > 200 HITS: Se trunca a los 200 mejores.
# - Si hay < 200 HITS: Se toman todos los HITS y se completa la lista hasta 200 
#   usando los siguientes mejores CpGs (ordenados por FDR y Beta).
###############################################################################

rm(list = ls())
suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(stringr)
  library(tibble)
  library(ggplot2)
  library(scales) 
  library(missMethyl)
  library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19) 
})

# 1. SETUP
task_id <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))
if (is.na(task_id)) stop("Error: No se detectó SLURM_ARRAY_TASK_ID")

source("scripts_R/00_config.R")
base_report_dir <- EWAS_TAB_DIR
main_out_dir    <- ENRICH_TAB_DIR 
if (!dir.exists(main_out_dir)) dir.create(main_out_dir, recursive = TRUE)

desc_map <- c(
  "A1"  = "Global Asthma (C1,2,3,5) vs Controls (C4,6)", 
  "A2"  = "Atopic Asthma (C1,3) vs Atopic Control (C6)",
  "A3"  = "Non-atopic Asthma (C2,5) vs Healthy Control (C4)", 
  "A4"  = "Atopy in Controls: Atopic Control (C6) vs Healthy Control (C4)",
  "A5"  = "Atopy in Asthma: Atopic Asthma (C1,3) vs Non-atopic Asthma (C2,5)", 
  "A6"  = "Global Atopy: (C1,3,6) vs (C2,4,5)", 
  "A7"  = "Severity - Global Signature: Severe (C1,2) vs Mild-Moderate (C3,5)", 
  "A8" = "Severity - Atopic Asthma: Severe (C1) vs Mild-Moderate (C3)",
  "A9" = "C1 Fingerprint (Severe Atopic Asthma) vs Rest",
  "A10" = "C2 Fingerprint (Severe Non-atopic Asthma) vs Rest",
  "A11" = "C3 Fingerprint (Mild-Moderate Atopic Asthma) vs Rest",
  "A12" = "C4 Fingerprint (Healthy Control) vs Rest",
  "A13" = "C5 Fingerprint (Mild-Moderate Non-atopic Asthma) vs Rest",
  "A14" = "C6 Fingerprint (Atopic Control) vs Rest"
)

all_files <- list.files(base_report_dir, pattern = "^EWAS_A[0-9]+_.*\\.csv$", full.names = TRUE)
all_files <- all_files[!grepl("FDR|Top20|SUMMARY|UNION|RESUMEN|DIAGNOSTICO|HITS", all_files)]
file_info <- tibble(path = all_files) %>%
  mutate(raw_id = str_extract(basename(path), "A[0-9]+"),
         num_id = as.numeric(str_remove(raw_id, "A"))) %>% arrange(num_id)

if (task_id > nrow(file_info)) stop("Task ID excede el número de archivos disponibles.")
current_file_row <- file_info[task_id, ]

# 2. FUNCIONES DE APOYO
fix_columns_final <- function(df) {
  colnames(df) <- toupper(colnames(df))
  if ("DESCRIPTION" %in% colnames(df)) { df$TERM_LABEL <- df$DESCRIPTION }
  else if ("TERM" %in% colnames(df)) { df$TERM_LABEL <- df$TERM }
  else if ("PATHWAY" %in% colnames(df)) { df$TERM_LABEL <- df$PATHWAY }
  df$TERM_LABEL <- str_to_title(df$TERM_LABEL)
  df$TERM_LABEL <- str_replace_all(df$TERM_LABEL, "Kegg", "KEGG")
  return(df)
}

draw_final_plot <- function(df, out_path, title, sub, is_go = FALSE) {
  df <- fix_columns_final(df)
  
  # FILTRO ESTRICTO: Solo graficar si FDR < 0.20
  plot_data_full <- df %>% filter(FDR < 0.20)
  
  if (nrow(plot_data_full) == 0) {
    p_empty <- ggplot() + 
      annotate("text", x = 0.5, y = 0.5, label = "No relevant pathways were found (FDR < 0.20)", size = 8, fontface = "bold", color="grey40") +
      theme_void() + labs(title = title, subtitle = sub) +
      theme(plot.title = element_text(face = "bold", size = 20, hjust = 0.5), plot.subtitle = element_text(size = 15, color = "grey30", hjust = 0.5))
    ggsave(out_path, p_empty, width = 13, height = 11, bg = "white", dpi = 300)
    return()
  }
  
  if(is_go) {
    plot_data_full$ONTOLOGY <- str_trim(as.character(plot_data_full$ONTOLOGY))
    plot_data <- plot_data_full %>% group_by(ONTOLOGY) %>% arrange(P.DE) %>% slice_head(n = 8) %>% ungroup()
  } else {
    plot_data <- plot_data_full %>% arrange(P.DE) %>% slice_head(n = 25)
  }
  
  plot_data <- plot_data %>% mutate(GR = DE / N, Term_Plot = reorder(str_wrap(str_trunc(TERM_LABEL, 55), 45), GR))
  
  p <- ggplot(plot_data, aes(x = GR, y = Term_Plot)) +
    geom_vline(xintercept = seq(0, 1, 0.1), color = "grey95", linetype = "solid") +
    geom_point(aes(size = DE, color = FDR)) +
    scale_color_gradient(low = "#E41A1C", high = "#377EB8", limits = c(0, 0.20), 
                         guide = guide_colorbar(reverse=TRUE), labels = scales::label_number(accuracy = 0.001)) + 
    theme_classic(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 20, hjust = 0),
      plot.subtitle = element_text(size = 15, color = "grey30", hjust = 0),
      axis.title = element_text(face = "bold", size = 16),
      axis.text.y = element_text(color = "black", face = "bold", size = 13),
      strip.text = element_text(face = "bold", size = 14),
      strip.background = element_blank(),
      panel.border = element_rect(colour = "black", fill=NA, linewidth=0.6)
    ) +
    labs(title = title, subtitle = sub, x = "Gene Ratio (DE / N)", y = NULL, size = "Gene Count", color = "FDR")
  
  if(is_go) { p <- p + facet_grid(ONTOLOGY ~ ., scales = "free_y", space = "free_y") }
  ggsave(out_path, p, width = 13, height = 11, bg = "white", dpi = 300)
}

# 4. EJECUCIÓN: TU LÓGICA HÍBRIDA EXACTA
message(sprintf(">>> Processing: %s", current_file_row$raw_id))
df_in <- read_csv(current_file_row$path, show_col_types = FALSE)
comp_id <- current_file_row$raw_id
desc    <- ifelse(!is.na(desc_map[comp_id]), desc_map[comp_id], comp_id)

TOP_N <- 200  # Tu límite objetivo

# 1. Buscamos los Hits Oficiales (FDR < 0.05 y |Beta| > 0.01)
hits_oficiales <- df_in %>% 
  filter(fdr < 0.05, abs(beta) > 0.01) %>% 
  arrange(fdr, desc(abs(beta))) %>% 
  pull(probeID)

# 2. Creamos una "Cantera" con todos los que cumplen tamaño de efecto biológico (|Beta| > 0.01)
# Ordenada estrictamente por significancia y luego por beta
cantera <- df_in %>% 
  filter(abs(beta) > 0.01) %>% 
  arrange(fdr, desc(abs(beta))) %>% 
  pull(probeID)

# 3. Aplicamos tu lógica de priorización
if (length(hits_oficiales) >= TOP_N) {
  # Si sobraron hits, nos quedamos solo con los Top 200
  cand <- hits_oficiales[1:TOP_N]
  message(sprintf("   - Se encontraron %d Hits. Truncando a los mejores %d.", length(hits_oficiales), TOP_N))
} else {
  # Si faltaron hits, usamos la 'cantera' para rellenar hasta 200.
  # Como la cantera está ordenada por FDR, los primeros elementos ya incluyen 
  # TODOS los hits oficiales, seguidos automáticamente por los mejores disponibles.
  cand <- head(cantera, TOP_N)
  message(sprintf("   - Se encontraron %d Hits. Completando hasta %d CpGs usando el ranking general.", length(hits_oficiales), length(cand)))
}

if(length(cand) >= 10) {
  # KEGG
  res_k <- tryCatch({ gometh(sig.cpg = cand, all.cpg = df_in$probeID, collection = "KEGG", array.type = "EPIC", sig.genes = TRUE) }, error = function(e) NULL)
  if(!is.null(res_k)) {
    tab_k <- topGSA(res_k, number = Inf)
    write_csv(tab_k, file.path(main_out_dir, paste0("RESULTS_KEGG_", comp_id, ".csv")))
    draw_final_plot(tab_k, file.path(ENRICH_FIG_DIR, paste0("FINAL_KEGG_", comp_id, ".png")), paste0("KEGG Pathway Enrichment: ", comp_id), desc)
  }
  
  # GO
  res_g <- tryCatch({ gometh(sig.cpg = cand, all.cpg = df_in$probeID, collection = "GO", array.type = "EPIC", sig.genes = TRUE) }, error = function(e) NULL)
  if(!is.null(res_g)) {
    tab_g <- topGSA(res_g, number = Inf)
    write_csv(tab_g, file.path(main_out_dir, paste0("RESULTS_GO_", comp_id, ".csv")))
    draw_final_plot(tab_g, file.path(ENRICH_FIG_DIR, paste0("FINAL_GO_", comp_id, ".png")), paste0("GO Enrichment Analysis: ", comp_id), desc, is_go = TRUE)
  }
} else {
  message(sprintf("Skipping %s: Not enough significant CpGs (Found %d, need at least 10).", comp_id, length(cand)))
}

message(">>> Done.")


###############################################################################
# Script Extra (VERSIÓN ULTRA RÁPIDA con data.table)
# Generador de "Volcano Champions" (Top 20 CpGs para el manuscrito)
###############################################################################

rm(list = ls())
suppressPackageStartupMessages({
  library(data.table)
  library(stringr)
})

# 1. Definir el directorio (re-source config: the rm(list=ls()) above cleared it)
source("scripts_R/00_config.R")
report_dir <- EWAS_TAB_DIR

# 2. Encontrar todos los archivos CSV principales
all_files <- list.files(report_dir, pattern = "^EWAS_A[0-9]+_.*\\.csv$", full.names = TRUE)
all_files <- all_files[!grepl("FDR|Top20|SUMMARY|UNION|RESUMEN|DIAGNOSTICO|HITS|CHAMPIONS", all_files)]

cat("Encontrados", length(all_files), "archivos principales para procesar.\n\n")

# 3. Procesar con data.table (Ultra rápido)
for(f in all_files) {
  comp_id <- str_extract(basename(f), "A[0-9]+")
  
  # Leer rapidísimo con fread
  dt <- fread(f)
  
  # Filtrar, ordenar (FDR ascendente, |beta| descendente) y seleccionar top 20
  top_volcano <- dt[is.finite(fdr) & is.finite(beta)][
    order(fdr, -abs(beta))
  ][1:20, .(probeID, gene, chromosome, position, beta, p, fdr)]
  
  # Generar nombre y guardar con fwrite
  out_name <- sub("\\.csv$", "_VOLCANO_CHAMPIONS.csv", f)
  fwrite(top_volcano, out_name)
  
  cat(sprintf("[OK] Procesado %s -> Guardado como: %s\n", comp_id, basename(out_name)))
}

cat("\n>>> ¡Proceso completado a máxima velocidad!\n")