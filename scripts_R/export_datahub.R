###############################################################################
# export_datahub.R — build the clean-data package for the group DataHub
#
# Produces, in one folder OUTSIDE the repository (default ~/EPIC/datahub_package,
# override with DATAHUB_OUT), the deliverables for Lucy Pembrey and Charlotte:
#
#   1. Clean methylation matrices for the 183 EWAS participants, rows = participant
#      (studysubjectid), cols = CpG probe:
#        - methylation_Bvalues_183xprobes.(rds|csv.gz)   B-values (0-1)
#        - methylation_Mvalues_183xprobes.(rds|csv.gz)   M-values = log2(B/(1-B))
#   2. LCA phenotype of the 183 (frozen assignment): studysubjectid + lca_class +
#      LCA_label, as .csv, .dta (Stata) and .rds.
#   3. Copies of the QC / cleaning reports.
#   4. A README explaining the array, the probes, the cleaning, the values, how to
#      reproduce the data, and why methylation is delivered in R and not in Stata.
#
# Individual-level data + subject IDs: the output folder is OUTSIDE the repo and is
# also gitignored, so it is never pushed. David downloads it and emails it.
#
# Independent of the LCA re-run: methylation is the same clean data, and the 183 LCA
# labels come from the frozen CSV (authoritative). Run from the repository root:
#   Rscript scripts_R/export_datahub.R
###############################################################################

rm(list = ls())
suppressPackageStartupMessages({ library(dplyr); library(readr) })

source("scripts_R/00_config.R")
data_folder <- DATA_DIR
out_dir <- Sys.getenv("DATAHUB_OUT", unset = file.path(dirname(data_folder), "datahub_package"))
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
cat("[export] output folder:", out_dir, "\n")

## ---- Inputs ----------------------------------------------------------------
load(file.path(data_folder, "beta_total_meffil.RData"))         # -> beta_total_meffil (probes x samples)
load(file.path(data_folder, "clinical_QC-EPIGEN_meffil.RData")) # -> qc_epigen_df (183; studysubjectid, Sample_Name)
frozen_path <- Sys.getenv("LCA_FROZEN_CSV",
                          unset = file.path(data_folder, "LCA_class_assignment_FRESH_profile.csv"))
if (!file.exists(frozen_path)) stop("Frozen LCA CSV not found: ", frozen_path)
frozen <- read_csv(frozen_path, show_col_types = FALSE) %>%
  mutate(studysubjectid = as.character(studysubjectid))

beta <- beta_total_meffil
qc <- qc_epigen_df %>%
  mutate(studysubjectid = as.character(studysubjectid),
         Sample_Name = as.character(Sample_Name)) %>%
  filter(Sample_Name %in% colnames(beta)) %>%
  distinct(studysubjectid, .keep_all = TRUE)
cat(sprintf("[export] QC-EPIGEN participants with methylation: %d\n", nrow(qc)))

# LCA phenotype table for these participants, labels taken from the frozen CSV.
pheno <- qc %>%
  select(studysubjectid, Sample_Name) %>%
  left_join(frozen %>% select(studysubjectid, lca_class, LCA_label), by = "studysubjectid")
n_missing <- sum(is.na(pheno$LCA_label))
if (n_missing > 0) cat(sprintf("[export][warn] %d participants have no frozen LCA label\n", n_missing))

## ---- Methylation matrices (participant x probe) ----------------------------
samples <- pheno$Sample_Name
B <- t(beta[, samples, drop = FALSE])          # participants x probes, B-values
rownames(B) <- pheno$studysubjectid
storage.mode(B) <- "double"
# M-values with a small clamp to keep the logit finite.
eps <- 1e-6
Bc <- pmin(pmax(B, eps), 1 - eps)
M <- log2(Bc / (1 - Bc))
rm(Bc)
cat(sprintf("[export] methylation matrix: %d participants x %d probes\n", nrow(B), ncol(B)))

saveRDS(B, file.path(out_dir, "methylation_Bvalues_183xprobes.rds"))
saveRDS(M, file.path(out_dir, "methylation_Mvalues_183xprobes.rds"))

# Gzip CSV (portable). Prefer data.table::fwrite (fast); fall back to gzfile.
write_matrix_gz <- function(mat, path) {
  df <- data.frame(studysubjectid = rownames(mat), mat, check.names = FALSE)
  if (requireNamespace("data.table", quietly = TRUE)) {
    data.table::fwrite(df, path, compress = "gzip")
  } else {
    con <- gzfile(path, "w"); utils::write.csv(df, con, row.names = FALSE); close(con)
  }
}
write_matrix_gz(B, file.path(out_dir, "methylation_Bvalues_183xprobes.csv.gz"))
write_matrix_gz(M, file.path(out_dir, "methylation_Mvalues_183xprobes.csv.gz"))
rm(M)

## ---- LCA phenotype file (csv + Stata + rds) --------------------------------
pheno_out <- pheno %>% select(studysubjectid, lca_class, LCA_label)
write_csv(pheno_out, file.path(out_dir, "LCA_phenotype_183.csv"))
saveRDS(pheno_out, file.path(out_dir, "LCA_phenotype_183.rds"))
dta_ok <- FALSE
if (requireNamespace("haven", quietly = TRUE)) {
  try({ haven::write_dta(pheno_out, file.path(out_dir, "LCA_phenotype_183.dta")); dta_ok <- TRUE }, silent = TRUE)
}
if (!dta_ok && requireNamespace("foreign", quietly = TRUE)) {
  try({ foreign::write.dta(as.data.frame(pheno_out), file.path(out_dir, "LCA_phenotype_183.dta")); dta_ok <- TRUE }, silent = TRUE)
}
cat("[export] Stata .dta for the phenotype:", ifelse(dta_ok, "written", "SKIPPED (install haven or foreign)"), "\n")

## ---- Full-cohort assignment + environment (for exact reproducibility) ------
# Ship the full 1354-participant assignment (the anchor the whole pipeline reads) and a
# record of the R / package versions, so the analysis reproduces exactly from data + code.
try(file.copy(frozen_path, file.path(out_dir, "LCA_class_assignment_full_1354.csv"),
              overwrite = TRUE), silent = TRUE)
pkg_ver <- function(p) as.character(tryCatch(utils::packageVersion(p), error = function(e) NA))
writeLines(c(R.version.string,
             paste("poLCA:",  pkg_ver("poLCA")),
             paste("mice:",   pkg_ver("mice")),
             paste("meffil:", pkg_ver("meffil")),
             paste("dplyr:",  pkg_ver("dplyr")),
             paste("readr:",  pkg_ver("readr"))),
           file.path(out_dir, "ENVIRONMENT.txt"))
cat("[export] wrote LCA_class_assignment_full_1354.csv + ENVIRONMENT.txt\n")

## ---- Posterior probabilities (1354) ----------------------------------------
post_src <- file.path(data_folder, "LCA_posterior_probabilities_1354.csv")
if (file.exists(post_src)) {
  file.copy(post_src, file.path(out_dir, "LCA_posterior_probabilities_1354.csv"), overwrite = TRUE)
  cat("[export] copied LCA_posterior_probabilities_1354.csv\n")
} else {
  cat("[export][warn] posterior CSV not found - re-run scripts_R/make_fresh_lca_assignment.R\n")
}

## ---- Full clinical database of the EWAS participants (with LCA class) -------
clin_vars <- c("studysubjectid","Sample_Name","sex","age","centre_name","group",
               "sptpos","phadpos","atopy","acqscore","acqscorecat",
               "severity_isaac","severity_12atac",
               "neutrophils1_ratio","lymphocytes1_ratio","monocytesmacrophages1_ratio",
               "eosinophils1_ratio","squamouscells1_ratio","lca_class","LCA_label")
clin_db <- qc %>%
  left_join(qc_epigen_df %>% mutate(studysubjectid = as.character(studysubjectid)),
            by = c("studysubjectid","Sample_Name"), suffix = c("", ".y")) %>%
  mutate(lca_class = pheno$lca_class[match(studysubjectid, pheno$studysubjectid)],
         LCA_label = pheno$LCA_label[match(studysubjectid, pheno$studysubjectid)]) %>%
  select(any_of(clin_vars))
write_csv(clin_db, file.path(out_dir, "clinical_database_183.csv"))
saveRDS(clin_db, file.path(out_dir, "clinical_database_183.rds"))
if (requireNamespace("haven", quietly = TRUE)) {
  try(haven::write_dta(clin_db, file.path(out_dir, "clinical_database_183.dta")), silent = TRUE)
}
cat(sprintf("[export] clinical_database_183: %d rows, %d cols\n", nrow(clin_db), ncol(clin_db)))

## ---- Original source data + IDAT sample sheet (provenance) ------------------
raw_dir <- file.path(out_dir, "original_data")
if (!dir.exists(raw_dir)) dir.create(raw_dir, recursive = TRUE)
for (f in c("clinical_data.RData", "data complementary.xls")) {
  src <- file.path(data_folder, f)
  if (file.exists(src)) file.copy(src, raw_dir, overwrite = TRUE)
}
# The sample sheet used to read the IDATs (David's "master file" for the epigenetic data).
ss <- list.files(MERGED_DATA_DIR, pattern = "SampleSheet\\.csv$", full.names = TRUE, recursive = TRUE)
if (length(ss)) file.copy(ss, raw_dir, overwrite = TRUE)
cat(sprintf("[export] original_data/ : %d files\n", length(list.files(raw_dir))))

## ---- Self-contained copy of the analysis code ------------------------------
code_dir <- file.path(out_dir, "code")
if (!dir.exists(code_dir)) dir.create(code_dir, recursive = TRUE)
for (d in c("scripts_R", "scripts_batch")) if (dir.exists(d)) file.copy(d, code_dir, recursive = TRUE)
cat("[export] code/ : scripts_R + scripts_batch copied\n")

## ---- Copy QC / cleaning reports --------------------------------------------
rep_dir <- file.path(out_dir, "cleaning_reports")
if (!dir.exists(rep_dir)) dir.create(rep_dir, recursive = TRUE)
qc_src <- QC_DIR  # results/01_quality_control
copied <- character(0)
if (dir.exists(qc_src)) {
  for (f in list.files(qc_src, pattern = "\\.(html|csv|txt|pdf)$", full.names = TRUE, recursive = FALSE)) {
    file.copy(f, rep_dir, overwrite = TRUE); copied <- c(copied, basename(f))
  }
}
for (t in c(file.path(COHORT_DIR, "Table1_GLOBAL_vs_QC-EPIGEN.html"),
            file.path(COHORT_DIR, "Table2_QC-EPIGEN_by_LCA.html"))) {
  if (file.exists(t)) { file.copy(t, rep_dir, overwrite = TRUE); copied <- c(copied, basename(t)) }
}
cat("[export] cleaning reports copied:", length(copied), "\n")

## ---- README ----------------------------------------------------------------
n_part <- nrow(B); n_probe <- ncol(B)
readme <- sprintf('# WASP sputum methylation — clean data package for the DataHub

Prepared by David Rebellón. Contact for the study data and ethics: Lucy Pembrey
(WASP coordinator, LSHTM). These are individual-level data governed by the WASP
consortium and shared on request with ethical approval; please treat them accordingly.

## What is in this folder

- `methylation_Bvalues_183xprobes.rds` / `.csv.gz` — B-values for %d participants x
  %d CpG probes. Rows are participants (studysubjectid), columns are CpG probes.
- `methylation_Mvalues_183xprobes.rds` / `.csv.gz` — the same matrix as M-values
  (M = log2(B / (1 - B))). Same rows and columns.
- `LCA_phenotype_183.csv` / `.dta` / `.rds` — the latent-class (LCA) phenotype for the
  same participants: studysubjectid, lca_class (1-6), LCA_label. See the note on the LCA
  assignment below.
- `LCA_class_assignment_full_1354.csv` — the same assignment for the full LCA cohort
  (1,354 participants); the anchor the whole pipeline reads.
- `ENVIRONMENT.txt` — R and package versions used, for exact reproduction.
- `cleaning_reports/` — the QC / normalization reports and the cohort tables.
- `LCA_posterior_probabilities_1354.csv` — per-participant posterior probability of each
  of the six classes (prob_C1..prob_C6) plus the modal class/label, full cohort.
- `clinical_database_183.csv` / `.dta` / `.rds` — the clinical/immunological database of
  the EWAS participants with their assigned LCA class.
- `original_data/` — a copy of the source clinical data and the IDAT sample sheet (the
  master file used to read the raw methylation arrays).
- `code/` — a self-contained copy of the analysis scripts (scripts_R + scripts_batch).

## The methylation array and the probes

The data come from the Illumina Infinium MethylationEPIC array, which measures DNA
methylation at roughly 865,000 CpG sites across the genome. The array uses two probe
chemistries: type I probes use two beads per CpG (one for the methylated and one for the
unmethylated state, in the same colour channel), and type II probes use a single bead
with two colour channels. The two designs have slightly different signal distributions,
which is one of the things the normalization step corrects for. You do not need to handle
the two probe types yourself: the matrices provided are already QC-ed and normalized.

## What the values mean

- B-value (beta): the proportion of methylation at a CpG, between 0 (unmethylated) and 1
  (fully methylated). Interpretable but heteroscedastic.
- M-value: log2(B / (1 - B)). Statistically better behaved (roughly homoscedastic) and is
  what we use for modelling; B-values are easier to interpret. We provide both.

## How the epigenetic data was obtained

The raw signal comes from Illumina MethylationEPIC IDAT files, one pair per sample. The
sample sheet (`original_data/`) maps each sample to its IDAT files and carries the sample
metadata; it is the master file used to read the arrays with the meffil package
(`meffil.read.samplesheet` / `meffil.create.samplesheet`). From there the pipeline runs
sample and probe QC, dye-bias and type I/II correction, and functional normalization, and
produces the normalized matrices delivered here. The clinical source data and this sample
sheet are included in `original_data/` so the chain from raw arrays to clean matrices is
fully traceable.

## How the data were cleaned (and how to reproduce them)

The cleaning pipeline is on GitHub: https://github.com/derebellon/WASP_sputum_EWAS
(runs on an HPC cluster). The relevant steps:

- Raw data + scripts reproduce everything. Raw input (IDAT signal / the pre-normalization
  object) plus the scripts regenerate these matrices exactly.
- Cleaning / normalization: `scripts_R/01_quality_control_normalization.R` runs the
  quality control and functional normalization with the meffil package (sample and probe
  QC, dye-bias and type I/II correction, normalization). Its report is in
  `cleaning_reports/`.
- Clinical data + LCA: `scripts_R/make_fresh_lca_assignment.R` fits the six-class latent
  class analysis on the full cohort and labels the classes by their clinical profile (see
  the note below); `scripts_R/03_data_harmonization.R` injects that assignment and
  harmonizes the clinical and methylation data. The whole analysis runs end to end with
  `scripts_batch/run_pipeline_fresh.sh` (steps 03 to 10).
- The methylation matrix delivered here is the normalized object restricted to the %d
  QC-passing EWAS participants.

## Note on the LCA phenotype assignment

Latent class analysis does not assign a participant to a class directly; it estimates, for
each participant, a posterior probability of belonging to each of the six latent classes,
and each participant is assigned to the most probable class (modal assignment). The model
is fitted by an EM algorithm (R function poLCA()) from random starts (nrep) after
stochastic imputation of missing covariates (R function mice()), both drawing from the R
random number generator. Two properties of poLCA matter for reproducibility: the class
numbering is arbitrary between runs (label switching), and because the likelihood is
multimodal a package update can move the fit to a genuinely different six-class solution
even with a fixed seed. To make the labels stable, the class labels here are NOT taken
from poLCA's class number: they are derived from each class's clinical profile (asthma,
atopy and severity of its own members) and matched to the six canonical phenotypes
(`scripts_R/make_fresh_lca_assignment.R`). So the label follows what the patients in a
class actually are, not the arbitrary numbering.

Crucially, I deposit the exact class assignment used in the analysis
(`LCA_phenotype_183.csv` and the full-cohort `LCA_class_assignment_full_1354.csv`). Every
downstream step (harmonization, EWAS, enrichment, sensitivity) reads this assignment, so
the whole analysis reproduces EXACTLY from these files plus the code, regardless of the
poLCA version on your machine. If you re-fit the LCA from scratch you may land on a
slightly different solution because of the multimodality above; that is expected, and it
is exactly why the assignment is provided as data rather than only as code. The recorded
software versions are in `ENVIRONMENT.txt`.

## Why R and not Stata

The methylation matrix has %d columns (one per CpG probe). Stata caps the number of
variables well below that (about 32,767 in standard Stata, up to 120,000 in Stata-MP), so
this matrix cannot be loaded in Stata. It is therefore delivered as an R object (.rds) and
as a gzip-compressed CSV that any language can read. The small LCA phenotype file has only
three columns and is provided in Stata (.dta) as well as R and CSV.
', n_part, n_probe, n_part, n_probe)
writeLines(readme, file.path(out_dir, "README.md"))

## ---- Manifest --------------------------------------------------------------
files <- list.files(out_dir, recursive = TRUE)
cat("\n[export] DONE. Package contents:\n"); print(files)
cat(sprintf("\n[export] %d participants x %d probes. Folder: %s\n", n_part, n_probe, out_dir))
