## =============================================================================
## Script 09 - Supplementary table: phenotype distribution by centre and by
##             income setting (HIC vs LMIC).
##
## Produces, for the full WASP cohort:
##   (a) LCA phenotype (C1-C6) distribution by centre and by income setting.
##   (b) Sputum inflammatory phenotype (eosinophilic, neutrophilic, mixed,
##       paucigranulocytic) distribution by centre and by income setting, among
##       asthmatics with a valid sputum phenotype.
## Each cross-tab is written as counts and column percentages, with a chi-square
## test for heterogeneity across groups. This supports the HIC/LMIC point without
## running a centre-stratified EWAS.
##
## Reads the enriched clinical dataset saved by step 02
## (clinical_data_epigen_total.RData). Run from the repository root:
##   Rscript scripts_R/09_supplementary_centre_table.R
## =============================================================================
suppressPackageStartupMessages({
  library(dplyr); library(tidyr)
})
source("scripts_R/00_config.R")

load(file.path(DATA_DIR, "clinical_data_epigen_total.RData"))  # -> clinical_data_epigen_total
df <- clinical_data_epigen_total

# --- Resolve column names defensively --------------------------------------
first_present <- function(cands, nms) { m <- cands[cands %in% nms]; if (length(m)) m[1] else NA }
centre_col <- first_present(c("centre_name", "centre", "country"), names(df))
lca_col    <- first_present(c("LCA_label", "lca_label"), names(df))
group_col  <- first_present(c("group"), names(df))
stopifnot(!is.na(centre_col), !is.na(lca_col))

df$centre <- as.character(df[[centre_col]])
df$lca    <- as.character(df[[lca_col]])
df$grp    <- if (!is.na(group_col)) as.character(df[[group_col]]) else NA_character_

# The sputum inflammatory phenotype is not stored in this object; it lives in the
# complementary Excel (as in step 02). Merge it in by studysubjectid if available.
infl_col <- first_present(c("sputum_phenotype1_first", "sputum_phenotype", "inflammatory_phenotype"), names(df))
if (is.na(infl_col)) {
  xls <- file.path(DATA_DIR, "data complementary.xls")
  if (requireNamespace("readxl", quietly = TRUE) && file.exists(xls) &&
      "studysubjectid" %in% names(df)) {
    comp <- tryCatch(readxl::read_excel(xls), error = function(e) NULL)
    if (!is.null(comp) && all(c("studysubjectid", "sputum_phenotype1_first") %in% names(comp))) {
      comp <- comp %>% transmute(studysubjectid = as.character(studysubjectid),
                                 sputum_phenotype1_first = as.character(sputum_phenotype1_first))
      df$studysubjectid <- as.character(df$studysubjectid)
      df <- df %>% left_join(comp, by = "studysubjectid")
      infl_col <- "sputum_phenotype1_first"
    }
  }
}
have_infl <- !is.na(infl_col)
if (have_infl) df$infl <- as.character(df[[infl_col]]) else
  cat("[warn] sputum inflammatory phenotype not found; skipping the inflammatory tables.\n")

# --- Income setting (HIC vs LMIC) ------------------------------------------
# HIC: United Kingdom, New Zealand. LMIC: Brazil, Ecuador, Uganda.
income_of <- function(x) {
  y <- tolower(x)
  ifelse(grepl("kingdom|uk|bristol", y) | grepl("zealand|wellington", y), "HIC",
  ifelse(grepl("brazil|salvador|ecuador|esmeraldas|uganda|entebbe", y), "LMIC", NA_character_))
}
df$income <- income_of(df$centre)
cat("Centre values found:\n"); print(sort(unique(df$centre)))
cat("Income mapping:\n"); print(table(df$centre, df$income, useNA = "ifany"))

# --- Helper: counts + column % wide table for cat_var x group_var ----------
crosstab <- function(data, cat_var, group_var) {
  d <- data %>% filter(!is.na(.data[[cat_var]]), !is.na(.data[[group_var]]))
  cnt <- d %>% count(.data[[cat_var]], .data[[group_var]], name = "n") %>%
    tidyr::pivot_wider(names_from = all_of(group_var), values_from = n, values_fill = 0)
  grp_tot <- colSums(cnt[ , -1, drop = FALSE])
  pct <- cnt
  for (j in seq_along(grp_tot)) {
    col <- names(grp_tot)[j]
    pct[[col]] <- sprintf("%d (%.1f%%)", cnt[[col]], 100 * cnt[[col]] / max(1, grp_tot[j]))
  }
  names(pct)[1] <- cat_var
  # chi-square across groups
  tab <- as.matrix(cnt[ , -1, drop = FALSE])
  p <- tryCatch(chisq.test(tab)$p.value, warning = function(w) suppressWarnings(chisq.test(tab)$p.value),
                error = function(e) NA_real_)
  list(counts = cnt, pct = pct, chisq_p = p, group_totals = grp_tot)
}

write_tab <- function(res, stem) {
  write.csv(res$counts, file.path(COHORT_DIR, paste0(stem, "_counts.csv")), row.names = FALSE)
  write.csv(res$pct,    file.path(COHORT_DIR, paste0(stem, "_pct.csv")),    row.names = FALSE)
  cat(sprintf("  %s: chi-square p = %s\n", stem,
              ifelse(is.na(res$chisq_p), "NA", formatC(res$chisq_p, format = "e", digits = 2))))
}

cat("\n[TABLES] LCA phenotype by centre / income\n")
write_tab(crosstab(df, "lca", "centre"), "TableS_LCA_by_centre")
write_tab(crosstab(df, "lca", "income"), "TableS_LCA_by_income")

if (have_infl) {
  asth <- df %>% filter(is.na(grp) | grepl("asthma", tolower(grp))) %>%
    filter(!is.na(infl), infl != "")
  cat("[TABLES] inflammatory phenotype by centre / income\n")
  write_tab(crosstab(asth, "infl", "centre"), "TableS_inflammatory_by_centre")
  write_tab(crosstab(asth, "infl", "income"), "TableS_inflammatory_by_income")
}

## Optional combined gt HTML (skip silently if gt not available)
tryCatch({
  library(gt)
  mk_gt <- function(res, title, subtitle) {
    gt(res$pct) %>% tab_header(title = title, subtitle = subtitle) %>%
      tab_source_note(sprintf("Chi-square p = %s",
                              ifelse(is.na(res$chisq_p), "NA", formatC(res$chisq_p, format = "e", digits = 2))))
  }
  gtsave(mk_gt(crosstab(df, "lca", "centre"),
              "LCA phenotype by centre", "n (column %), full cohort"),
         file.path(COHORT_DIR, "TableS_LCA_by_centre.html"))
  if (have_infl)
    gtsave(mk_gt(crosstab(asth, "infl", "centre"),
                "Sputum inflammatory phenotype by centre",
                "n (column %) among asthmatics with a valid sputum phenotype"),
           file.path(COHORT_DIR, "TableS_inflammatory_by_centre.html"))
}, error = function(e) cat("  [note] gt HTML skipped:", conditionMessage(e), "\n"))

cat("\nDone. Supplementary tables written to", COHORT_DIR, "\n")
