###############################################################################
# Script 08c - Cross-signature overlap ONLY (no EWAS re-run)
#
# The expensive part of step 08 is the four inflammatory one-vs-rest EWAS
# (PART 1) and their enrichment (PART 2). Those do NOT depend on the latent-class
# labels, so after the LCA freeze fix (script 03) only the overlap of the
# inflammatory signatures against the *primary* (LCA) signatures needs to be
# recomputed. That is a set intersection over already-saved hit lists and runs in
# seconds.
#
# This script reproduces PART 3 (overlap tables) and PART 4 (figures) of step 08
# by reading the saved inflammatory EWAS CSVs (via SENSITIVITY_SUMMARY.csv) and
# the freshly recomputed primary EWAS CSVs in results/04_ewas. It re-runs neither
# EWAS nor enrichment.
#
# Run from the repository root, AFTER re-running scripts 03 and 04 with the frozen
# LCA assignment:  Rscript scripts_R/08c_overlap_only.R
###############################################################################

rm(list = ls())

for (pkg in c("ggVennDiagram")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    install.packages(pkg, repos = "http://cran.us.r-project.org")
}

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(stringr)
  library(purrr)
  library(tidyr)
  library(ggVennDiagram)
})

cfg <- function(name, default) {
  v <- Sys.getenv(name, unset = NA); if (is.na(v) || v == "") default else v
}
source("scripts_R/00_config.R")
data_folder <- DATA_DIR
main_dir    <- EWAS_TAB_DIR
sens_dir    <- SENS_TAB_DIR
venn_dir    <- OVERLAP_TAB_DIR
venn_fig    <- SENS_FIG_DIR

primary_pattern <- cfg("PRIMARY_PATTERN", "^EWAS_A(9|1[0-4])_.*\\.csv$")
FDR_THR   <- as.numeric(cfg("FDR_THRESHOLD",   "0.05"))
BETA_THR  <- as.numeric(cfg("DBETA_THRESHOLD", "0.01"))

for (d in c(venn_dir, venn_fig)) if (!dir.exists(d)) dir.create(d, recursive = TRUE)

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
# Load the inflammatory signatures from the SAVED EWAS CSVs (no re-run)
###############################################################################
summary_path <- file.path(sens_dir, "SENSITIVITY_SUMMARY.csv")
if (!file.exists(summary_path))
  stop("SENSITIVITY_SUMMARY.csv not found in ", sens_dir,
       " - run the full step 08 (PART 1) at least once before this script.")
summary_sens <- read.csv(summary_path, stringsAsFactors = FALSE)

# Resolve each phenotype's EWAS CSV path. The 'csv' column is repo-relative; fall
# back to reconstructing the path from the phenotype label if the column is absent.
resolve_csv <- function(row_csv, phenotype) {
  cand <- c(row_csv,
            file.path(sens_dir, basename(as.character(row_csv))),
            file.path(sens_dir, paste0("EWAS_SENSITIVITY_", phenotype, ".csv")),
            file.path(sens_dir, paste0("EWAS_SENSITIVITY_Sputum_", phenotype, "_vs_Rest.csv")))
  cand <- cand[!is.na(cand) & nzchar(cand)]
  hit <- cand[file.exists(cand)]
  if (length(hit)) hit[1] else NA_character_
}
summary_sens$csv_resolved <- mapply(resolve_csv,
                                    if ("csv" %in% names(summary_sens)) summary_sens$csv else NA,
                                    summary_sens$Phenotype)
missing_csv <- summary_sens$Phenotype[is.na(summary_sens$csv_resolved)]
if (length(missing_csv))
  stop("Inflammatory EWAS CSV not found for: ", paste(missing_csv, collapse = ", "),
       " - these are gitignored; make sure they are present in ", sens_dir)

get_hits <- function(filepath) {
  if (!file.exists(filepath)) return(character(0))
  df <- read.csv(filepath, stringsAsFactors = FALSE)
  if (all(c("fdr", "beta") %in% names(df)))
    df <- df[df$fdr < FDR_THR & abs(df$beta) > BETA_THR, , drop = FALSE]
  unique(df$probeID)
}
jaccard <- function(a, b) { u <- length(union(a, b)); if (u == 0) NA_real_ else length(intersect(a, b)) / u }

signatures <- setNames(lapply(summary_sens$csv_resolved, get_hits), summary_sens$Phenotype)
signatures <- signatures[order(names(signatures))]
phenos     <- names(signatures)
infl_union <- unique(unlist(signatures))
cat("[INFO] Inflammatory signatures loaded:",
    paste(sprintf("%s=%d", phenos, lengths(signatures)), collapse = " | "), "\n")

# Primary LCA phenotype signatures (union of the selected primary EWAS CSVs).
primary_files <- list.files(main_dir, pattern = primary_pattern, full.names = TRUE)
if (!length(primary_files))
  stop("No primary EWAS CSVs matched '", primary_pattern, "' in ", main_dir,
       " - re-run scripts 03 and 04 with the frozen LCA assignment first.")
primary_sets  <- setNames(lapply(primary_files, get_hits),
                          tools::file_path_sans_ext(basename(primary_files)))
primary_union <- unique(unlist(primary_sets))
cat("[INFO] Primary phenotype signature files:", length(primary_files),
    "| union CpGs:", length(primary_union), "\n")

###############################################################################
# PART 3 - overlap tables
###############################################################################
## 3a. Pairwise overlap between inflammatory phenotypes
pair_rows <- data.frame()
for (i in phenos) for (j in phenos) if (i != j) pair_rows <- rbind(pair_rows, data.frame(
  phenotype = i, other = j,
  n_shared = length(intersect(signatures[[i]], signatures[[j]])),
  n_self = length(signatures[[i]]),
  pct_of_self = ifelse(length(signatures[[i]]) == 0, NA,
                       100 * length(intersect(signatures[[i]], signatures[[j]])) / length(signatures[[i]])),
  jaccard = jaccard(signatures[[i]], signatures[[j]])))
write.csv(pair_rows, file.path(venn_dir, "overlap_inflammatory_pairwise.csv"), row.names = FALSE)

## 3b. Each inflammatory phenotype vs the union of the others
vs_rest_rows <- data.frame()
for (i in phenos) {
  others <- unique(unlist(signatures[setdiff(phenos, i)]))
  vs_rest_rows <- rbind(vs_rest_rows, data.frame(
    phenotype = i, n_self = length(signatures[[i]]),
    n_shared_with_other_infl = length(intersect(signatures[[i]], others)),
    n_unique_to_self = length(setdiff(signatures[[i]], others))))
}
write.csv(vs_rest_rows, file.path(venn_dir, "overlap_inflammatory_vs_others.csv"), row.names = FALSE)

## 3c. Inflammatory signatures vs primary phenotype signatures
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
# PART 4 - figures
###############################################################################
## 4a. TOTAL figure: inflammatory union vs primary phenotype union
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

## 4b. PER-phenotype figure
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

## 4c. Four-set Venn across inflammatory phenotypes
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

## 4d. Shared-count heatmap between inflammatory phenotypes
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

## 4e. Two-set Venn (inflammatory union vs primary union)
p_setvenn <- ggVennDiagram(list("Inflammatory phenotypes" = infl_union,
                                 "LCA phenotypes" = primary_union),
                           label_alpha = 0, set_color = "black") +
  scale_fill_gradient(low = "#F7FBFF", high = "#08306B", name = "CpGs") +
  labs(title = "Total overlap: inflammatory-phenotype vs LCA-phenotype signatures") +
  theme(plot.title = element_text(face = "bold", size = 16, hjust = 0.5))
ggsave(file.path(venn_fig, "Venn_TOTAL_inflammatory_vs_primary.png"), p_setvenn, width = 9, height = 7, dpi = 300)

cat("\n[✓] Overlap-only done. Shared inflammatory-vs-primary CpGs:", shared,
    "of", length(infl_union), "inflammatory /", length(primary_union), "primary.\n")
cat("Outputs in:\n  ", venn_dir, "\n  ", venn_fig, "\n")
