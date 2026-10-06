###############################################################################
# Script 08e - Inflammatory-phenotype enrichment, CONSISTENT with the primary
# (LCA) enrichment (script 06_enrichment_kegg_go.R).
#
# Reviewer/consistency fix: the inflammatory one-vs-rest signatures must use the
# SAME enrichment method as the LCA phenotype signatures, i.e. the "top-200"
# hybrid selection + gometh for BOTH KEGG and GO. The earlier step 08 used an
# adaptive-tier input, which fed very different CpG numbers per phenotype (e.g.
# only 82 CpGs for paucigranulocytic in KEGG) and is therefore not comparable.
#
# This script reproduces script 06's EXACT logic on the four inflammatory
# EWAS toptables (results/06_sensitivity_inflammatory/
# EWAS_SENSITIVITY_Sputum_*_vs_Rest.csv) and writes consistent KEGG + GO tables.
#
# Needs the inflammatory toptables + missMethyl + the EPIC annotation, i.e. run
# on the HPC where script 06 ran.  Rscript scripts_R/08e_enrichment_inflammatory_top200.R
###############################################################################
rm(list = ls())
suppressPackageStartupMessages({library(dplyr); library(readr); library(missMethyl)})
source("scripts_R/00_config.R")
sens_dir <- SENS_TAB_DIR
out_dir  <- file.path(sens_dir, "enrichment_top200"); if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
TOP_N <- 200                      # identical to script 06

phenos <- c("Eosinophilic", "Neutrophilic", "Mixed granulocytic", "Paucigranulocytic")
col <- function(df, opts) { hit <- intersect(opts, names(df)); if (length(hit)) hit[1] else NA_character_ }

for (ph in phenos) {
  path <- file.path(sens_dir, sprintf("EWAS_SENSITIVITY_Sputum_%s_vs_Rest.csv", ph))
  if (!file.exists(path)) { message("MISSING toptable: ", path, " (gitignored - run on the HPC)"); next }
  df_in <- read_csv(path, show_col_types = FALSE)
  pc <- col(df_in, c("probeID","CpG","cpg","name","Name"))
  fc <- col(df_in, c("fdr","FDR","adj.P.Val","q.value"))
  bc <- col(df_in, c("beta","coefficient","dbeta","logFC","Estimate"))
  stopifnot(!is.na(pc), !is.na(fc), !is.na(bc))
  names(df_in)[names(df_in)==pc] <- "probeID"; names(df_in)[names(df_in)==fc] <- "fdr"; names(df_in)[names(df_in)==bc] <- "beta"

  # ---- IDENTICAL top-200 hybrid selection (script 06) ----
  hits_oficiales <- df_in %>% filter(fdr < 0.05, abs(beta) > 0.01) %>% arrange(fdr, desc(abs(beta))) %>% pull(probeID)
  cantera        <- df_in %>% filter(abs(beta) > 0.01)          %>% arrange(fdr, desc(abs(beta))) %>% pull(probeID)
  if (length(hits_oficiales) >= TOP_N) cand <- hits_oficiales[1:TOP_N] else cand <- head(cantera, TOP_N)
  message(sprintf(">>> %s: hits=%d, cand=%d", ph, length(hits_oficiales), length(cand)))

  if (length(cand) >= 10) {
    res_k <- tryCatch(gometh(sig.cpg = cand, all.cpg = df_in$probeID, collection = "KEGG", array.type = "EPIC", sig.genes = TRUE), error = function(e) {message("KEGG err: ", conditionMessage(e)); NULL})
    if (!is.null(res_k)) write_csv(topGSA(res_k, number = Inf), file.path(out_dir, sprintf("RESULTS_KEGG_Sputum_%s.csv", ph)))
    res_g <- tryCatch(gometh(sig.cpg = cand, all.cpg = df_in$probeID, collection = "GO",   array.type = "EPIC", sig.genes = TRUE), error = function(e) {message("GO err: ",   conditionMessage(e)); NULL})
    if (!is.null(res_g)) write_csv(topGSA(res_g, number = Inf), file.path(out_dir, sprintf("RESULTS_GO_Sputum_%s.csv", ph)))
  } else message("Skipping ", ph, ": <10 CpGs.")
}
cat("\nDONE. Consistent (top-200) KEGG+GO enrichment written to:", out_dir, "\n")
