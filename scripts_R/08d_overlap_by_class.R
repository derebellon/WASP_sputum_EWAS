###############################################################################
# Script 08d - Inflammatory-phenotype overlap split BY LATENT CLASS (C1..C6)
#
# Extends 08c: instead of overlapping each inflammatory signature against the
# UNION of primary (LCA) signatures, it overlaps each inflammatory phenotype
# against EACH latent class separately (C1, C2, ...). Purpose: test whether a
# given class (e.g. C2, severe non-atopic) shares its differential CpGs mainly
# with a specific inflammatory phenotype (hypothesis: C2 ~ neutrophilic).
#
# Reads the SAVED inflammatory EWAS toptables (via SENSITIVITY_SUMMARY.csv, same
# as 08c) and the per-class primary hit lists (EWAS_A9..A14 *_HITS.csv). Applies
# the same significance thresholds (FDR < 0.05 & |dbeta| > 0.01). Runs in seconds.
#
# NOTE: the inflammatory toptables are gitignored and live where the EWAS was run
# (LSHTM HPC, DATA_DIR = /home/lsh2301541/EPIC). Run this there, or after copying
# results/06_sensitivity_inflammatory/EWAS_SENSITIVITY_Sputum_*_vs_Rest.csv
# locally.  Rscript scripts_R/08d_overlap_by_class.R
###############################################################################
rm(list = ls())
suppressPackageStartupMessages({library(dplyr); library(stringr)})
source("scripts_R/00_config.R")
sens_dir <- SENS_TAB_DIR; ewas_dir <- EWAS_TAB_DIR; out_dir <- OVERLAP_TAB_DIR
FDR_THR <- 0.05; BETA_THR <- 0.01
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

probe_col <- function(df) intersect(c("probeID","CpG","cpg","name","Name","ID"), names(df))[1]
beta_col  <- function(df) intersect(c("beta","coefficient","dbeta","logFC","Estimate"), names(df))[1]
fdr_col   <- function(df) intersect(c("fdr","FDR","adj.P.Val","q.value","qvalue"), names(df))[1]

hits_from <- function(path) {
  d <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  pc <- probe_col(d); fc <- fdr_col(d); bc <- beta_col(d)
  if (is.na(pc)) stop("no probe column in ", path)
  if (!is.na(fc) && !is.na(bc)) d <- d[d[[fc]] < FDR_THR & abs(d[[bc]]) > BETA_THR, , drop = FALSE]
  unique(d[[pc]])
}

# --- inflammatory phenotype hit sets ---
summ <- read.csv(file.path(sens_dir, "SENSITIVITY_SUMMARY.csv"), stringsAsFactors = FALSE)
infl <- setNames(lapply(seq_len(nrow(summ)), function(i) {
  p <- summ$csv[i]; if (!file.exists(p)) p <- file.path(sens_dir, basename(p))
  if (!file.exists(p)) stop("inflammatory toptable missing: ", summ$csv[i]); hits_from(p)
}), summ$Phenotype)

# --- per-class primary hit sets (C1..C6 = A9..A14) ---
class_files <- list.files(ewas_dir, pattern = "^EWAS_A(9|1[0-4])_phenotype_signature_C[1-6]_vs_rest_HITS\\.csv$", full.names = TRUE)
classes <- setNames(lapply(class_files, hits_from),
                    str_match(basename(class_files), "_(C[1-6])_vs_rest")[,2])

# --- overlap matrix: rows = class, cols = inflammatory phenotype ---
res <- do.call(rbind, lapply(names(classes), function(cl) {
  cs <- classes[[cl]]
  do.call(rbind, lapply(names(infl), function(ip) {
    sh <- length(intersect(cs, infl[[ip]]))
    data.frame(class = cl, n_class = length(cs), inflammatory = ip,
               n_inflammatory = length(infl[[ip]]), n_shared = sh,
               pct_of_class = round(100 * sh / max(length(cs),1), 2))
  }))
}))
write.csv(res, file.path(out_dir, "overlap_by_class_vs_inflammatory.csv"), row.names = FALSE)
cat("\n=== Shared CpGs: latent class x inflammatory phenotype (n_shared / % of class) ===\n")
for (cl in unique(res$class)) {
  r <- res[res$class == cl, ]
  cat(sprintf("%s (n=%d): ", cl, r$n_class[1]),
      paste(sprintf("%s %d (%.1f%%)", r$inflammatory, r$n_shared, r$pct_of_class), collapse = " | "), "\n")
}
cat("\nWrote:", file.path(out_dir, "overlap_by_class_vs_inflammatory.csv"), "\n")
