###############################################################################
# validate_lca_refit.R — refit the LCA and check reproducibility vs the frozen
#                        183-participant assignment
#
# This is a DIAGNOSTIC. It does NOT touch anything the main pipeline reads: it
# writes only to new filenames. It reproduces script 02's data preparation and
# six-class poLCA fit exactly (same variables, same seed, same nrep), assigns
# each participant to their most probable class, and then measures how many of
# the 183 EWAS participants keep the same class under this fresh fit, up to
# relabelling. It also writes the fresh full-cohort assignment (labelled to match
# our class names via the best 183-overlap mapping) for possible reuse.
#
# Run from the repository root:  Rscript scripts_R/validate_lca_refit.R
###############################################################################

rm(list = ls())
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(poLCA); library(mice)
  library(readr); library(readxl); library(stringr); library(purrr)
})

source("scripts_R/00_config.R")
data_folder <- DATA_DIR
out_dir     <- LCA_TAB_DIR
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

frozen_path <- Sys.getenv("LCA_FROZEN_CSV",
                          unset = file.path(data_folder, "LCA_class_assignment_FROZEN_feb2026.csv"))
if (!file.exists(frozen_path)) stop("Frozen assignment not found: ", frozen_path)

## ---- Data prep: identical to script 02 -------------------------------------
load(file.path(data_folder, "clinical_data.RData"))  # -> clinical_data

comp_path <- file.path(data_folder, "data complementary.xls")
comp <- readxl::read_excel(comp_path) %>%
  dplyr::select(any_of(c(
    "studysubjectid","bloodeos","sputum_phenotype1_first",
    "prev","fev","zfev","percpredfev","fvc","zfvc","percpredfvc",
    "fevfvc","zfevfvc","included"))) %>%
  dplyr::mutate(
    studysubjectid = as.character(studysubjectid),
    prev  = as.character(prev),
    across(c(fev, zfev, percpredfev, fvc, zfvc, percpredfvc,
             fevfvc, zfevfvc, bloodeos), ~ suppressWarnings(as.numeric(.))),
    included = { v <- suppressWarnings(as.numeric(included))
                 as.integer(ifelse(is.na(v), NA_real_, ifelse(v != 0, 1, 0))) })

clinical_data <- clinical_data %>%
  dplyr::mutate(studysubjectid = as.character(studysubjectid)) %>%
  dplyr::left_join(comp, by = "studysubjectid") %>%
  dplyr::mutate(
    severity_isaac  = ifelse(group == "Never asthma" & is.na(severity_isaac),
                             "Not applicable - control group", severity_isaac),
    severity_12atac = ifelse(group == "Never asthma" & is.na(severity_12atac),
                             "Not applicable - control group", severity_12atac),
    acqscore        = ifelse(group == "Never asthma", 0, acqscore),
    acqscorecat     = ifelse(group == "Never asthma",
                             "Not applicable - control group", acqscorecat))

is_atopic_flag <- function(x) {
  y <- tolower(trimws(as.character(x)))
  ifelse(y %in% c("atopic","positive","pos","1","yes","sí","si","true"), TRUE,
         ifelse(y %in% c("non-atopic","negative","neg","0","no","false"), FALSE, NA)) }
phadia_pos_flag <- function(x) {
  y <- tolower(trimws(as.character(x)))
  ifelse(y %in% c("positive","pos","1","yes","sí","si","true"), TRUE,
         ifelse(y %in% c("negative","neg","0","no","false"), FALSE, NA)) }

clinical_data <- clinical_data %>%
  dplyr::mutate(
    sptpos_flag  = is_atopic_flag(sptpos),
    phadpos_flag = phadia_pos_flag(phadpos),
    atopy = dplyr::case_when(
      is.na(sptpos_flag) & is.na(phadpos_flag) ~ NA_character_,
      (sptpos_flag | phadpos_flag)             ~ "Atopic",
      TRUE                                     ~ "Non-atopic"),
    atopy = factor(atopy, levels = c("Non-atopic","Atopic")))

wasp_incl <- clinical_data %>% filter(indicator == "WASP population", included == 1)
visit2_duplicates <- c("WASP148","WASP149","WASP145","WASP146","WASP156")
wasp_global <- wasp_incl %>% filter(!(Sample_Name %in% visit2_duplicates))
clinical_data_clustering <- wasp_global %>% filter(!is.na(group))
cat("[INFO] n GLOBAL for LCA:", nrow(clinical_data_clustering), "\n")

vars_interes <- c("studysubjectid","Sample_Name","sex","age","centre_name","group",
                  "sptpos","phadresult","phadpos","acqscore","acqscorecat",
                  "severity_isaac","severity_12atac")
df_for_impute <- clinical_data_clustering %>%
  dplyr::select(any_of(vars_interes)) %>%
  dplyr::mutate(
    across(c(studysubjectid, Sample_Name), as.character),
    sex = as.factor(sex), centre_name = as.factor(centre_name),
    group = as.factor(group), sptpos = as.factor(sptpos), phadpos = as.factor(phadpos),
    acqscorecat = as.factor(acqscorecat), severity_isaac = as.factor(severity_isaac),
    severity_12atac = as.factor(severity_12atac))
if (!"phadresult" %in% names(df_for_impute)) df_for_impute$phadresult <- NA_real_

methods <- c(studysubjectid="", Sample_Name="", sex="logreg", age="pmm",
             centre_name="polyreg", group="logreg", sptpos="logreg", phadresult="pmm",
             phadpos="logreg", acqscore="pmm", acqscorecat="polyreg",
             severity_isaac="polyreg", severity_12atac="polyreg")
imputed_data <- mice(df_for_impute, m = 1, method = methods, maxit = 10, seed = 123)
df_complete  <- complete(imputed_data, 1)

lca_vars <- c("group","sptpos","phadpos","acqscorecat","severity_isaac","severity_12atac")
lca_data <- df_complete %>%
  dplyr::select(studysubjectid, Sample_Name, dplyr::all_of(lca_vars)) %>%
  dplyr::mutate(dplyr::across(dplyr::all_of(lca_vars), as.factor))
formula_lca <- as.formula(paste("cbind(", paste(lca_vars, collapse = ","), ") ~ 1"))

## ---- Fresh six-class fit: identical call to script 02 ----------------------
set.seed(123)
lca_model_6 <- poLCA(formula_lca, data = lca_data, nclass = 6, maxiter = 2000, nrep = 10)

refit <- lca_data %>%
  dplyr::mutate(studysubjectid = as.character(studysubjectid),
                refit_class = paste0("C", lca_model_6$predclass))

## ---- Compare to the frozen 183 ---------------------------------------------
frozen <- read_csv(frozen_path, show_col_types = FALSE) %>%
  dplyr::mutate(studysubjectid = as.character(studysubjectid),
                frozen_label = as.character(LCA_label))

cmp <- frozen %>%
  dplyr::select(studysubjectid, frozen_label) %>%
  dplyr::inner_join(refit %>% dplyr::select(studysubjectid, refit_class),
                    by = "studysubjectid")
cat(sprintf("[INFO] frozen 183: %d | matched in refit: %d\n",
            nrow(frozen), nrow(cmp)))

# Contingency of frozen label x fresh class, then greedy best 1-1 mapping.
ct <- table(cmp$frozen_label, cmp$refit_class)
map_fresh_to_label <- character(0)
ct_work <- ct
while (nrow(ct_work) > 0 && ncol(ct_work) > 0) {
  idx <- which(ct_work == max(ct_work), arr.ind = TRUE)[1, ]
  lab <- rownames(ct_work)[idx[1]]; cls <- colnames(ct_work)[idx[2]]
  map_fresh_to_label[cls] <- lab
  ct_work <- ct_work[rownames(ct_work) != lab, colnames(ct_work) != cls, drop = FALSE]
}
cmp$refit_label <- map_fresh_to_label[cmp$refit_class]
agree <- mean(cmp$refit_label == cmp$frozen_label, na.rm = TRUE)

## ---- Detail the participants who MOVE class (frozen -> fresh) ---------------
## For each mover we report, under the CURRENT (global-optimum) solution: how
## confident it is in the NEW class (prob_fresh = the modal/top posterior) vs how
## much support the OLD frozen class still keeps (prob_frozen), the margin between
## them, and the participant's actual clinical inputs so the phenotype fit can be
## judged directly. NOTE: the frozen run's own posteriors were overwritten and its
## software stack cannot be reproduced bit-for-bit, so "better classified" is
## assessed by (a) the current model's confidence and (b) the observed phenotype,
## not by the frozen model's posteriors (which no longer exist).
post_mat <- lca_model_6$posterior
colnames(post_mat) <- paste0("C", seq_len(ncol(post_mat)))
rownames(post_mat) <- as.character(lca_data$studysubjectid)
label_to_class <- setNames(names(map_fresh_to_label), map_fresh_to_label)  # frozen_label -> fresh col

mv <- cmp[!is.na(cmp$refit_label) & cmp$refit_label != cmp$frozen_label, , drop = FALSE]
if (nrow(mv) > 0) {
  mv$fresh_class  <- mv$refit_class
  mv$frozen_class <- label_to_class[mv$frozen_label]
  clin <- lca_data %>% dplyr::mutate(studysubjectid = as.character(studysubjectid)) %>%
    dplyr::select(studysubjectid, group, sptpos, phadpos, acqscorecat,
                  severity_isaac, severity_12atac)
  mv <- dplyr::left_join(mv, clin, by = "studysubjectid")
  pm <- post_mat[mv$studysubjectid, , drop = FALSE]
  mv$prob_fresh  <- pm[cbind(seq_len(nrow(mv)), match(mv$fresh_class,  colnames(pm)))]
  mv$prob_frozen <- pm[cbind(seq_len(nrow(mv)), match(mv$frozen_class, colnames(pm)))]
  mv$top_prob    <- apply(pm, 1, max)
  mv$second_prob <- apply(pm, 1, function(r) sort(r, decreasing = TRUE)[2])
  mv$margin      <- round(mv$prob_fresh - mv$prob_frozen, 3)
  mv$verdict <- ifelse(mv$margin > 0.30, "fresh decisive (old class strongly rejected)",
                ifelse(mv$margin < 0.10, "borderline near-tie (either label defensible)",
                       "fresh moderately favored"))
  mv_out <- mv %>%
    dplyr::mutate(prob_fresh = round(prob_fresh, 3), prob_frozen = round(prob_frozen, 3),
                  top_prob = round(top_prob, 3)) %>%
    dplyr::select(studysubjectid, frozen_label, frozen_class, refit_label, fresh_class,
                  prob_frozen, prob_fresh, top_prob, margin, verdict,
                  group, sptpos, phadpos, acqscorecat, severity_isaac, severity_12atac) %>%
    dplyr::arrange(dplyr::desc(margin))
  movers_csv <- file.path(out_dir, "LCA_movers_frozen_vs_fresh.csv")
  readr::write_csv(mv_out, movers_csv)
  cat(sprintf("\n[movers] %d participants change class frozen->fresh; detail -> %s\n",
              nrow(mv_out), movers_csv))
  cat("[movers] verdict counts (current-model confidence: new class vs old class):\n")
  print(table(mv_out$verdict))
  cat("[movers] table:\n"); print(as.data.frame(mv_out), row.names = FALSE)
} else {
  cat("\n[movers] no participants change class (100% agreement).\n")
}

# Reproducibility of the fit itself: refit twice with the same seed and compare
# the log-likelihood (tests determinism in THIS environment, as ChatGPT suggests).
set.seed(123); m_a <- poLCA(formula_lca, data = lca_data, nclass = 6, maxiter = 2000, nrep = 10, verbose = FALSE)
set.seed(123); m_b <- poLCA(formula_lca, data = lca_data, nclass = 6, maxiter = 2000, nrep = 10, verbose = FALSE)
same_seed_ok <- isTRUE(all.equal(m_a$llik, m_b$llik))

report_path <- file.path(out_dir, "LCA_refit_validation_report.txt")
sink(report_path)
cat("LCA refit reproducibility check (fresh fit vs frozen 183)\n")
cat("R:", R.version.string, "| poLCA:", as.character(packageVersion("poLCA")),
    "| mice:", as.character(packageVersion("mice")), "\n\n")
cat(sprintf("Fresh fit log-likelihood: %.4f\n", lca_model_6$llik))
cat(sprintf("Same-seed determinism (two identical calls give identical llik): %s\n",
            ifelse(same_seed_ok, "TRUE", "FALSE")))
if (!is.null(lca_model_6$attempts)) {
  cat("\nLog-likelihoods across the", length(lca_model_6$attempts),
      "random starts (nrep) — a recurring maximum = a stable solution:\n")
  print(round(sort(lca_model_6$attempts, decreasing = TRUE), 4))
  cat(sprintf("Best hit %d/%d times (within 0.01 of the max).\n",
              sum(abs(lca_model_6$attempts - max(lca_model_6$attempts)) < 0.01),
              length(lca_model_6$attempts)))
}
cat("\nFresh full-cohort class sizes (arbitrary numbering):\n"); print(table(refit$refit_class))
cat("\nManuscript full-cohort sizes were: 358/300/185/291/49/171 (n=1354)\n")
cat("\nContingency frozen label (rows) x fresh class (cols), 183 EWAS participants:\n")
print(ct)
cat("\nBest fresh-class -> frozen-label mapping (by max overlap):\n")
print(map_fresh_to_label)
cat(sprintf("\nAGREEMENT on the 183 (same class up to relabelling): %.1f%% (%d of %d)\n",
            100 * agree, sum(cmp$refit_label == cmp$frozen_label, na.rm = TRUE), nrow(cmp)))
cat("\nInterpretation:\n")
cat(" - Agreement ~100%% (up to relabelling) = pure LABEL SWITCHING: the same solution,\n")
cat("   only the class numbers permuted. Our primary bug is exactly this (labels were\n")
cat("   hardcoded by class number). Freezing + the profile-independent join fully fix it.\n")
cat(" - Agreement well below 100%% = a genuinely DIFFERENT six-class solution (partition\n")
cat("   changed), from a different EM optimum or a different imputation/data state. Then\n")
cat("   the freeze is essential because a fresh fit does not reproduce the manuscript.\n")
cat(" - Compare the fresh llik above with the recurring maximum across starts: a maximum\n")
cat("   hit repeatedly is evidence of a stable global solution regardless of numbering.\n")
sink()
cat("[✓] Report written:", report_path, "\n")

# Fresh full-cohort assignment, labelled via the 183-overlap mapping (for reference).
refit_full <- refit %>%
  dplyr::mutate(refit_label = map_fresh_to_label[refit_class]) %>%
  dplyr::select(studysubjectid, refit_class, refit_label)
write_csv(refit_full, file.path(out_dir, "LCA_class_assignment_REFIT_full_cohort.csv"))
cat("[✓] Fresh full-cohort assignment written:",
    file.path(out_dir, "LCA_class_assignment_REFIT_full_cohort.csv"),
    "(", nrow(refit_full), "participants )\n")
cat(sprintf("\nSUMMARY: agreement on the 183 = %.1f%%\n", 100 * agree))
