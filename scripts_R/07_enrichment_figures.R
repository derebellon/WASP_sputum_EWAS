###############################################################################
# Script 08C — Subanálisis 2 (Top Pathways por Porcentaje de Enriquecimiento)
# Nueva métrica: Enrichment_Pct = (DE / N) * 100 (Rich Factor)
# Orden de priorización: 1º FDR (asc), 2º Enrichment_Pct (desc), 3º P.DE (asc)
###############################################################################

rm(list = ls())
suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(stringr)
  library(ggplot2)
  library(scales)
  library(gt)
})

# 1. RUTAS Y MAPEO
source("scripts_R/00_config.R")
main_dir <- ENRICH_TAB_DIR
sub_dir  <- ENRICH_FIG_DIR
if (!dir.exists(sub_dir)) dir.create(sub_dir, recursive = TRUE)

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

# Publication-ready figure titles (edit the wording here). Keyed by contrast code;
# the enrichment figures use these as their main title, with the analysis type
# (KEGG / GO) moved to the subtitle.
PUBLICATION_TITLES <- c(
  "A1"  = "Asthma versus non-asthmatic controls",
  "A2"  = "Atopic asthma versus atopic controls",
  "A3"  = "Non-atopic asthma versus non-atopic controls",
  "A4"  = "Atopy among controls",
  "A5"  = "Atopy within asthma",
  "A6"  = "Atopy overall",
  "A7"  = "Severe or uncontrolled versus mild or well-controlled asthma",
  "A8"  = "Severe versus mild atopic asthma",
  "A9"  = "Severe atopic asthma (C1) versus all other participants",
  "A10" = "Severe non-atopic asthma (C2) versus all other participants",
  "A11" = "Mild atopic asthma (C3) versus all other participants",
  "A12" = "Non-atopic controls (C4) versus all other participants",
  "A13" = "Mild non-atopic asthma (C5) versus all other participants",
  "A14" = "Atopic controls (C6) versus all other participants"
)
pub_title_of <- function(code)
  if (code %in% names(PUBLICATION_TITLES)) unname(PUBLICATION_TITLES[code]) else code

# 2. FUNCIÓN DE GRAFICADO CON EJE X EN PORCENTAJE
draw_pct_plot <- function(df, out_path, title, sub, is_go = FALSE) {
  
  plot_data <- df %>%
    mutate(Term_Plot = reorder(str_wrap(str_trunc(TERM_LABEL, 55), 45), Enrichment_Pct))
  
  p <- ggplot(plot_data, aes(x = Enrichment_Pct, y = Term_Plot)) +
    geom_vline(xintercept = seq(0, 100, 10), color = "grey95", linetype = "solid") +
    geom_point(aes(size = DE, color = FDR)) +
    scale_color_gradient(low = "#E41A1C", high = "#377EB8", 
                         guide = guide_colorbar(reverse=TRUE), 
                         labels = scales::label_number(accuracy = 0.001)) + 
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
    labs(title = title, subtitle = paste0(sub, "\n(Prioritized by Rich Factor / % Enrichment)"), 
         x = "Enrichment Percentage (%)", y = NULL, size = "Gene Count", color = "FDR")
  
  if(is_go) { p <- p + facet_grid(ONTOLOGY ~ ., scales = "free_y", space = "free_y") }
  
  ggsave(out_path, p, width = 13, height = 11, bg = "white", dpi = 300)
}

# 3. PROCESAMIENTO
for (comp_id in names(desc_map)) {
  desc <- desc_map[comp_id]
  
  kegg_file <- file.path(main_dir, paste0("RESULTS_KEGG_", comp_id, ".csv"))
  go_file   <- file.path(main_dir, paste0("RESULTS_GO_", comp_id, ".csv"))
  
  # ---------------------------------------------------------
  # A) ANÁLISIS KEGG (Top 15 priorizado por % de Enriquecimiento)
  # ---------------------------------------------------------
  if (file.exists(kegg_file)) {
    df_kegg <- read_csv(kegg_file, show_col_types = FALSE)
    
    col_desc <- if("Description" %in% colnames(df_kegg)) "Description" else if("PATHWAY" %in% colnames(df_kegg)) "PATHWAY" else colnames(df_kegg)[1]
    
    top_kegg <- df_kegg %>%
      mutate(
        Enrichment_Pct = (DE / N) * 100,
        TERM_LABEL = str_to_title(!!sym(col_desc))
      ) %>%
      # LA MAGIA: 1º FDR, 2º % de enriquecimiento mayor a menor, 3º valor p
      arrange(FDR, desc(Enrichment_Pct), P.DE) %>%
      slice_head(n = 15) 
    
    if (nrow(top_kegg) > 0) {
      draw_pct_plot(top_kegg, file.path(sub_dir, paste0("TOP15_KEGG_Pct_", comp_id, ".png")), 
                    pub_title_of(comp_id), "KEGG pathway enrichment (top 15)")
      
      tab_data_kegg <- top_kegg %>%
        select(Description = !!sym(col_desc), N, DE, Enrichment_Pct, P.DE, FDR, SigGenesInSet)
      
      write_csv(tab_data_kegg, file.path(sub_dir, paste0("TABLE_TOP15_KEGG_Pct_", comp_id, ".csv")))
      
      tab_data_kegg %>%
        gt() %>%
        tab_header(title = pub_title_of(comp_id), subtitle = "Top 15 KEGG pathways") %>%
        fmt_number(columns = c(P.DE, FDR), decimals = 4, drop_trailing_zeros = TRUE) %>%
        fmt_number(columns = Enrichment_Pct, decimals = 1) %>% # Un decimal para el %
        cols_label(Description = "Pathway", N = "Total Genes", DE = "Significant Genes", 
                   Enrichment_Pct = "Enrichment (%)", P.DE = "p-value", FDR = "FDR", SigGenesInSet = "Genes in Set") %>%
        opt_stylize() %>%
        gtsave(filename = file.path(sub_dir, paste0("TABLE_TOP15_KEGG_Pct_", comp_id, ".html")))
    }
  }
  
  # ---------------------------------------------------------
  # B) ANÁLISIS GO (Top 5 por Ontología priorizado por %)
  # ---------------------------------------------------------
  if (file.exists(go_file)) {
    df_go <- read_csv(go_file, show_col_types = FALSE)
    
    top_go <- df_go %>%
      mutate(
        Enrichment_Pct = (DE / N) * 100,
        TERM_LABEL = str_to_title(TERM)
      ) %>%
      group_by(ONTOLOGY) %>%
      arrange(FDR, desc(Enrichment_Pct), P.DE) %>%
      slice_head(n = 5) %>%
      ungroup()
    
    if (nrow(top_go) > 0) {
      draw_pct_plot(top_go, file.path(sub_dir, paste0("TOP5_GO_PER_ONT_Pct_", comp_id, ".png")), 
                    pub_title_of(comp_id), "GO term enrichment (top 5 per ontology)", is_go = TRUE)
      
      tab_data_go <- top_go %>%
        select(ONTOLOGY, TERM, N, DE, Enrichment_Pct, P.DE, FDR, SigGenesInSet) %>%
        arrange(ONTOLOGY, FDR, desc(Enrichment_Pct), P.DE)
      
      write_csv(tab_data_go, file.path(sub_dir, paste0("TABLE_TOP5_GO_Pct_", comp_id, ".csv")))
      
      tab_data_go %>%
        gt(groupname_col = "ONTOLOGY") %>%
        tab_header(title = pub_title_of(comp_id), subtitle = "Top 5 GO terms per ontology") %>%
        fmt_number(columns = c(P.DE, FDR), decimals = 4, drop_trailing_zeros = TRUE) %>%
        fmt_number(columns = Enrichment_Pct, decimals = 1) %>%
        cols_label(TERM = "GO Term", N = "Total Genes", DE = "Significant Genes", 
                   Enrichment_Pct = "Enrichment (%)", P.DE = "p-value", FDR = "FDR", SigGenesInSet = "Genes in Set") %>%
        opt_stylize() %>%
        gtsave(filename = file.path(sub_dir, paste0("TABLE_TOP5_GO_Pct_", comp_id, ".html")))
    }
  }
  message(sprintf("Procesado Subanálisis por Porcentaje para: %s", comp_id))
}

message(">>> ¡Subanálisis 2 finalizado! Revisa la carpeta 'subanalisis_porcentaje'.")