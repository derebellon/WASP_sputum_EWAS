## =============================================================================
## Script 10 - Assemble the figures used in the manuscript.
##
## Builds the composite figures for the paper from the per-analysis outputs:
##   (1) The four sputum inflammatory-phenotype volcano plots joined into a single
##       four-panel figure (A eosinophilic, B neutrophilic, C mixed-granulocytic,
##       D paucigranulocytic).
##   (2) A companion panel with the KEGG/GO enrichment of each inflammatory
##       phenotype (from the GO_SIG / KEGG_SIG tables), where enrichment exists.
##   (3) A copy of the current LCA model-selection figure (line at the retained
##       6-class solution) for the supplement.
##   (4) The inflammatory-phenotype overlap figures (Venn, heatmap) copied in.
##
## Figure 1 (study population and design) is NOT regenerated here; it already
## exists and is kept as is. Panel titles come from the analysis scripts
## (already publication-ready); this script only arranges panels.
##
## Uses png + grid + gridExtra (no magick dependency). Run from the repo root:
##   Rscript scripts_R/10_paper_figures.R
## =============================================================================
suppressPackageStartupMessages({
  library(ggplot2); library(png); library(grid); library(gridExtra)
})
source("scripts_R/00_config.R")

PAPER_FIG_DIR <- file.path(FIG_ROOT, "paper")
if (!dir.exists(PAPER_FIG_DIR)) dir.create(PAPER_FIG_DIR, recursive = TRUE)

phenos <- c("Eosinophilic", "Neutrophilic", "Mixed granulocytic", "Paucigranulocytic")

# One labelled panel from an existing PNG (adds a bold A/B/C/D at top-left).
panel_from_png <- function(imgfile, label) {
  img <- readPNG(imgfile)
  grobTree(rasterGrob(img, interpolate = TRUE),
           textGrob(label, x = 0.015, y = 0.985, just = c("left", "top"),
                    gp = gpar(fontsize = 24, fontface = "bold")))
}

## (1) Four-panel inflammatory volcano figure -------------------------------
vfiles <- file.path(SENS_FIG_DIR, paste0("VOLCANO_Sputum_", phenos, "_vs_Rest.png"))
present <- file.exists(vfiles)
if (all(present)) {
  grobs <- Map(panel_from_png, vfiles, LETTERS[seq_along(vfiles)])
  out <- file.path(PAPER_FIG_DIR, "Figure_S_inflammatory_volcanoes_ABCD.png")
  png(out, width = 2600, height = 1900, res = 150)
  grid.arrange(grobs = grobs, ncol = 2)
  dev.off()
  cat("[ok]", out, "\n")
} else {
  cat("[warn] missing volcano(s):", paste(basename(vfiles[!present]), collapse = ", "),
      "- four-panel figure skipped\n")
}

## (2) Enrichment panel for the inflammatory phenotypes ----------------------
term_col <- function(nm) { m <- intersect(c("TERM", "Description", "PATHWAY", "term"), nm); if (length(m)) m[1] else NA }
fdr_col  <- function(nm) { m <- intersect(c("FDR", "fdr", "P.DE"), nm); if (length(m)) m[1] else NA }
enrich_ggplot <- function(csv, ttl) {
  d <- tryCatch(read.csv(csv, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(d) || nrow(d) == 0) return(NULL)
  tc <- term_col(names(d)); fc <- fdr_col(names(d))
  if (is.na(tc) || is.na(fc)) return(NULL)
  d <- d[order(d[[fc]]), ]; d <- head(d, 10)
  d$term <- factor(substr(d[[tc]], 1, 55), levels = rev(unique(substr(d[[tc]], 1, 55))))
  ggplot(d, aes(x = -log10(.data[[fc]]), y = term)) +
    geom_col(fill = "#2471a3") +
    labs(title = ttl, x = expression(-log[10]*"(FDR)"), y = NULL) +
    theme_bw(base_size = 11) + theme(plot.title = element_text(face = "bold", size = 11))
}

enr_grobs <- list()
for (i in seq_along(phenos)) {
  ph <- phenos[i]
  kegg <- file.path(SENS_TAB_DIR, paste0("KEGG_SIG_Sputum_", ph, ".csv"))
  go   <- file.path(SENS_TAB_DIR, paste0("GO_SIG_Sputum_", ph, ".csv"))
  csv  <- if (file.exists(kegg)) kegg else if (file.exists(go)) go else NA
  if (is.na(csv)) { cat("[note] no enrichment table for", ph, "\n"); next }
  p <- enrich_ggplot(csv, paste0(LETTERS[i], "  ", ph,
                                 if (identical(csv, kegg)) " (KEGG)" else " (GO)"))
  if (!is.null(p)) enr_grobs[[length(enr_grobs) + 1]] <- ggplotGrob(p)
}
if (length(enr_grobs) >= 1) {
  out <- file.path(PAPER_FIG_DIR, "Figure_S_inflammatory_enrichment.png")
  png(out, width = 2400, height = 1600, res = 150)
  grid.arrange(grobs = enr_grobs, ncol = min(2, length(enr_grobs)))
  dev.off()
  cat("[ok]", out, "\n")
} else cat("[note] no inflammatory enrichment tables found; enrichment panel skipped\n")

## (3) LCA model-selection figure (retained 6-class) ------------------------
lca_src <- file.path(LCA_FIG_DIR, "LCA_model_comparison.png")
if (file.exists(lca_src))
  file.copy(lca_src, file.path(PAPER_FIG_DIR, "Figure_S_LCA_model_selection.png"), overwrite = TRUE)

## (4) Bring the overlap figures into the paper folder ----------------------
for (f in c("Venn_inflammatory_phenotypes.png", "overlap_inflammatory_heatmap.png",
            "Venn_TOTAL_inflammatory_vs_primary.png", "overlap_PER_phenotype.png")) {
  src <- file.path(SENS_FIG_DIR, f)
  if (file.exists(src)) file.copy(src, file.path(PAPER_FIG_DIR, f), overwrite = TRUE)
}

cat("\nDone. Paper figures in", PAPER_FIG_DIR, "\n")
