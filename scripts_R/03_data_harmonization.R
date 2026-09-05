###############################################################################

# Script 03 — Harmonization + Post-QC tables + LCA comparison datasets (FIXED)

# - GLOBAL (~1354) intact (desde Script 02)

# - QC-EPIGEN = n según qc_pass_df$studysubjectid (p.ej., ~183)

# - Tabla 1: GLOBAL vs QC-EPIGEN (dos columnas)  [media (DE)]

# - Tabla 2: QC-EPIGEN por LCA_label             [orden C1..C6, sin rotaciones]

# - Datasets A1–A14 para EWAS (sobre QC-EPIGEN), sin alterar labels ni orden

###############################################################################



# 0) Clean environment and load libraries

rm(list = ls())

suppressPackageStartupMessages({

  library(dplyr); library(tidyr); library(gtsummary); library(gt)

  library(readr); library(readxl); library(stringr); library(purrr)

})



# 1) Paths / loads

source("scripts_R/00_config.R")
data_folder <- DATA_DIR

report_dir  <- COHORT_DIR

if (!dir.exists(report_dir)) dir.create(report_dir, recursive = TRUE)



# Cargas

load(file.path(data_folder, "norm.betaOct2025.RData"))            # -> beta

load(file.path(data_folder, "clinical_data_epigen_total.RData")) # -> clinical_data_epigen_total (ya trae LCA_label)

counts_path  <- file.path(data_folder, "counts.RData")

have_counts  <- file.exists(counts_path); if (have_counts) load(counts_path)  # -> counts

load(file.path(data_folder, "epigen_qc_passed_ids.RData"))       # -> qc_pass_df con studysubjectid



# 1.1) Definir labels_map y el ORDEN CANÓNICO C1..C6 (ACTUALIZADO para nuevo LCA)

labels_map <- c(

  "C1" = "Asthmatic, highly atopic, severe/uncontrolled",      

  "C2" = "Asthmatic, non-atopic, severe/uncontrolled",         

  "C3" = "Asthmatic, atopic, predominantly mild/moderate",  

  "C4" = "Control, non-atopic",                                

  "C5" = "Asthmatic, non-atopic, predominantly mild/moderate", 

  "C6" = "Control, atopic"                                     

)

lab_levels <- unname(labels_map[paste0("C", 1:6)])  # Orden fijo C1..C6



# 1.2) FREEZE de la asignacion de clases LCA (reproduce la corrida Feb-2026 del manuscrito)
#
# poLCA renumera las clases latentes entre versiones de R/poLCA, asi que re-ajustar en
# un entorno nuevo pega el labels_map (fijo por numero de clase) a los clusters
# equivocados. Para reproducir el manuscrito exactamente, sobreescribimos LCA_label y
# lca_class desde una tabla congelada studysubjectid -> clase exportada del ajuste
# original de Feb-2026, en vez de confiar en las etiquetas guardadas en
# clinical_data_epigen_total.RData. El CSV es un input (no se publica: trae ids de sujeto);
# vive en DATA_DIR. Si no existe, se usan las etiquetas del RData (pueden estar mal).
frozen_path <- Sys.getenv("LCA_FROZEN_CSV",
                          unset = file.path(data_folder, "LCA_class_assignment_FROZEN_feb2026.csv"))
if (file.exists(frozen_path)) {
  frozen <- readr::read_csv(frozen_path, show_col_types = FALSE)
  frozen <- frozen %>%
    dplyr::mutate(
      studysubjectid   = as.character(studysubjectid),
      LCA_label_frozen = as.character(LCA_label),
      lca_class_frozen = {
        v <- suppressWarnings(as.integer(gsub("^C", "", as.character(lca_class))))
        if (all(is.na(v))) suppressWarnings(as.integer(as.character(lca_class))) else v
      }
    ) %>%
    dplyr::select(studysubjectid, LCA_label_frozen, lca_class_frozen)

  bad_lab <- setdiff(unique(frozen$LCA_label_frozen), lab_levels)
  if (length(bad_lab)) stop("[FREEZE] Frozen labels not in labels_map: ",
                            paste(bad_lab, collapse = " | "))

  clinical_data_epigen_total <- clinical_data_epigen_total %>%
    dplyr::mutate(studysubjectid = as.character(studysubjectid)) %>%
    dplyr::left_join(frozen, by = "studysubjectid") %>%
    dplyr::mutate(
      LCA_label = ifelse(!is.na(LCA_label_frozen), LCA_label_frozen, as.character(LCA_label)),
      lca_class = ifelse(!is.na(lca_class_frozen), lca_class_frozen, lca_class)
    ) %>%
    dplyr::select(-LCA_label_frozen, -lca_class_frozen)

  cat(sprintf("[FREEZE] Applied frozen LCA assignment from %s (%d subjects in table)\n",
              frozen_path, nrow(frozen)))
} else {
  cat("[FREEZE][warn] frozen CSV not found at ", frozen_path,
      " - using LCA_label from the RData (may be mislabelled)\n", sep = "")
}



# 2) (Opcional) Mapear beta a Sample_Name si fuese necesario

if (!all(colnames(beta) %in% clinical_data_epigen_total$Sample_Name)) {

  clinical_data_epigen_total <- clinical_data_epigen_total %>%

    mutate(

      Sentrix_ID        = as.character(Sentrix_ID),

      Sentrix_Position = as.character(Sentrix_Position),

      combined_ID       = paste0(Sentrix_ID, "_", Sentrix_Position)

    )

  map_combined_to_sample <- setNames(clinical_data_epigen_total$Sample_Name,

                                     clinical_data_epigen_total$combined_ID)

  new_colnames <- map_combined_to_sample[colnames(beta)]

  keep         <- !is.na(new_colnames)

  beta         <- beta[, keep, drop = FALSE]

  colnames(beta) <- new_colnames[keep]

}



# 3) Definir cohortes (sin recalcular LCA)

global_df <- clinical_data_epigen_total  # GLOBAL completo (~1354) con LCA_label ya asignado en Script 02



stopifnot(exists("qc_pass_df"), "studysubjectid" %in% names(qc_pass_df))

kept_ssid <- unique(qc_pass_df$studysubjectid)



qc_epigen_df <- global_df %>%

  filter(studysubjectid %in% kept_ssid, !is.na(Sample_Name))



cat(sprintf("[INFO] N GLOBAL = %d | N QC-EPIGEN = %d\n",

            nrow(global_df), nrow(qc_epigen_df)))



# 3.1) Coverage check of the frozen assignment on the EWAS cohort
n_bad_lab <- sum(is.na(qc_epigen_df$LCA_label) | !(qc_epigen_df$LCA_label %in% lab_levels))
cat(sprintf("[FREEZE][check] QC-EPIGEN subjects without a valid LCA_label: %d of %d\n",
            n_bad_lab, nrow(qc_epigen_df)))
cat("[FREEZE][check] QC-EPIGEN class counts (should match the manuscript):\n")
print(table(factor(qc_epigen_df$LCA_label, levels = lab_levels), useNA = "ifany"))
if (n_bad_lab > 0) stop(sprintf(
  "[FREEZE] %d QC-EPIGEN subjects are not covered by the frozen assignment; the EWAS contrasts would be built on an incomplete labelling. Check LCA_FROZEN_CSV covers every QC-EPIGEN studysubjectid.",
  n_bad_lab))



# 4) Añadir conteos celulares de forma segura (sin duplicar filas) + ratios

add_counts_safe <- function(df, counts_obj) {

  if (missing(counts_obj) || is.null(counts_obj)) return(df)

  if (!nrow(counts_obj)) return(df)

  norm <- function(x) tolower(trimws(as.character(x)))

  counts_norm <- counts_obj %>%

    mutate(

      Sample_Name    = if ("Sample_Name" %in% names(.)) as.character(Sample_Name) else NA_character_,

      studysubjectid = if ("studysubjectid" %in% names(.)) as.character(studysubjectid) else NA_character_,

      sname_join     = if ("Sample_Name" %in% names(.)) norm(Sample_Name) else NA_character_,

      ssid_join      = if ("studysubjectid" %in% names(.)) norm(studysubjectid) else NA_character_

    )

  by_sname <- counts_norm %>%

    filter(!is.na(sname_join) & nchar(sname_join) > 0) %>%

    arrange(sname_join) %>% group_by(sname_join) %>% slice_head(n = 1) %>% ungroup() %>%

    select(-ssid_join)

  by_ssid <- counts_norm %>%

    filter(!is.na(ssid_join) & nchar(ssid_join) > 0) %>%

    arrange(ssid_join) %>% group_by(ssid_join) %>% slice_head(n = 1) %>% ungroup() %>%

    select(-sname_join)

  df1 <- df %>%

    mutate(sname_join = norm(Sample_Name), ssid_join = norm(studysubjectid)) %>%

    left_join(by_sname, by = "sname_join", suffix = c("", ".sname"))

  target_cols <- c("neutrophils1","lymphocytes1","monocytesmacrophages1",

                   "eosinophils1","squamouscells1")

  t_present_sname <- intersect(target_cols, names(df1))

  missing_counts <- if (length(t_present_sname)) {

    df1 %>%

      mutate(.miss_flag = ifelse(rowSums(is.na(across(all_of(t_present_sname)))) == length(t_present_sname), TRUE, FALSE)) %>%

      pull(.miss_flag)

  } else rep(TRUE, nrow(df1))

  if (any(missing_counts)) {

    df2 <- df1 %>% left_join(by_ssid, by = "ssid_join", suffix = c("", ".ssid"))

    for (col in target_cols) {

      col_ssid <- paste0(col, ".ssid")

      if (col %in% names(df2) && col_ssid %in% names(df2)) {

        df2[[col]] <- dplyr::coalesce(df2[[col]], df2[[col_ssid]])

      } else if (!(col %in% names(df2)) && col_ssid %in% names(df2)) {

        df2[[col]] <- df2[[col_ssid]]

      }

    }

    drop_aux <- c("sname_join","ssid_join",

                  intersect(paste0(target_cols, ".ssid"), names(df2)),

                  intersect(paste0(target_cols, ".sname"), names(df2)))

    df2 %>% select(-any_of(drop_aux))

  } else {

    df1 %>% select(-any_of(c("sname_join","ssid_join")))

  }

}



to_ratio <- function(x) { x <- suppressWarnings(as.numeric(x)); x[x==0] <- 0.001; x/100 }

add_ratio_cols <- function(df) {

  need <- c("neutrophils1","lymphocytes1","monocytesmacrophages1","eosinophils1","squamouscells1")

  avail <- intersect(need, names(df))

  if (length(avail) == length(need)) {

    df <- df %>%

      mutate(

        neutrophils1_ratio          = to_ratio(neutrophils1),

        lymphocytes1_ratio          = to_ratio(lymphocytes1),

        monocytesmacrophages1_ratio = to_ratio(monocytesmacrophages1),

        eosinophils1_ratio          = to_ratio(eosinophils1),

        squamouscells1_ratio        = to_ratio(squamouscells1)

      )

  }

  df

}



if (have_counts) {

  global_df    <- global_df    %>% add_counts_safe(counts) %>% add_ratio_cols()

  qc_epigen_df <- qc_epigen_df %>% add_counts_safe(counts) %>% add_ratio_cols()

}



cat(sprintf("[CHECK] Post-join sizes: GLOBAL=%d | QC-EPIGEN=%d\n",

            nrow(global_df), nrow(qc_epigen_df)))



# 5) TABLA 1 — GLOBAL vs QC-EPIGEN (dos columnas, métricas como Script 02: mean (SD))

vars_tbl1 <- c(

  "sex","age","centre_name","group","sptpos","phadpos","atopy",

  "acqscore","acqscorecat","severity_isaac","severity_12atac",

  "neutrophils1_ratio","lymphocytes1_ratio","monocytesmacrophages1_ratio",

  "eosinophils1_ratio","squamouscells1_ratio"

)



coerce_for_tbl <- function(df) {

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

      age      = suppressWarnings(as.numeric(age)),

      acqscore = suppressWarnings(as.numeric(acqscore)),

      across(

        c(neutrophils1_ratio, lymphocytes1_ratio, monocytesmacrophages1_ratio,

          eosinophils1_ratio, squamouscells1_ratio),

        ~ suppressWarnings(as.numeric(.))

      )

    ) %>%

    select(any_of(vars_tbl1))

}



tbl_global_df    <- coerce_for_tbl(global_df)

tbl_qc_epigen_df <- coerce_for_tbl(qc_epigen_df)



n_global    <- nrow(tbl_global_df)

n_qc_epigen <- nrow(tbl_qc_epigen_df)

if (n_qc_epigen == 0L) stop("QC-EPIGEN vacío: revisar qc_pass_df$studysubjectid vs clinical_data_epigen_total.")



tbl_global <- tbl_summary(

  tbl_global_df,

  type = list(

    all_categorical() ~ "categorical",

    c(age, acqscore,

      neutrophils1_ratio, lymphocytes1_ratio, monocytesmacrophages1_ratio,

      eosinophils1_ratio, squamouscells1_ratio) ~ "continuous"

  ),

  statistic = list(

    all_categorical() ~ "{n} ({p}%)",

    all_continuous()  ~ "{median} ({p25},{p75})"

  ),

  digits = all_continuous() ~ 2, missing = "no"

) %>% modify_header(label ~ "**Characteristic**")



tbl_qc <- tbl_summary(

  tbl_qc_epigen_df,

  type = list(

    all_categorical() ~ "categorical",

    c(age, acqscore,

      neutrophils1_ratio, lymphocytes1_ratio, monocytesmacrophages1_ratio,

      eosinophils1_ratio, squamouscells1_ratio) ~ "continuous"

  ),

  statistic = list(

    all_categorical() ~ "{n} ({p}%)",

    all_continuous()  ~ "{median} ({p25},{p75}))"

  ),

  digits = all_continuous() ~ 2, missing = "no"

)



tbl1_merged <- tbl_merge(

  tbls = list(tbl_global, tbl_qc),

  tab_spanner = c(

    paste0("**GLOBAL (n=", n_global, ")**"),

    paste0("**QC-EPIGEN (n=", n_qc_epigen, ")**")

  )

) %>%

  modify_spanning_header(all_stat_cols() ~ "**WASP cohort: GLOBAL vs QC-EPIGEN (post-QC)**") %>%

  bold_labels()



gt::gtsave(as_gt(tbl1_merged), filename = file.path(report_dir, "Table1_GLOBAL_vs_QC-EPIGEN.html"))

cat("[✓] Table 1 guardada en:\n - ", file.path(report_dir, "Table1_GLOBAL_vs_QC-EPIGEN.html"), "\n")



# 6) TABLA 2 — QC-EPIGEN por LCA_label

#    CLAVE: fijar factor(LCA_label) con levels = lab_levels (C1..C6) y calcular tamaños en ese orden.



# Coerción estable de LCA_label

qc_epigen_df <- qc_epigen_df %>%

  mutate(LCA_label = factor(as.character(LCA_label), levels = lab_levels))



# Tamaños por clase *en ese orden*

size_by_class <- qc_epigen_df %>%

  transmute(LCA_label = factor(as.character(LCA_label), levels = lab_levels)) %>%

  count(LCA_label, name = "n", .drop = FALSE) %>%

  arrange(LCA_label) %>% pull(n)



# Derived flag for honest reporting: does the participant meet INDIVIDUAL severity
# criteria (ISAAC or ATAC severe/uncontrolled)? LCA classes are multivariate latent
# phenotypes, so a minority of the milder classes still meet these criteria. We report
# the per-class percentage so the reader sees this, rather than inferring it.
qc_epigen_df <- qc_epigen_df %>%
  mutate(severity_criteria_met = factor(
    ifelse(grepl("severe|uncontrolled", tolower(as.character(severity_isaac))) |
           grepl("severe|uncontrolled", tolower(as.character(severity_12atac))),
           "Yes", "No"),
    levels = c("No", "Yes")))

vars_tbl2 <- c(vars_tbl1, "severity_criteria_met")



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

      gtsummary::all_continuous()  ~ "{median} ({p25},{p75}))"

    ),

    digits   = gtsummary::all_continuous() ~ 2,

    missing  = "no"

  ) %>%

  {

    # Encabezados alineados con el orden de levels (C1..C6)

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



gt::gtsave(gtsummary::as_gt(tbl2_lca),

           filename = file.path(report_dir, "Table2_QC-EPIGEN_by_LCA.html"))

cat("[✓] Table 2 guardada en:\n - ",

    file.path(report_dir, "Table2_QC-EPIGEN_by_LCA.html"), "\n")



# 7) Prepare EWAS datasets A1–A14 (solo QC-EPIGEN; sin tocar niveles de LCA)

beta_qc <- beta[, qc_epigen_df$Sample_Name, drop = FALSE]

stopifnot(identical(colnames(beta_qc), qc_epigen_df$Sample_Name))



# Alias legibles de clases (Actualizados)

C1 <- labels_map["C1"] # Asma Severa Atópica

C2 <- labels_map["C2"] # Asma Severa No Atópica

C3 <- labels_map["C3"] # Asma Leve Atópica

C4 <- labels_map["C4"] # Control Sano

C5 <- labels_map["C5"] # Asma Leve No Atópica

C6 <- labels_map["C6"] # Control Atópico



mk_dataset <- function(beta_mat, clin_df, case_labels, ctrl_labels,

                       comp_name_left, comp_name_right, outfile_stub) {

  keep <- clin_df %>% filter(LCA_label %in% c(case_labels, ctrl_labels))

  keep <- keep %>%

    mutate(comparison = ifelse(LCA_label %in% case_labels, comp_name_left, comp_name_right)) %>%

    mutate(comparison = factor(comparison, levels = c(comp_name_right, comp_name_left)))

  beta_sub <- beta_mat[, keep$Sample_Name, drop = FALSE]

  stopifnot(identical(colnames(beta_sub), keep$Sample_Name))

  cat("[DATASET]", outfile_stub, "N=", ncol(beta_sub),

      " | cases=", sum(keep$comparison == comp_name_left),

      " | controls=", sum(keep$comparison == comp_name_right), "\n")

  save(beta_sub, keep, file = file.path(data_folder, paste0(outfile_stub, ".RData")))

}



# --- A1: Global Asthma vs Global Controls ---

# Asmáticos: C1, C2, C3, C5

# Controles: C4, C6

mk_dataset(beta_qc, qc_epigen_df, c(C1, C2, C3, C5), c(C4, C6),

           "(Asthma_All)", "(Controls_All)",

           "df_A1_asthma_GLOBAL_vs_CONTROLS")



# --- A2: Asthma Atopic vs Control Atopic ---

# Asma Atópica: C1, C3

# Control Atópico: C6

mk_dataset(beta_qc, qc_epigen_df, c(C1, C3), c(C6),

           "(Asthma_Atopic)", "Control_Atopic",

           "df_A2_asthma_ATOPIC_vs_Control_Atopic")



# --- A3: Asthma Non-Atopic vs Control Non-Atopic ---

# Asma No Atópica: C2, C5

# Control No Atópico: C4

mk_dataset(beta_qc, qc_epigen_df, c(C2, C5), c(C4),

           "(Asthma_NonAtopic)", "Control_NonAtopic",

           "df_A3_asthma_NONATOPIC_vs_Control_NonAtopic")



# --- B5: Atopy within Controls ---

# C6 (Atópico) vs C4 (No Atópico)

mk_dataset(beta_qc, qc_epigen_df, c(C6), c(C4),

           "Control_Atopic", "Control_NonAtopic",

           "df_B5_atopy_CONTROLS_C6_vs_C4")



# --- B6: Atopy within Asthma ---

# Asma Atópica (C1, C3) vs Asma No Atópica (C2, C5)

mk_dataset(beta_qc, qc_epigen_df, c(C1, C3), c(C2, C5),

           "(Asthma_Atopic)", "(Asthma_NonAtopic)",

           "df_B6_atopy_IN_ASTHMA")



# --- B7: Atopy Global ---

# Todos Atópicos (C1, C3, C6) vs Todos No Atópicos (C2, C4, C5)

mk_dataset(beta_qc, qc_epigen_df, c(C1, C3, C6), c(C2, C4, C5),

           "(All_Atopic)", "(All_NonAtopic)",

           "df_B7_atopy_GLOBAL")



# --- A7: Severity Independent of Atopy ---

# Severos (C1, C2) vs Leves (C3, C5)

mk_dataset(beta_qc, qc_epigen_df, c(C1, C2), c(C3, C5),

           "(Severe_All)", "(MildMod_All)",

           "df_A7_severity_INDEPENDENT")



# --- A8: Severity within Atopics ---

# Severo Atópico (C1) vs Leve Atópico (C3)

mk_dataset(beta_qc, qc_epigen_df, c(C1), c(C3),

           "Severe_Atopic", "Mild_Atopic",

           "df_A8_severity_ATOPIC_C1_vs_C3")



# One-vs-rest signatures

mk_dataset(beta_qc, qc_epigen_df, c(C1), c(C2,C3,C4,C5,C6),

           "C1", "(rest)", "df_A9_phenotype_signature_C1_vs_rest")

mk_dataset(beta_qc, qc_epigen_df, c(C2), c(C1,C3,C4,C5,C6),

           "C2", "(rest)", "df_A10_phenotype_signature_C2_vs_rest")

mk_dataset(beta_qc, qc_epigen_df, c(C3), c(C1,C2,C4,C5,C6),

           "C3", "(rest)", "df_A11_phenotype_signature_C3_vs_rest")

mk_dataset(beta_qc, qc_epigen_df, c(C4), c(C1,C2,C3,C5,C6),

           "C4", "(rest)", "df_A12_phenotype_signature_C4_vs_rest")

mk_dataset(beta_qc, qc_epigen_df, c(C5), c(C1,C2,C3,C4,C6),

           "C5", "(rest)", "df_A13_phenotype_signature_C5_vs_rest")

mk_dataset(beta_qc, qc_epigen_df, c(C6), c(C1,C2,C3,C4,C5),

           "C6", "(rest)", "df_A14_phenotype_signature_C6_vs_rest")



# 8) Conveniences para Script 04

beta_total_meffil <- beta

save(beta_total_meffil, file = file.path(data_folder, "beta_total_meffil.RData"))

save(qc_epigen_df,       file = file.path(data_folder, "clinical_QC-EPIGEN_meffil.RData"))



cat("\n[✓] Harmonization + Tables + Datasets A1–A14 ready for Script 4.\n")

cat("    - Table1_GLOBAL_vs_QC-EPIGEN.html\n")

cat("    - Table2_QC-EPIGEN_by_LCA.html\n")

cat("    - df_* RData files for A1–A14\n")

cat("    - beta_total_meffil.RData, clinical_QC-EPIGEN_meffil.RData\n")

###############################################################################
