###############################################################################
# Script 03b - Table 2 (QC-EPIGEN by LCA phenotype) WITH between-phenotype p-values
#
# Reviewer request (Paul): add a p-value column to Table 2, the table where each
# LCA phenotype is a column, testing whether each characteristic differs ACROSS
# the six LCA phenotypes (between-cluster comparison). This is NOT the subset-vs-
# population comparison we deliberately avoid in Table 1; it is a comparison among
# the latent classes, which is legitimate.
#
# Light re-run: it loads the ALREADY-SAVED harmonised cohort object that Script 03
# wrote (clinical_QC-EPIGEN_meffil.RData in DATA_DIR), so it does NOT reload the
# methylation matrix and does NOT rebuild the A1-A14 EWAS datasets. It only rebuilds
# Table 2 and adds the p-values. Run it after Script 03 has been run once.
#
# Tests: Kruskal-Wallis for continuous variables (6 groups), Fisher exact with
# simulated p-value for categorical variables (robust to small cells). The six
# classes are defined partly BY atopy and severity, so those domains differ by
# construction - this is stated in a table footnote.
#
# Outputs (into COHORT_DIR = results/03_cohort_tables when RESULTS_ROOT=results):
#   - Table2_QC-EPIGEN_by_LCA.html       (overwritten, now WITH a p-value column)
#   - Table2_QC-EPIGEN_by_LCA_pvalues.csv (tidy export of the table incl. p-values)
#
# Run (HPC, with the fresh tree):
#   RESULTS_ROOT=results Rscript scripts_R/03b_table2_pvalues.R
###############################################################################

rm(list = ls())
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(gtsummary); library(gt); library(rlang)
})

source("scripts_R/00_config.R")
data_folder <- DATA_DIR
report_dir  <- COHORT_DIR
if (!dir.exists(report_dir)) dir.create(report_dir, recursive = TRUE)

# ---- Canonical class order (identical to Script 03) ------------------------
labels_map <- c(
  "C1" = "Asthmatic, highly atopic, severe/uncontrolled",
  "C2" = "Asthmatic, non-atopic, severe/uncontrolled",
  "C3" = "Asthmatic, atopic, predominantly mild/moderate",
  "C4" = "Control, non-atopic",
  "C5" = "Asthmatic, non-atopic, predominantly mild/moderate",
  "C6" = "Control, atopic"
)
lab_levels <- unname(labels_map[paste0("C", 1:6)])

# ---- Load the harmonised cohort saved by Script 03 -------------------------
qc_path <- file.path(data_folder, "clinical_QC-EPIGEN_meffil.RData")
if (!file.exists(qc_path))
  stop("Missing ", qc_path, " - run Script 03 (03_data_harmonization.R) once first.")
load(qc_path)   # -> qc_epigen_df (already has frozen LCA_label, ratios, counts, severity_criteria_met)
stopifnot(exists("qc_epigen_df"))

# Make sure LCA_label is the C1..C6-ordered factor.
qc_epigen_df <- qc_epigen_df %>%
  mutate(LCA_label = factor(as.character(LCA_label), levels = lab_levels))
if (any(is.na(qc_epigen_df$LCA_label)))
  stop("Some QC-EPIGEN rows have an LCA_label outside C1..C6; check the saved object.")

# Derived severity flag (idempotent: Script 03 already created it, recreate if absent).
if (!"severity_criteria_met" %in% names(qc_epigen_df)) {
  qc_epigen_df <- qc_epigen_df %>%
    mutate(severity_criteria_met = factor(
      ifelse(grepl("severe|uncontrolled", tolower(as.character(severity_isaac))) |
             grepl("severe|uncontrolled", tolower(as.character(severity_12atac))),
             "Yes", "No"),
      levels = c("No", "Yes")))
}

# Reviewer request (David): never use "control" for the non-asthma group; the
# source data labels non-asthmatic categories as "Not applicable - control group".
# Relabel to "non-asthmatic group" so the table matches the manuscript terminology.
relab_noctrl <- function(x) gsub("control group", "non-asthmatic group", as.character(x), fixed = TRUE)
for (col in c("acqscorecat","severity_isaac","severity_12atac","severity_criteria_met")) {
  if (col %in% names(qc_epigen_df)) qc_epigen_df[[col]] <- relab_noctrl(qc_epigen_df[[col]])
}

# ---- Variables and sizes (identical to Script 03's Table 2) ----------------
vars_tbl1 <- c(
  "sex","age","centre_name","group","sptpos","phadpos","atopy",
  "acqscore","acqscorecat","severity_isaac","severity_12atac",
  "neutrophils1_ratio","lymphocytes1_ratio","monocytesmacrophages1_ratio",
  "eosinophils1_ratio","squamouscells1_ratio"
)
vars_tbl2 <- c(vars_tbl1, "severity_criteria_met")

size_by_class <- qc_epigen_df %>%
  transmute(LCA_label = factor(as.character(LCA_label), levels = lab_levels)) %>%
  count(LCA_label, name = "n", .drop = FALSE) %>%
  arrange(LCA_label) %>% pull(n)

# ---- Build Table 2 with between-phenotype p-values -------------------------
tbl2_lca <- qc_epigen_df %>%
  mutate(
    across(c(sex, centre_name, group, sptpos, phadpos, acqscorecat,
             severity_isaac, severity_12atac, atopy), as.factor),
    age      = suppressWarnings(as.numeric(age)),
    acqscore = suppressWarnings(as.numeric(acqscore))
  ) %>%
  gtsummary::tbl_summary(
    by      = LCA_label,
    include = dplyr::any_of(vars_tbl2),
    type = list(
      gtsummary::all_categorical() ~ "categorical",
      c(age, acqscore,
        neutrophils1_ratio, lymphocytes1_ratio, monocytesmacrophages1_ratio,
        eosinophils1_ratio, squamouscells1_ratio) ~ "continuous"
    ),
    statistic = list(
      gtsummary::all_categorical() ~ "{n} ({p}%)",
      gtsummary::all_continuous()  ~ "{median} ({p25},{p75})"
    ),
    digits   = gtsummary::all_continuous() ~ 2,
    missing  = "no"
  ) %>%
  # Between-phenotype p-value: Kruskal-Wallis (continuous), Fisher simulated (categorical).
  gtsummary::add_p(
    test = list(
      gtsummary::all_continuous()  ~ "kruskal.test",
      gtsummary::all_categorical() ~ "fisher.test"
    ),
    test.args = gtsummary::all_tests("fisher.test") ~ list(simulate.p.value = TRUE, B = 2e5),
    pvalue_fun = function(x) gtsummary::style_pvalue(x, digits = 3)
  ) %>%
  {
    up <- list(label ~ "**Characteristic**")
    for (i in seq_along(lab_levels)) {
      nm  <- paste0("stat_", i)
      lab <- paste0(lab_levels[i], " (n=", size_by_class[i], ")")
      up[[length(up)+1]] <- rlang::new_formula(as.symbol(nm), lab)
    }
    gtsummary::modify_header(., update = up)
  } %>%
  gtsummary::modify_spanning_header(gtsummary::all_stat_cols() ~ "**QC-EPIGEN cohort by LCA_label**") %>%
  gtsummary::bold_labels()

# ---- Save HTML (with footnote) + tidy CSV ----------------------------------
foot <- paste0(
  "p-value compares each characteristic across the six LCA phenotypes: ",
  "Kruskal-Wallis test for continuous variables and Fisher exact test ",
  "(simulated p-value) for categorical variables. The latent classes are ",
  "defined partly by atopy and asthma severity, so differences in those ",
  "domains (atopy, SPT/IgE positivity, severity, severity-criteria-met) are ",
  "expected by construction and are not independent findings."
)

gt_obj <- gtsummary::as_gt(tbl2_lca) %>% gt::tab_source_note(gt::md(foot))
gt::gtsave(gt_obj, filename = file.path(report_dir, "Table2_QC-EPIGEN_by_LCA.html"))

readr::write_csv(gtsummary::as_tibble(tbl2_lca),
                 file.path(report_dir, "Table2_QC-EPIGEN_by_LCA_pvalues.csv"))

cat("[✓] Table 2 (with between-phenotype p-values) written to:\n - ",
    file.path(report_dir, "Table2_QC-EPIGEN_by_LCA.html"), "\n - ",
    file.path(report_dir, "Table2_QC-EPIGEN_by_LCA_pvalues.csv"), "\n")
