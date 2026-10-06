###############################################################################
# Script 02 — LCA model selection, Excel merge, and descriptive tables (final)
# - Reads 'data complementary.xls' (no haven)
# - Merges on studysubjectid (adds 'included' and new vars)
# - EXCLUDES meanfeno and fenocat
# - Applies exclusions for VISIT 2 duplicates (GLOBAL) and 9 EPIGEN removals
# - "Not applicable - control group" rules (ACQ/ISAAC/12-month)
# - Creates 'atopy' = (Phadiatop Positive OR SPT Atopic)
# - TABLE 1 GLOBAL (n≈1354) PRE-imputation
# - Two LCA_label tables PRE-imputation: GLOBAL (n≈1354) and EPIGEN (n≈191)
# - Imputes ONLY for LCA (global); fits LCA; assigns LCA_label
# - Saves enriched datasets for Scripts 03 and 04
###############################################################################

# 1) Clean-up and libraries
rm(list = ls())
suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(poLCA)
  library(mice)
  library(gtsummary)
  library(gt)
  library(readr)
  library(readxl)
  library(ggplot2)
  library(stringr)
  library(purrr)
})

# 2) Paths and loads
source("scripts_R/00_config.R")
data_folder     <- DATA_DIR
reportDirectory <- LCA_TAB_DIR
if (!dir.exists(reportDirectory)) dir.create(reportDirectory, recursive = TRUE)

load(file.path(data_folder, "clinical_data.RData"))  # -> clinical_data

# (Optional: cell composition for Table 1)
counts_path <- file.path(data_folder, "counts.RData")
have_counts <- file.exists(counts_path)
if (have_counts) load(counts_path)  # -> counts

# 3) Read complementary Excel (exclude meanfeno/fenocat)
comp_path <- file.path(data_folder, "data complementary.xls")
comp <- readxl::read_excel(comp_path) %>%
  dplyr::select(any_of(c(
    "studysubjectid",
    "bloodeos","sputum_phenotype1_first",
    "prev","fev","zfev","percpredfev","fvc","zfvc","percpredfvc",
    "fevfvc","zfevfvc","included"
  ))) %>%
  dplyr::mutate(
    studysubjectid = as.character(studysubjectid),
    prev  = as.character(prev),
    across(c(fev, zfev, percpredfev, fvc, zfvc, percpredfvc,
             fevfvc, zfevfvc, bloodeos), ~ suppressWarnings(as.numeric(.))),
    included = {
      v <- suppressWarnings(as.numeric(included))
      v <- ifelse(is.na(v), NA_real_, ifelse(v != 0, 1, 0))
      as.integer(v)
    }
  )

# 4) Merge with clinical_data
clinical_data <- clinical_data %>%
  dplyr::mutate(studysubjectid = as.character(studysubjectid)) %>%
  dplyr::left_join(comp, by = "studysubjectid")

# 4.1) Control-group NA rules and ATOPY
clinical_data <- clinical_data %>%
  dplyr::mutate(
    severity_isaac  = ifelse(group == "Never asthma" & is.na(severity_isaac),
                             "Not applicable - control group", severity_isaac),
    severity_12atac = ifelse(group == "Never asthma" & is.na(severity_12atac),
                             "Not applicable - control group", severity_12atac),
    acqscore        = ifelse(group == "Never asthma", 0, acqscore),
    acqscorecat     = ifelse(group == "Never asthma",
                             "Not applicable - control group", acqscorecat)
  )

is_atopic_flag <- function(x) {
  if (is.factor(x)) x <- as.character(x)
  y <- tolower(trimws(as.character(x)))
  ifelse(
    y %in% c("atopic","positive","pos","1","yes","sí","si","true"),
    TRUE,
    ifelse(y %in% c("non-atopic","negative","neg","0","no","false"), FALSE, NA)
  )
}
phadia_pos_flag <- function(x) {
  if (is.factor(x)) x <- as.character(x)
  y <- tolower(trimws(as.character(x)))
  ifelse(
    y %in% c("positive","pos","1","yes","sí","si","true"),
    TRUE,
    ifelse(y %in% c("negative","neg","0","no","false"), FALSE, NA)
  )
}

clinical_data <- clinical_data %>%
  dplyr::mutate(
    sptpos_flag  = is_atopic_flag(sptpos),
    phadpos_flag = phadia_pos_flag(phadpos),
    atopy = dplyr::case_when(
      is.na(sptpos_flag) & is.na(phadpos_flag) ~ NA_character_,
      (sptpos_flag | phadpos_flag)             ~ "Atopic",
      TRUE                                     ~ "Non-atopic"
    ),
    atopy = factor(atopy, levels = c("Non-atopic","Atopic"))
  )

# ---------------------------------------------------------------------------
# 4.2) Cohort definitions
# ---------------------------------------------------------------------------

# WASP + included==1 (before exclusions)
wasp_incl <- clinical_data %>%
  filter(indicator == "WASP population", included == 1)

cat("\n[CHECK] WASP + included==1 (pre-exclusions)\n")
cat("  Rows:", nrow(wasp_incl),
    " | Unique IDs:", length(unique(wasp_incl$studysubjectid)),
    " | Duplicates:", nrow(wasp_incl) - length(unique(wasp_incl$studysubjectid)), "\n")

# (A) Remove VISIT 2 duplicates (GLOBAL cohort)
visit2_duplicates <- c("WASP148","WASP149","WASP145","WASP146","WASP156")

wasp_global <- wasp_incl %>%
  filter(!(Sample_Name %in% visit2_duplicates))

cat("\n[CHECK] GLOBAL after removing visit-2 duplicates (~1354 expected)\n")
cat("  Rows:", nrow(wasp_global),
    " | Unique IDs:", length(unique(wasp_global$studysubjectid)),
    " | Duplicates:", nrow(wasp_global) - length(unique(wasp_global$studysubjectid)), "\n")

# (B) EPIGEN cohort = non-NA Sample_Name within GLOBAL and exclude 9 samples
#     Make it robust to either Sample_Name (WASP codes) or Study_id (BR/MB/NG codes).
epigen_exclude9_sample <- c("WASP39","WASP137","WASP148","WASP149","WASP145","WASP155","WASP146","WASP156","WASP98")
epigen_exclude9_study  <- c("BR3990","MB1079","MB1147","MB1372","MB1436","MB1852","MB2080","NG836","MB1812")

epigen_candidates <- wasp_global %>% filter(!is.na(Sample_Name))
epigen_final <- epigen_candidates %>%
  filter(!(Sample_Name %in% epigen_exclude9_sample)) %>%
  { if ("Study_id" %in% names(.)) filter(., !(Study_id %in% epigen_exclude9_study)) else . }

cat("\n[CHECK] EPIGEN cohort\n")
cat("  Candidates (non-NA Sample_Name):", nrow(epigen_candidates), "\n")
cat("  After 9 exclusions (target ~191):", nrow(epigen_final), "\n")

# Cohort for LCA (GLOBAL)
clinical_data_clustering <- wasp_global %>% filter(!is.na(group))
cat("\n[INFO] n GLOBAL for LCA: ", nrow(clinical_data_clustering), "\n\n")

# ============================
# 5) TABLE 1 — GLOBAL descriptives (pre-imputation, n≈1354)
# ============================

add_counts <- function(df) {
  if (!have_counts) return(df)
  counts_temp <- counts %>% mutate(Sample_Name_join = tolower(trimws(as.character(Sample_Name))))
  df %>%
    mutate(Sample_Name_join = tolower(trimws(as.character(Sample_Name)))) %>%
    left_join(counts_temp %>% select(-Sample_Name), by = "Sample_Name_join") %>%
    select(-Sample_Name_join)
}
transform_to_ratio <- function(x) {
  x <- suppressWarnings(as.numeric(x)); x[x == 0] <- 0.001; x/100
}
add_ratio_cols <- function(df) {
  has_raw <- all(c("neutrophils1","lymphocytes1","monocytesmacrophages1",
                   "eosinophils1","squamouscells1") %in% names(df))
  if (has_raw) {
    df <- df %>%
      mutate(
        neutrophils1_ratio          = transform_to_ratio(neutrophils1),
        lymphocytes1_ratio          = transform_to_ratio(lymphocytes1),
        monocytesmacrophages1_ratio = transform_to_ratio(monocytesmacrophages1),
        eosinophils1_ratio          = transform_to_ratio(eosinophils1),
        squamouscells1_ratio        = transform_to_ratio(squamouscells1)
      )
  }
  df
}

tbl1_base <- wasp_global %>% add_counts() %>% add_ratio_cols()

vars_clin  <- c("sex","age","centre_name","group","sptpos","phadpos","atopy",
                "acqscore","acqscorecat","severity_isaac","severity_12atac")
vars_cells <- c("neutrophils1_ratio","lymphocytes1_ratio","monocytesmacrophages1_ratio",
                "eosinophils1_ratio","squamouscells1_ratio")
vars_all_tbl1 <- c(vars_clin, vars_cells)

coerce_common <- function(df) {
  df %>%
    mutate(
      sex             = as.factor(sex),
      centre_name     = as.factor(centre_name),
      group           = as.factor(group),
      sptpos          = as.factor(sptpos),
      phadpos         = as.factor(phadpos),
      acqscorecat     = as.factor(acqscorecat),
      severity_isaac  = as.factor(severity_isaac),
      severity_12atac = as.factor(severity_12atac),
      atopy           = as.factor(atopy),
      age             = suppressWarnings(as.numeric(age)),
      acqscore        = suppressWarnings(as.numeric(acqscore)),
      across(
        c(neutrophils1_ratio, lymphocytes1_ratio, monocytesmacrophages1_ratio,
          eosinophils1_ratio, squamouscells1_ratio),
        ~ suppressWarnings(as.numeric(.))
      )
    ) %>% select(any_of(vars_all_tbl1))
}

tbl_wasp_pre <- coerce_common(tbl1_base)

labs_tbl <- list(
  sex ~ "Sex",
  age ~ "Age (years)",
  centre_name ~ "Centre",
  group ~ "Asthma status (group)",
  sptpos ~ "SPT positive (Atopic)",
  phadpos ~ "Phadiatop positive",
  atopy ~ "Atopy (SPT+ or Phadiatop+)",
  acqscore ~ "ACQ score",
  acqscorecat ~ "Asthma control (ACQ category)",
  severity_isaac ~ "ISAAC severity",
  severity_12atac ~ "12-month attacks severity",
  neutrophils1_ratio ~ "% Neutrophils",
  lymphocytes1_ratio ~ "% Lymphocytes",
  monocytesmacrophages1_ratio ~ "% Monocytes/Macrophages",
  eosinophils1_ratio ~ "% Eosinophils",
  squamouscells1_ratio ~ "% Squamous cells"
)

type_tbl <- list(
  gtsummary::all_categorical() ~ "categorical",
  c(age, acqscore,
    neutrophils1_ratio, lymphocytes1_ratio, monocytesmacrophages1_ratio,
    eosinophils1_ratio, squamouscells1_ratio) ~ "continuous"
)
stat_tbl <- list(
  gtsummary::all_categorical() ~ "{n} ({p}%)",
  gtsummary::all_continuous()  ~ "{mean} ({sd})"
)

n_wasp <- nrow(tbl_wasp_pre)

tbl1 <- tbl_wasp_pre %>%
  gtsummary::tbl_summary(
    by = NULL,
    label = labs_tbl,
    type = type_tbl,
    statistic = stat_tbl,
    digits = gtsummary::all_continuous() ~ 2,
    missing = "no"
  ) %>%
  gtsummary::modify_header(label ~ "**Characteristic**") %>%
  gtsummary::modify_spanning_header(everything() ~
                                      paste0("**WASP cohort GLOBAL (included==1; visit2 removed)** (n=", n_wasp, ")"))

gt::gtsave(gtsummary::as_gt(tbl1),
           filename = file.path(reportDirectory, "Table1_WASP_GLOBAL_PREIMPUTATION.html"))
cat("Table 1 (GLOBAL, pre-imputation) saved to:\n - ",
    file.path(reportDirectory, "Table1_WASP_GLOBAL_PREIMPUTATION.html"), "\n")

# ============================
# 6) Imputation (GLOBAL only)
# ============================

vars_interes <- c("studysubjectid","Sample_Name","sex","age","centre_name","group",
                  "sptpos","phadresult","phadpos","acqscore","acqscorecat",
                  "severity_isaac","severity_12atac")

df_for_impute <- clinical_data_clustering %>%
  dplyr::select(any_of(vars_interes)) %>%
  dplyr::mutate(
    across(c(studysubjectid, Sample_Name), as.character),
    sex             = as.factor(sex),
    centre_name     = as.factor(centre_name),
    group           = as.factor(group),
    sptpos          = as.factor(sptpos),
    phadpos         = as.factor(phadpos),
    acqscorecat     = as.factor(acqscorecat),
    severity_isaac  = as.factor(severity_isaac),
    severity_12atac = as.factor(severity_12atac)
  )

# If 'phadresult' is missing entirely, add it as NA numeric so mice's method vector aligns
if (!"phadresult" %in% names(df_for_impute)) {
  df_for_impute$phadresult <- NA_real_
}

methods <- c(
  studysubjectid = "",
  Sample_Name    = "",
  sex            = "logreg",
  age            = "pmm",
  centre_name    = "polyreg",
  group          = "logreg",
  sptpos         = "logreg",
  phadresult     = "pmm",
  phadpos        = "logreg",
  acqscore       = "pmm",
  acqscorecat    = "polyreg",
  severity_isaac = "polyreg",
  severity_12atac= "polyreg"
)

imputed_data <- mice(df_for_impute, m = 1, method = methods, maxit = 10, seed = 123)
df_complete  <- complete(imputed_data, 1)

# ============================
# 7) LCA (GLOBAL)
# ============================

#lca_vars <- c("sex","centre_name","group","sptpos","phadpos",
              #"acqscorecat","severity_isaac","severity_12atac")
lca_vars <- c("group","sptpos","phadpos",
              "acqscorecat","severity_isaac","severity_12atac")

lca_data <- df_complete %>%
  dplyr::select(studysubjectid, Sample_Name, dplyr::all_of(lca_vars)) %>%
  dplyr::mutate(dplyr::across(dplyr::all_of(lca_vars), as.factor))

formula_lca <- as.formula(
  paste("cbind(", paste(lca_vars, collapse = ","), ") ~ 1")
)

# Model comparison (AIC/BIC) with a multi-seed stability check.
# We refit the LCA across a range of class solutions (2..max_clusters) using many
# random starts (different seeds). This tests whether the selected number of
# classes is stable rather than an artefact of a single fortunate initialisation.
# In the figure, the bold coloured line is the mean criterion across seeds and the
# faint grey lines are the individual seeds; the dashed line marks the class number
# that minimises the mean BIC.
max_clusters <- 12
n_seeds   <- as.integer(Sys.getenv("LCA_N_SEEDS", unset = 200))  # ~200 random starts
nrep_boot <- as.integer(Sys.getenv("LCA_NREP",    unset = 5))    # restarts per fit
n_cores   <- as.integer(Sys.getenv("SLURM_CPUS_PER_TASK", unset = 4))
cat(sprintf("LCA stability: %d seeds x classes 2-%d (nrep=%d per fit) on %d cores\n",
            n_seeds, max_clusters, nrep_boot, n_cores))

# One seed = fit classes 2..max_clusters and record BIC/AIC. Seeds are independent,
# so run them in parallel across the node's cores (poLCA itself is single-threaded).
.one_seed <- function(s) {
  set.seed(s)
  do.call(rbind, lapply(2:max_clusters, function(k) {
    m <- poLCA(formula_lca, data = lca_data, nclass = k,
               maxiter = 2000, nrep = nrep_boot, verbose = FALSE)
    data.frame(seed = s, nclass = k, BIC = m$bic, AIC = m$aic)
  }))
}
boot_list <- parallel::mclapply(seq_len(n_seeds), .one_seed, mc.cores = n_cores)
ok <- vapply(boot_list, is.data.frame, logical(1))
if (any(!ok)) cat("  [warn]", sum(!ok), "seed(s) failed and were dropped\n")
boot_df <- do.call(rbind, boot_list[ok])
write.csv(boot_df, file.path(reportDirectory, "LCA_model_comparison_bootstrap.csv"),
          row.names = FALSE)

boot_long <- boot_df %>%
  tidyr::pivot_longer(cols = c(BIC, AIC), names_to = "Criterion", values_to = "Value")
mean_long <- boot_long %>%
  dplyr::group_by(Criterion, nclass) %>%
  dplyr::summarise(Value = mean(Value, na.rm = TRUE), .groups = "drop")
# The number of classes was chosen a priori as 6 (AIC minimised at 6; BIC
# essentially tied between 5 and 6). Mark that solution; still report the raw
# minima for transparency.
chosen_k <- as.integer(Sys.getenv("LCA_CHOSEN_K", unset = 6))
min_bic_k <- mean_long %>% dplyr::filter(Criterion == "BIC") %>%
  dplyr::slice_min(Value, n = 1) %>% dplyr::pull(nclass)
min_aic_k <- mean_long %>% dplyr::filter(Criterion == "AIC") %>%
  dplyr::slice_min(Value, n = 1) %>% dplyr::pull(nclass)
cat("Mean-criterion minima -> BIC:", min_bic_k, " AIC:", min_aic_k,
    " | retained solution:", chosen_k, "classes\n")

# Keep these names for backward compatibility with any downstream use (mean curves).
results_long <- mean_long
results_df   <- mean_long %>% tidyr::pivot_wider(names_from = Criterion, values_from = Value)

bic_plot <- ggplot() +
  geom_line(data = boot_long,
            aes(x = nclass, y = Value, group = interaction(seed, Criterion)),
            colour = "grey80", linewidth = 0.3, alpha = 0.5) +
  geom_line(data = mean_long, aes(x = nclass, y = Value, color = Criterion),
            linewidth = 1.2) +
  geom_point(data = mean_long, aes(x = nclass, y = Value, color = Criterion), size = 2.6) +
  geom_vline(xintercept = chosen_k, linetype = "dashed", colour = "grey40") +
  scale_x_continuous(breaks = 2:max_clusters) +
  labs(title = "LCA model selection",
       subtitle = sprintf("Mean BIC and AIC over %d random starts (grey lines: individual seeds); dashed line: retained %d-class solution",
                          n_seeds, chosen_k),
       x = "Number of classes", y = "Criterion value", color = "Metric") +
  theme_minimal()
ggsave(file.path(LCA_FIG_DIR, "LCA_model_comparison.png"),
       plot = bic_plot, width = 9, height = 6, dpi = 300)

# Final model (6 CLASSES) — matches downstream labels
set.seed(123)
lca_model_6 <- poLCA(formula_lca, data = lca_data,
                     nclass = 6, maxiter = 2000, nrep = 10)

labels_map <- c(
  "C1" = "Asthmatic, highly atopic, severe/uncontrolled",      
  "C2" = "Asthmatic, non-atopic, severe/uncontrolled",         
  "C3" = "Asthmatic, atopic, mild/moderate, well controlled",  
  "C4" = "Control, non-atopic",                                
  "C5" = "Asthmatic, non-atopic, mild/moderate, well controlled", 
  "C6" = "Control, atopic"                                     
)

lca_assign <- lca_data %>%
  dplyr::mutate(
    LCA_class = paste0("C", lca_model_6$predclass),
    LCA_class = factor(LCA_class, levels = paste0("C", 1:6)),
    LCA_label = labels_map[as.character(LCA_class)]
  )


# ===========================================================================
# 7.5) EXTRACT ITEM RESPONSE PROBABILITIES FOR SUPPLEMENTARY MATERIAL (LCA)
# ===========================================================================
cat("\n[INFO] Extracting LCA Item Response Probabilities for Reviewers...\n")

# poLCA guarda las probabilidades condicionales en lca_model_6$probs
probs_list <- lca_model_6$probs

# Convertir la lista de matrices en un dataframe largo
lca_probs_df <- purrr::imap_dfr(probs_list, function(mat, var_name) {
  as.data.frame(mat) %>%
    mutate(Class_Raw = row_number(),
           LCA_class = paste0("C", Class_Raw)) %>%
    tidyr::pivot_longer(cols = -c(Class_Raw, LCA_class), 
                        names_to = "Category", 
                        values_to = "Probability") %>%
    mutate(Variable = var_name)
})

# Mapear a tus nombres finales de clases para que coincida con el paper
lca_probs_df <- lca_probs_df %>%
  mutate(
    LCA_label = labels_map[LCA_class],
    # Formatear un poco el texto para el gráfico
    Category = str_replace_all(Category, "Not applicable - control group", "N/A (Control)"),
    Category = str_wrap(Category, width = 20)
  )

# Guardar como CSV (Material Suplementario en Tabla)
write_csv(lca_probs_df, file.path(reportDirectory, "Table_S_LCA_Item_Response_Probabilities.csv"))

# Crear el HEATMAP (Material Suplementario en Figura)
heatmap_plot <- ggplot(lca_probs_df, aes(x = LCA_class, y = Category, fill = Probability)) +
  geom_tile(color = "white", size = 0.5) +
  geom_text(aes(label = sprintf("%.2f", Probability)), color = ifelse(lca_probs_df$Probability > 0.5, "white", "black"), size = 4) +
  facet_grid(Variable ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_fill_gradient(low = "#F7FBFF", high = "#08306B", limits = c(0, 1), name = "Probability") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Latent Class Analysis: Item Response Probabilities",
    subtitle = "Probability of each clinical variable given the latent class assignment",
    x = "Latent Class",
    y = "Variable Categories"
  ) +
  theme(
    strip.text.y.right = element_text(angle = 0, face = "bold", hjust = 0),
    axis.text.y = element_text(size = 10, color = "black"),
    axis.text.x = element_text(size = 12, face = "bold", color = "black"),
    panel.grid = element_blank(),
    plot.title = element_text(face = "bold")
  )

ggsave(file.path(LCA_FIG_DIR, "Figure_S_LCA_Heatmap.png"), plot = heatmap_plot, width = 10, height = 12, dpi = 300)
cat("[✓] LCA Probabilities Heatmap and CSV saved.\n")

# ============================
# 8) Descriptive tables ***PRE-imputation***
#     (GLOBAL and EPIGEN)
# ============================

make_table_by_lca <- function(source_df, lca_assign_df, filename_html, title_prefix) {
  # 1) one row per subject
  core_clin_vars <- intersect(
    c("studysubjectid","Sample_Name","sex","centre_name","group","sptpos","phadpos",
      "acqscorecat","severity_isaac","severity_12atac"),
    names(source_df)
  )
  core_clin <- source_df %>%
    dplyr::select(dplyr::all_of(core_clin_vars)) %>%
    arrange(studysubjectid) %>% group_by(studysubjectid) %>% slice(1) %>% ungroup()
  df_num_raw <- source_df %>%
    dplyr::select(studysubjectid, age, acqscore) %>%
    arrange(studysubjectid) %>% group_by(studysubjectid) %>% slice(1) %>% ungroup()
  safe_extra_cols <- intersect(
    c("prev","fev","zfev","percpredfev","fvc","zfvc","percpredfvc",
      "fevfvc","zfevfvc","bloodeos","sputum_phenotype1_first","included","atopy"),
    names(source_df)
  )
  extra_vars <- source_df %>%
    dplyr::select(c("studysubjectid", safe_extra_cols)) %>%
    arrange(studysubjectid) %>% group_by(studysubjectid) %>% slice(1) %>% ungroup()
  
  # 2) LCA assignment (per subject)
  lab_levels <- unname(labels_map[paste0("C", 1:6)])
  lca_assign_basic <- lca_assign_df %>%
    dplyr::select(studysubjectid, LCA_class, LCA_label) %>%
    arrange(studysubjectid) %>% group_by(studysubjectid) %>% slice(1) %>% ungroup() %>%
    mutate(LCA_label = factor(LCA_label, levels = lab_levels))
  
  # 3) Join and coerce
  tbl_input <- lca_assign_basic %>%
    left_join(core_clin,  by = "studysubjectid", relationship = "one-to-one") %>%
    left_join(df_num_raw, by = "studysubjectid", relationship = "one-to-one") %>%
    left_join(extra_vars, by = "studysubjectid", relationship = "one-to-one") %>%
    mutate(
      sex             = as.factor(sex),
      centre_name     = as.factor(centre_name),
      group           = as.factor(group),
      sptpos          = as.factor(sptpos),
      phadpos         = as.factor(phadpos),
      acqscorecat     = as.factor(acqscorecat),
      severity_isaac  = as.factor(severity_isaac),
      severity_12atac = as.factor(severity_12atac),
      atopy           = as.factor(atopy),
      age             = suppressWarnings(as.numeric(age)),
      acqscore        = suppressWarnings(as.numeric(acqscore)),
      prev            = if ("prev" %in% names(.)) as.factor(prev) else NULL,
      sputum_phenotype1_first = if ("sputum_phenotype1_first" %in% names(.))
        as.factor(sputum_phenotype1_first) else NULL,
      included        = if ("included" %in% names(.)) factor(included, levels = c(0,1),
                                                             labels = c("No","Yes")) else NULL
    )
  
  # 4) Table
  vars_desc <- c(
    intersect(c("sex","age","centre_name","group","sptpos","phadpos","atopy",
                "acqscore","acqscorecat","severity_isaac","severity_12atac"),
              names(tbl_input)),
    intersect(c("prev","fev","zfev","percpredfev","fvc","zfvc","percpredfvc",
                "fevfvc","zfevfvc","bloodeos","sputum_phenotype1_first","included"),
              names(tbl_input))
  )
  type_list <- list(
    gtsummary::all_categorical() ~ "categorical",
    c(intersect(c("age","acqscore","fev","zfev","percpredfev","fvc","zfvc",
                  "percpredfvc","fevfvc","zfevfvc","bloodeos"),
                names(tbl_input))) ~ "continuous"
  )
  stat_list <- list(
    gtsummary::all_categorical() ~ "{n} ({p}%)",
    gtsummary::all_continuous()  ~ "{mean} ({sd})"
  )
  
  sizes <- tbl_input %>%
    count(LCA_label) %>%
    tidyr::complete(LCA_label = factor(lab_levels, levels = lab_levels), fill = list(n = 0)) %>%
    arrange(LCA_label) %>% pull(n)
  
  updates <- list(label ~ "**Characteristic**")
  for (i in seq_along(lab_levels)) {
    nm  <- paste0("stat_", i)
    lab <- paste0(lab_levels[i], " (n=", sizes[i], ")")
    updates[[length(updates) + 1]] <- rlang::new_formula(as.symbol(nm), lab)
  }
  
  tbl_lca <- tbl_input %>%
    gtsummary::tbl_summary(
      by = LCA_label,
      include  = dplyr::all_of(vars_desc),
      type     = type_list,
      statistic= stat_list,
      digits   = gtsummary::everything() ~ 2,
      missing  = "no"
    ) %>%
    gtsummary::modify_header(update = updates) %>%
    gtsummary::modify_spanning_header(gtsummary::all_stat_cols() ~
                                        paste0("**", title_prefix, "**")) %>%
    gtsummary::bold_labels()
  
  gt_tbl <- gtsummary::as_gt(tbl_lca) %>%
    gt::tab_options(table.font.size = gt::px(13)) %>%
    gt::tab_source_note(gt::md("Notes: Continuous = mean (SD); categorical = n (%). Cohort restricted to included == 1. Descriptives without imputation."))
  
  gt::gtsave(gt_tbl, filename = file.path(reportDirectory, filename_html))
  
  cat("\n[CHECK] Class counts in", filename_html, ":\n")
  print(table(tbl_input$LCA_label, useNA = "ifany"))
  
  invisible(tbl_input)
}

# 8A) GLOBAL (~1354)
tbl_global <- make_table_by_lca(
  source_df     = wasp_global,
  lca_assign_df = lca_assign,
  filename_html = "Table_LCA_by_class_GLOBAL_PREIMPUTATION.html",
  title_prefix  = "Latent classes (GLOBAL cohort)"
)

# 8B) EPIGEN (~191)
tbl_epigen <- make_table_by_lca(
  source_df     = epigen_final,
  lca_assign_df = lca_assign %>% filter(studysubjectid %in% epigen_final$studysubjectid),
  filename_html = "Table_LCA_by_class_EPI_PREIMPUTATION.html",
  title_prefix  = "Latent classes (EPIGENETIC cohort)"
)

# ============================
# 9) Saves for Scripts 03/04
# ============================

lab_levels <- unname(labels_map[paste0("C", 1:6)])
lca_label_one <- lca_assign %>%
  select(studysubjectid, LCA_label) %>%
  distinct(studysubjectid, .keep_all = TRUE)

clinical_data_epigen_total <- wasp_global %>%     # <- GLOBAL final cohort
  left_join(lca_label_one, by = "studysubjectid") %>%
  mutate(lca_class = as.integer(factor(LCA_label, levels = lab_levels)))

save(lca_model_6, lca_assign, clinical_data_epigen_total,
     file = file.path(data_folder, "clinical_data_epigen_total.RData"))

cat("\n[✓] Done: GLOBAL Table 1, LCA-by-class tables (GLOBAL & EPIGEN), and final dataset saved.\n")



###############################################################################
# OUTPUTS
# - LCA_model_comparison.png
# - Table1_WASP_GLOBAL_PREIMPUTATION.html
# - Table_LCA_by_class_GLOBAL_PREIMPUTATION.html
# - Table_LCA_by_class_EPI_PREIMPUTATION.html
# - clinical_data_epigen_total.RData   (GLOBAL + atopy + LCA_label)
###############################################################################
