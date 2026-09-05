###############################################################################
# make_lca_inflammatory_matrix.R
# Shared significant CpGs between each LCA phenotype signature (rows C1-C6) and
# each sputum inflammatory phenotype signature (columns: eosinophilic,
# neutrophilic, mixed-granulocytic, paucigranulocytic). No re-run: reads the
# saved hit lists. Hits = FDR < 0.05 and |Delta beta| > 0.01 for both sides.
#   Run:  RESULTS_ROOT=results_fresh Rscript scripts_R/make_lca_inflammatory_matrix.R
###############################################################################
rm(list = ls())
suppressPackageStartupMessages({ library(dplyr); library(gt); library(gtsummary) })
source("scripts_R/00_config.R")
FDR_THR <- 0.05; BETA_THR <- 0.01
ewas_dir <- EWAS_TAB_DIR                                   # results_fresh/04_ewas
sens_dir <- SENS_TAB_DIR                                   # results_fresh/06_sensitivity_inflammatory

## ---- LCA phenotype signatures (C1-C6) from the saved per-contrast HITS -------
lca_files <- c(
  C1 = "EWAS_A9_phenotype_signature_C1_vs_rest_HITS.csv",
  C2 = "EWAS_A10_phenotype_signature_C2_vs_rest_HITS.csv",
  C3 = "EWAS_A11_phenotype_signature_C3_vs_rest_HITS.csv",
  C4 = "EWAS_A12_phenotype_signature_C4_vs_rest_HITS.csv",
  C5 = "EWAS_A13_phenotype_signature_C5_vs_rest_HITS.csv",
  C6 = "EWAS_A14_phenotype_signature_C6_vs_rest_HITS.csv")
get_probes <- function(path) {
  if (!file.exists(path)) return(character(0))
  df <- read.csv(path, stringsAsFactors = FALSE)
  if (all(c("fdr","beta") %in% names(df)))
    df <- df[df$fdr < FDR_THR & abs(df$beta) > BETA_THR, , drop = FALSE]
  unique(df$probeID)
}
lca_sig <- lapply(file.path(ewas_dir, lca_files), get_probes); names(lca_sig) <- names(lca_files)

## ---- Inflammatory signatures (same approach as 08c) -------------------------
summary_sens <- read.csv(file.path(sens_dir, "SENSITIVITY_SUMMARY.csv"), stringsAsFactors = FALSE)
resolve_csv <- function(row_csv, phenotype) {
  cand <- c(row_csv, file.path(sens_dir, basename(as.character(row_csv))),
            file.path(sens_dir, paste0("EWAS_SENSITIVITY_Sputum_", phenotype, "_vs_Rest.csv")))
  cand <- cand[!is.na(cand) & nzchar(cand)]; hit <- cand[file.exists(cand)]
  if (length(hit)) hit[1] else NA_character_
}
summary_sens$csv_resolved <- mapply(resolve_csv,
  if ("csv" %in% names(summary_sens)) summary_sens$csv else NA, summary_sens$Phenotype)
infl_sig <- setNames(lapply(summary_sens$csv_resolved, get_probes), summary_sens$Phenotype)

## ---- Build the shared-CpG matrix (rows = LCA, cols = inflammatory) ----------
infl_names <- names(infl_sig)
M <- matrix(0L, nrow = length(lca_sig), ncol = length(infl_sig),
            dimnames = list(names(lca_sig), infl_names))
for (i in names(lca_sig)) for (j in infl_names)
  M[i, j] <- length(intersect(lca_sig[[i]], infl_sig[[j]]))
df <- data.frame(LCA_phenotype = rownames(M),
                 LCA_signature_n = lengths(lca_sig)[rownames(M)],
                 M, check.names = FALSE, row.names = NULL)
out_csv <- file.path(ewas_dir, "LCA_vs_inflammatory_shared_cpgs.csv")
write.csv(df, out_csv, row.names = FALSE)
cat("[INFO] LCA signature sizes:", paste(sprintf("%s=%d", names(lca_sig), lengths(lca_sig)), collapse=" "), "\n")
cat("[INFO] Inflammatory sizes:", paste(sprintf("%s=%d", infl_names, lengths(infl_sig)), collapse=" "), "\n")
cat("[✓] Shared-CpG matrix written -> ", out_csv, "\n"); print(df)

gt::gtsave(gt::gt(df) |>
  gt::tab_header(title = "Shared significant CpGs: LCA phenotypes vs sputum inflammatory phenotypes",
                 subtitle = "Cells = number of CpGs significant in both (FDR < 0.05 and |delta beta| > 0.01)"),
  filename = file.path(ewas_dir, "LCA_vs_inflammatory_shared_cpgs.html"))
