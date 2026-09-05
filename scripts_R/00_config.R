## =============================================================================
## Central path configuration for the WASP sputum EWAS pipeline.
##
## Sourced by every step (after its library block). It is the single source of
## truth for where inputs are read and where outputs are written, so that each
## step reads exactly what the previous step wrote.
##
## Inputs (raw and intermediate data objects) default to the cluster data
## locations and can be overridden with environment variables. Outputs are
## organised INSIDE the repository, by phase: results/ holds tables and reports,
## figures/ holds images. Run the scripts from the repository root so these
## relative paths resolve.
## =============================================================================

.cfg_env <- function(key, default) {
  v <- Sys.getenv(key, unset = NA); if (is.na(v) || v == "") default else v
}

## ---- Inputs (not published; kept where the data live) ----------------------
MERGED_DATA_DIR <- .cfg_env("MERGED_DATA_DIR", "/home/lsh2301541/EPIC/merged_data") # IDATs + sample sheet (step 01)
DATA_DIR        <- .cfg_env("DATA_DIR",        "/home/lsh2301541/EPIC/data")        # .RData objects (raw + intermediate)

## ---- Outputs, organised by phase (inside the repo) -------------------------
## results/ = numbers (CSV, tables, reports) ; figures/ = images (PNG)
## RESULTS_ROOT / FIG_ROOT let a whole run land in a PARALLEL tree without
## overwriting a previous analysis: e.g. RESULTS_ROOT=results_fresh
## FIG_ROOT=figures_fresh keeps the frozen-based results/ + figures/ untouched.
RESULTS_ROOT    <- .cfg_env("RESULTS_ROOT",    "results")
FIG_ROOT        <- .cfg_env("FIG_ROOT",        "figures")

QC_DIR          <- .cfg_env("QC_DIR",          file.path(RESULTS_ROOT, "01_quality_control"))
LCA_TAB_DIR     <- .cfg_env("LCA_TAB_DIR",     file.path(RESULTS_ROOT, "02_clinical_lca"))
LCA_FIG_DIR     <- .cfg_env("LCA_FIG_DIR",     file.path(FIG_ROOT,     "02_lca"))
COHORT_DIR      <- .cfg_env("COHORT_DIR",      file.path(RESULTS_ROOT, "03_cohort_tables"))
EWAS_TAB_DIR    <- .cfg_env("EWAS_TAB_DIR",    file.path(RESULTS_ROOT, "04_ewas"))
EWAS_FIG_DIR    <- .cfg_env("EWAS_FIG_DIR",    file.path(FIG_ROOT,     "04_ewas"))
ENRICH_TAB_DIR  <- .cfg_env("ENRICH_TAB_DIR",  file.path(RESULTS_ROOT, "05_enrichment"))
ENRICH_FIG_DIR  <- .cfg_env("ENRICH_FIG_DIR",  file.path(FIG_ROOT,     "05_enrichment"))
SENS_TAB_DIR    <- .cfg_env("SENS_TAB_DIR",    file.path(RESULTS_ROOT, "06_sensitivity_inflammatory"))
SENS_FIG_DIR    <- .cfg_env("SENS_FIG_DIR",    file.path(FIG_ROOT,     "06_sensitivity_inflammatory"))
OVERLAP_TAB_DIR <- .cfg_env("OVERLAP_TAB_DIR", file.path(SENS_TAB_DIR, "overlap"))

## Create every output directory up front so no step fails on a missing folder.
for (.d in c(QC_DIR, LCA_TAB_DIR, LCA_FIG_DIR, COHORT_DIR, EWAS_TAB_DIR, EWAS_FIG_DIR,
             ENRICH_TAB_DIR, ENRICH_FIG_DIR, SENS_TAB_DIR, SENS_FIG_DIR, OVERLAP_TAB_DIR)) {
  if (!dir.exists(.d)) dir.create(.d, recursive = TRUE, showWarnings = FALSE)
}
rm(.d)
