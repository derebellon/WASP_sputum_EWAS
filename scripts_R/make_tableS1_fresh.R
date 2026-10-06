###############################################################################
# make_tableS1_fresh.R — Table S1: full WASP cohort (N=1,354) by latent phenotype
#   using the FRESH LCA assignment. Standalone; does NOT modify any other script.
#   Mirrors the variables and format of Table 2 (the 183 by phenotype), but on the
#   whole cohort. Run from the repository root:
#     LCA_FROZEN_CSV=$HOME/EPIC/data/LCA_class_assignment_FRESH_profile.csv \
#       Rscript scripts_R/make_tableS1_fresh.R
###############################################################################
rm(list = ls())
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(gtsummary); library(gt)
  library(readr); library(stringr)
})
source("scripts_R/00_config.R")
data_folder <- DATA_DIR
report_dir  <- LCA_TAB_DIR
if (!dir.exists(report_dir)) dir.create(report_dir, recursive = TRUE)

labels_map <- c(
  "C1" = "Asthmatic, highly atopic, severe/uncontrolled",
  "C2" = "Asthmatic, non-atopic, severe/uncontrolled",
  "C3" = "Asthmatic, atopic, predominantly mild/moderate",
  "C4" = "Control, non-atopic",
  "C5" = "Asthmatic, non-atopic, predominantly mild/moderate",
  "C6" = "Control, atopic")
lab_levels <- unname(labels_map[paste0("C", 1:6)])

# Full cohort clinical data with its LCA_label (assigned in Script 02)
load(file.path(data_folder, "clinical_data_epigen_total.RData")) # -> clinical_data_epigen_total
global_df <- clinical_data_epigen_total

# Override LCA_label with the FRESH assignment (same mechanism Script 03 uses).
fresh_path <- Sys.getenv("LCA_FROZEN_CSV",
                         unset = file.path(data_folder, "LCA_class_assignment_FRESH_profile.csv"))
if (!file.exists(fresh_path)) stop("Fresh assignment CSV not found: ", fresh_path)
fresh <- readr::read_csv(fresh_path, show_col_types = FALSE) %>%
  dplyr::mutate(studysubjectid = as.character(studysubjectid),
                LCA_label_new = as.character(LCA_label)) %>%
  dplyr::select(studysubjectid, LCA_label_new)
global_df <- global_df %>%
  dplyr::mutate(studysubjectid = as.character(studysubjectid)) %>%
  dplyr::left_join(fresh, by = "studysubjectid") %>%
  dplyr::mutate(LCA_label = ifelse(!is.na(LCA_label_new), LCA_label_new, as.character(LCA_label))) %>%
  dplyr::select(-LCA_label_new) %>%
  dplyr::filter(LCA_label %in% lab_levels)

global_df <- global_df %>%
  dplyr::mutate(LCA_label = factor(as.character(LCA_label), levels = lab_levels),
    severity_criteria_met = factor(
      ifelse(grepl("severe|uncontrolled", tolower(as.character(severity_isaac))) |
             grepl("severe|uncontrolled", tolower(as.character(severity_12atac))),
             "Yes", "No"), levels = c("No", "Yes")))
size_by_class <- global_df %>%
  dplyr::count(LCA_label, name = "n", .drop = FALSE) %>% arrange(LCA_label) %>% pull(n)
cat("[TableS1] fresh full-cohort class sizes:\n"); print(setNames(size_by_class, lab_levels))

vars_tbl <- c("sex","age","centre_name","group","sptpos","phadpos","atopy",
              "acqscorecat","severity_isaac","severity_12atac","severity_criteria_met",
              "neutrophils1_ratio","lymphocytes1_ratio","monocytesmacrophages1_ratio",
              "eosinophils1_ratio","squamouscells1_ratio")

tblS1 <- global_df %>%
  dplyr::mutate(across(any_of(c("sex","centre_name","group","sptpos","phadpos",
                                "acqscorecat","severity_isaac","severity_12atac","atopy")), as.factor),
                age = suppressWarnings(as.numeric(age))) %>%
  gtsummary::tbl_summary(
    by = LCA_label, include = dplyr::any_of(vars_tbl),
    statistic = list(gtsummary::all_categorical() ~ "{n} ({p}%)",
                     gtsummary::all_continuous()  ~ "{median} ({p25},{p75})"),
    digits = gtsummary::all_continuous() ~ 2, missing = "no") %>%
  {
    up <- list(label ~ "**Characteristic**")
    for (i in seq_along(lab_levels)) up[[length(up)+1]] <-
      rlang::new_formula(as.symbol(paste0("stat_", i)),
                         paste0(lab_levels[i], " (n=", size_by_class[i], ")"))
    gtsummary::modify_header(., update = up)
  } %>%
  gtsummary::modify_spanning_header(gtsummary::all_stat_cols() ~ "**Full WASP cohort (N=1,354) by latent phenotype (fresh assignment)**") %>%
  gtsummary::bold_labels()

out <- file.path(report_dir, "TableS1_GLOBAL_by_LCA_fresh.html")
gt::gtsave(gtsummary::as_gt(tblS1), filename = out)
cat("[✓] Table S1 (fresh full cohort by LCA) saved:\n - ", out, "\n")
