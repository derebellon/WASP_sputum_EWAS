###############################################################################
# make_fresh_lca_assignment.R — generate a FRESH LCA assignment (alternative to
# the frozen Feb-2026 assignment) for the freeze-vs-fresh comparison.
#
# Re-fits poLCA on the full cohort in the CURRENT environment (same prep, seed and
# nrep as script 02), then labels the six classes by their clinical PROFILE
# (asthma yes/no, atopy yes/no, severe yes/no) via a 1-to-1 profile match, so the
# labels are stable regardless of poLCA's internal class numbering. Writes a
# full-cohort assignment CSV in the SAME format script 03 consumes, so the whole
# pipeline can be run in "fresh" mode simply by pointing LCA_FROZEN_CSV at it:
#
#   LCA_FROZEN_CSV=/home/lsh2301541/EPIC/data/LCA_class_assignment_FRESH_profile.csv \
#     sbatch scripts_batch/run_03_harmonization.sh   # then 04, 06, 07, 08c as usual
#
# Run from the repository root:  Rscript scripts_R/make_fresh_lca_assignment.R
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
out_csv <- Sys.getenv("FRESH_LCA_CSV",
                      unset = file.path(data_folder, "LCA_class_assignment_FRESH_profile.csv"))

## ---- Data prep: identical to script 02 ------------------------------------
load(file.path(data_folder, "clinical_data.RData"))  # -> clinical_data
comp <- readxl::read_excel(file.path(data_folder, "data complementary.xls")) %>%
  dplyr::select(any_of(c("studysubjectid","bloodeos","sputum_phenotype1_first",
    "prev","fev","zfev","percpredfev","fvc","zfvc","percpredfvc","fevfvc","zfevfvc","included"))) %>%
  dplyr::mutate(studysubjectid = as.character(studysubjectid),
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
    acqscorecat     = ifelse(group == "Never asthma", "Not applicable - control group", acqscorecat))

is_atopic_flag <- function(x) { y <- tolower(trimws(as.character(x)))
  ifelse(y %in% c("atopic","positive","pos","1","yes","sí","si","true"), TRUE,
         ifelse(y %in% c("non-atopic","negative","neg","0","no","false"), FALSE, NA)) }
phadia_pos_flag <- function(x) { y <- tolower(trimws(as.character(x)))
  ifelse(y %in% c("positive","pos","1","yes","sí","si","true"), TRUE,
         ifelse(y %in% c("negative","neg","0","no","false"), FALSE, NA)) }
clinical_data <- clinical_data %>% dplyr::mutate(
  sptpos_flag = is_atopic_flag(sptpos), phadpos_flag = phadia_pos_flag(phadpos),
  atopy = dplyr::case_when(is.na(sptpos_flag) & is.na(phadpos_flag) ~ NA_character_,
                           (sptpos_flag | phadpos_flag) ~ "Atopic", TRUE ~ "Non-atopic"),
  atopy = factor(atopy, levels = c("Non-atopic","Atopic")))

wasp_global <- clinical_data %>% filter(indicator == "WASP population", included == 1) %>%
  filter(!(Sample_Name %in% c("WASP148","WASP149","WASP145","WASP146","WASP156")))
clinical_data_clustering <- wasp_global %>% filter(!is.na(group))

vars_interes <- c("studysubjectid","Sample_Name","sex","age","centre_name","group",
                  "sptpos","phadresult","phadpos","acqscore","acqscorecat","severity_isaac","severity_12atac")
df_for_impute <- clinical_data_clustering %>% dplyr::select(any_of(vars_interes)) %>%
  dplyr::mutate(across(c(studysubjectid, Sample_Name), as.character),
    sex=as.factor(sex), centre_name=as.factor(centre_name), group=as.factor(group),
    sptpos=as.factor(sptpos), phadpos=as.factor(phadpos), acqscorecat=as.factor(acqscorecat),
    severity_isaac=as.factor(severity_isaac), severity_12atac=as.factor(severity_12atac))
if (!"phadresult" %in% names(df_for_impute)) df_for_impute$phadresult <- NA_real_
methods <- c(studysubjectid="", Sample_Name="", sex="logreg", age="pmm", centre_name="polyreg",
             group="logreg", sptpos="logreg", phadresult="pmm", phadpos="logreg",
             acqscore="pmm", acqscorecat="polyreg", severity_isaac="polyreg", severity_12atac="polyreg")
df_complete <- complete(mice(df_for_impute, m = 1, method = methods, maxit = 10, seed = 123), 1)

lca_vars <- c("group","sptpos","phadpos","acqscorecat","severity_isaac","severity_12atac")
lca_data <- df_complete %>% dplyr::select(studysubjectid, Sample_Name, dplyr::all_of(lca_vars)) %>%
  dplyr::mutate(across(dplyr::all_of(lca_vars), as.factor))
formula_lca <- as.formula(paste("cbind(", paste(lca_vars, collapse=","), ") ~ 1"))

## ---- Fresh six-class fit ----------------------------------------------------
# High nrep so we reliably reach the GLOBAL optimum (a low nrep can land on a
# lopsided local optimum). Configurable via FRESH_NREP.
nrep_fresh <- as.integer(Sys.getenv("FRESH_NREP", unset = 200))
set.seed(123)
fit <- poLCA(formula_lca, data = lca_data, nclass = 6, maxiter = 5000,
             nrep = nrep_fresh, verbose = FALSE)
cat(sprintf("[fresh] fit llik = %.3f (nrep = %d)\n", fit$llik, nrep_fresh))
if (!is.null(fit$attempts)) {
  best <- max(fit$attempts)
  cat(sprintf("[fresh] best llik hit %d/%d starts within 0.01 (stability of the global optimum)\n",
              sum(abs(fit$attempts - best) < 0.01), length(fit$attempts)))
}

assign_df <- lca_data %>% dplyr::mutate(raw_class = fit$predclass)

## ---- Profile each raw class (asthma / atopy / severe) -----------------------
prof <- df_complete %>%
  mutate(studysubjectid = as.character(studysubjectid)) %>%
  right_join(assign_df %>% mutate(studysubjectid = as.character(studysubjectid)) %>%
               dplyr::select(studysubjectid, raw_class), by = "studysubjectid") %>%
  mutate(
    is_asthma = as.integer(group != "Never asthma"),
    is_atopic = as.integer(dplyr::coalesce(is_atopic_flag(sptpos), FALSE) | dplyr::coalesce(phadia_pos_flag(phadpos), FALSE)),
    is_severe = as.integer(grepl("severe|uncontrolled", tolower(as.character(severity_isaac))) |
                           grepl("severe|uncontrolled", tolower(as.character(severity_12atac))))
  ) %>%
  group_by(raw_class) %>%
  summarise(n = n(), p_asthma = mean(is_asthma, na.rm = TRUE),
            p_atopic = mean(is_atopic, na.rm = TRUE),
            p_severe = mean(is_severe, na.rm = TRUE), .groups = "drop")
cat("[fresh] raw class profiles:\n"); print(as.data.frame(round(prof %>% dplyr::select(-raw_class), 3)))

## ---- 1-to-1 profile match to the six canonical labels -----------------------
labels_map <- c(
  C1 = "Asthmatic, highly atopic, severe/uncontrolled",
  C2 = "Asthmatic, non-atopic, severe/uncontrolled",
  C3 = "Asthmatic, atopic, predominantly mild/moderate",
  C4 = "Control, non-atopic",
  C5 = "Asthmatic, non-atopic, predominantly mild/moderate",
  C6 = "Control, atopic")
# canonical (asthma, atopic, severe) signatures
canon <- rbind(C1=c(1,1,1), C2=c(1,0,1), C3=c(1,1,0), C4=c(0,0,0), C5=c(1,0,0), C6=c(0,1,0))
P <- as.matrix(prof[, c("p_asthma","p_atopic","p_severe")]); rownames(P) <- prof$raw_class
# distance matrix raw x canonical, greedy 1-1 assignment (min distance first)
D <- outer(seq_len(nrow(P)), seq_len(nrow(canon)),
           Vectorize(function(i,j) sqrt(sum((P[i,] - canon[j,])^2))))
rownames(D) <- rownames(P); colnames(D) <- rownames(canon)
raw_to_canon <- character(0); Dw <- D
while (nrow(Dw) > 0) {
  idx <- which(Dw == min(Dw), arr.ind = TRUE)[1, ]
  raw <- rownames(Dw)[idx[1]]; can <- colnames(Dw)[idx[2]]
  raw_to_canon[raw] <- can
  Dw <- Dw[rownames(Dw) != raw, colnames(Dw) != can, drop = FALSE]
}
cat("[fresh] raw class -> canonical label:\n"); print(raw_to_canon)

## ---- Write assignment CSV (format script 03 consumes) -----------------------
out <- assign_df %>%
  mutate(studysubjectid = as.character(studysubjectid),
         canon = raw_to_canon[as.character(raw_class)],
         lca_class = as.integer(sub("^C", "", canon)),
         LCA_label = labels_map[canon]) %>%
  dplyr::select(studysubjectid, lca_class, LCA_label)
stopifnot(all(out$LCA_label %in% labels_map))
write_csv(out, out_csv)
cat("[fresh] class sizes (canonical):\n"); print(table(out$LCA_label))
cat(sprintf("\n[fresh] wrote %d rows -> %s\n", nrow(out), out_csv))

## ---- Posterior probabilities per class (1354) ------------------------------
# poLCA's posterior is P(class | data) for each participant, in RAW class order. Map the
# columns to the canonical C1..C6 labels so the probabilities match the modal assignment.
post <- as.matrix(fit$posterior)
colnames(post) <- vapply(seq_len(ncol(post)),
                         function(j) raw_to_canon[as.character(j)], character(1))
post <- post[, paste0("C", 1:6), drop = FALSE]
colnames(post) <- paste0("prob_", colnames(post))
post_df <- data.frame(studysubjectid = as.character(assign_df$studysubjectid),
                      post, check.names = FALSE) %>%
  dplyr::left_join(out, by = "studysubjectid")            # + modal lca_class + LCA_label
post_csv <- file.path(data_folder, "LCA_posterior_probabilities_1354.csv")
readr::write_csv(post_df, post_csv)
cat(sprintf("[fresh] wrote posterior probabilities (%d x 6 classes) -> %s\n",
            nrow(post_df), post_csv))
cat("\nRun the pipeline in FRESH mode with:\n")
cat(sprintf("  LCA_FROZEN_CSV=%s  then 03 -> 04 -> 06 -> 07 -> 08c\n", out_csv))
