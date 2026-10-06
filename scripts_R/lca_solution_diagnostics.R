###############################################################################
# lca_solution_diagnostics.R — is the six-class SOLUTION well separated, and is
# there a better-separated (and reproducible) six-class solution?
#
# The number of classes (6) is settled by BIC/AIC + bootstrap and is NOT revisited.
# This asks a different question: among the many six-class solutions the (multimodal)
# likelihood surface admits, which one do we get, how well separated is it, and is
# there an alternative that separates as well while recovering larger severe classes.
# It (a) reports separation diagnostics for the seed-123 solution used in the
# analysis, (b) scans the solution landscape (many single random starts) to list the
# DISTINCT six-class solutions, and (c) CHARACTERISES the top solutions: the clinical
# profile of every class AND the size of each class within the 183 EWAS participants
# (which is what decides EWAS power).
#
# Data prep is byte-identical to make_fresh_lca_assignment.R (same imputed dataset,
# seed 123). No EWAS is run. Output: results/02_clinical_lca/LCA_solution_landscape.csv.
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

## ---- Data prep: identical to make_fresh_lca_assignment.R -------------------
load(file.path(data_folder, "clinical_data.RData"))
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
  ifelse(y %in% c("atopic","positive","pos","1","yes","si","true"), TRUE,
         ifelse(y %in% c("non-atopic","negative","neg","0","no","false"), FALSE, NA)) }
phadia_pos_flag <- function(x) { y <- tolower(trimws(as.character(x)))
  ifelse(y %in% c("positive","pos","1","yes","si","true"), TRUE,
         ifelse(y %in% c("negative","neg","0","no","false"), FALSE, NA)) }
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

# 183 EWAS participants (QC-passed methylation ids) — to size classes where the EWAS runs
ids183 <- character(0)
qc_ids_path <- file.path(data_folder, "epigen_qc_passed_ids.RData")
if (file.exists(qc_ids_path)) { load(qc_ids_path)   # -> qc_pass_df
  if (exists("qc_pass_df") && "studysubjectid" %in% names(qc_pass_df))
    ids183 <- unique(as.character(qc_pass_df$studysubjectid)) }
cat(sprintf("[info] EWAS participants (183 set) available: %d ids\n", length(ids183)))

## ---- Diagnostics helpers ---------------------------------------------------
canon <- rbind(C1=c(1,1,1), C2=c(1,0,1), C3=c(1,1,0), C4=c(0,0,0), C5=c(1,0,0), C6=c(0,1,0))
canon_name <- c(C1="severe atopic asthma", C2="severe non-atopic asthma",
                C3="mild/mod atopic asthma", C4="non-atopic control",
                C5="mild/mod non-atopic asthma", C6="atopic control")
rel_entropy <- function(post) { N <- nrow(post); K <- ncol(post)
  p <- post; p[p <= 0] <- .Machine$double.xmin
  1 - (-sum(post * log(p))) / (N * log(K)) }
profile_classes <- function(predclass) {
  df_complete %>% mutate(rc = predclass,
      is_asthma = as.integer(group != "Never asthma"),
      is_atopic = as.integer(dplyr::coalesce(is_atopic_flag(sptpos), FALSE) |
                             dplyr::coalesce(phadia_pos_flag(phadpos), FALSE)),
      is_severe = as.integer(grepl("severe|uncontrolled", tolower(as.character(severity_isaac))) |
                             grepl("severe|uncontrolled", tolower(as.character(severity_12atac))))) %>%
    group_by(rc) %>% summarise(n = n(), p_asthma = mean(is_asthma),
      p_atopic = mean(is_atopic), p_severe = mean(is_severe), .groups = "drop") }
greedy_canon <- function(prof) {
  P <- as.matrix(prof[, c("p_asthma","p_atopic","p_severe")]); rownames(P) <- prof$rc
  D <- outer(seq_len(nrow(P)), seq_len(nrow(canon)),
             Vectorize(function(i,j) sqrt(sum((P[i,] - canon[j,])^2))))
  rownames(D) <- rownames(P); colnames(D) <- rownames(canon)
  m <- character(0); Dw <- D
  while (nrow(Dw) > 0) { idx <- which(Dw == min(Dw), arr.ind = TRUE)[1, ]
    r <- rownames(Dw)[idx[1]]; cc <- colnames(Dw)[idx[2]]; m[r] <- cc
    Dw <- Dw[rownames(Dw) != r, colnames(Dw) != cc, drop = FALSE] }
  m }
summarise_fit <- function(fit) {
  prof <- profile_classes(fit$predclass); m <- greedy_canon(prof)
  sizes <- setNames(rep(NA_integer_, 6), paste0("C", 1:6)); avepp <- setNames(rep(NA_real_, 6), paste0("C", 1:6))
  for (rc in prof$rc) { cc <- m[as.character(rc)]; sizes[cc] <- prof$n[prof$rc == rc]
    idx <- which(fit$predclass == rc); if (length(idx)) avepp[cc] <- mean(fit$posterior[idx, rc]) }
  list(llik = fit$llik, bic = fit$bic, entropy = rel_entropy(fit$posterior),
       sizes = sizes, avepp = avepp, severe = sum(sizes[c("C1","C2")], na.rm = TRUE),
       min_avepp = min(avepp, na.rm = TRUE)) }

## ---- (a) The seed-123 solution used in the analysis ------------------------
set.seed(123)
fit0 <- poLCA(formula_lca, data = lca_data, nclass = 6, maxiter = 5000, nrep = 200, verbose = FALSE)
s0 <- summarise_fit(fit0)
cat(sprintf("\n[seed123/nrep200] llik=%.2f  BIC=%.1f  entropy=%.3f  min AvePP=%.3f\n",
            s0$llik, s0$bic, s0$entropy, s0$min_avepp))
cat("  canonical sizes:  "); print(s0$sizes)
cat("  AvePP by class:   "); print(round(s0$avepp, 3))

## ---- (b) Landscape scan: many single random starts -------------------------
N_SEEDS <- as.integer(Sys.getenv("LCA_SCAN_SEEDS", unset = 150))
rows <- list()
for (sd in seq_len(N_SEEDS)) {
  set.seed(sd)
  fit <- tryCatch(poLCA(formula_lca, data = lca_data, nclass = 6, maxiter = 5000,
                        nrep = 1, verbose = FALSE), error = function(e) NULL)
  if (is.null(fit) || is.null(fit$posterior)) next
  s <- summarise_fit(fit)
  rows[[length(rows)+1]] <- data.frame(seed = sd, llik = round(s$llik, 2), bic = round(s$bic, 1),
    entropy = round(s$entropy, 3), min_avepp = round(s$min_avepp, 3), severe_C1C2 = s$severe,
    C1 = s$sizes["C1"], C2 = s$sizes["C2"], C3 = s$sizes["C3"],
    C4 = s$sizes["C4"], C5 = s$sizes["C5"], C6 = s$sizes["C6"], row.names = NULL)
}
land <- bind_rows(rows) %>% mutate(sol = round(llik, 1))
distinct_sol <- land %>% group_by(sol) %>%
  summarise(n_seeds = n(), rep_seed = seed[which.max(llik)], llik = max(llik), bic = min(bic),
            entropy = max(entropy), min_avepp = max(min_avepp), severe_C1C2 = round(mean(severe_C1C2)),
            C1 = round(mean(C1)), C2 = round(mean(C2)), C3 = round(mean(C3)),
            C4 = round(mean(C4)), C5 = round(mean(C5)), C6 = round(mean(C6)), .groups = "drop") %>%
  arrange(desc(llik))
write_csv(distinct_sol %>% dplyr::select(-rep_seed), file.path(out_dir, "LCA_solution_landscape.csv"))
cat(sprintf("\n[landscape] %d starts -> %d DISTINCT six-class solutions\n", nrow(land), nrow(distinct_sol)))
cat("Sorted by log-likelihood (best fit first). severe_C1C2 = size of the two severe classes.\n\n")
print(as.data.frame(distinct_sol %>% dplyr::select(-rep_seed)), row.names = FALSE)

## ---- (c) Characterise the TOP solutions ------------------------------------
N_TOP <- as.integer(Sys.getenv("LCA_TOP", unset = 4))
top <- head(distinct_sol, N_TOP)
cat(sprintf("\n================ TOP %d SOLUTIONS: clinical profile + size in the 183 ================\n", nrow(top)))
for (i in seq_len(nrow(top))) {
  sd <- top$rep_seed[i]
  set.seed(sd)
  fit <- poLCA(formula_lca, data = lca_data, nclass = 6, maxiter = 5000, nrep = 1, verbose = FALSE)
  prof <- profile_classes(fit$predclass); m <- greedy_canon(prof)
  s <- summarise_fit(fit)
  assign_df <- data.frame(studysubjectid = as.character(lca_data$studysubjectid),
                          canon = m[as.character(fit$predclass)], stringsAsFactors = FALSE)
  in183 <- if (length(ids183)) table(factor(assign_df$canon[assign_df$studysubjectid %in% ids183],
                                            levels = paste0("C",1:6))) else NULL
  cat(sprintf("\n--- SOLUTION %d | reproduce with set.seed(%d) | llik=%.2f BIC=%.1f entropy=%.3f minAvePP=%.3f (%d/%d starts) ---\n",
              i, sd, top$llik[i], top$bic[i], top$entropy[i], top$min_avepp[i], top$n_seeds[i], N_SEEDS))
  ptab <- prof %>% mutate(canon = m[as.character(rc)], label = canon_name[canon]) %>%
    arrange(canon) %>%
    transmute(class = canon, phenotype = label, n_full = n,
              pct_asthma = round(100*p_asthma), pct_atopic = round(100*p_atopic),
              pct_severe = round(100*p_severe))
  print(as.data.frame(ptab), row.names = FALSE)
  if (!is.null(in183)) {
    cat("  size within the 183 EWAS participants (severe = C1 + C2):\n    ")
    v <- as.integer(in183); names(v) <- names(in183)
    cat(paste(sprintf("%s=%d", names(v), v), collapse = "  "),
        sprintf("  [severe C1+C2 = %d]\n", sum(v[c("C1","C2")], na.rm = TRUE)))
  }
}
cat(sprintf("\n[landscape] written -> %s\n", file.path(out_dir, "LCA_solution_landscape.csv")))
cat("\nHow to read: pick the solution that is well separated (entropy/minAvePP high), whose six\n")
cat("classes are the real clinical phenotypes (pct_asthma/atopic/severe make sense), AND has enough\n")
cat("severe participants in the 183 (C1+C2) to give the EWAS power. That solution is reproducible\n")
cat("with its set.seed(). Then we point make_fresh_lca_assignment.R at that seed.\n")
