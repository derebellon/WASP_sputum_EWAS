# LAST RUN DATE: 06 Oct 2025

# Remove all objects in the session
rm(list = ls())                                                        # Clean workspace to avoid stale objects

# Load required libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(GenomicRanges)
  library(openxlsx)  # Library to export Excel files
  library(dplyr)
  library(meffil)
})

# Verify that no objects remain in the session
print(ls())                                                            # Should be character(0)

# Set timeout
options(timeout = 10000)                                               # Allow longer I/O

### Configure paths
source("scripts_R/00_config.R")
dataDirectory   <- MERGED_DATA_DIR
outputDirectory <- DATA_DIR
reportDirectory <- QC_DIR
if (!dir.exists(reportDirectory)) dir.create(reportDirectory, recursive = TRUE)
options(mc.cores = 20)

# List files in the data directory
print(head(list.files(dataDirectory, recursive = TRUE), 6))            # Quick sanity check

# Session parameters
qc.file  <- file.path(reportDirectory, "Report 1. QC-report_2025.html")
author   <- "David E. Rebellon Sanchez"
study    <- "World Asthma Phenotype Study"
number.pcs <- 12                                                       # For normalization
norm.file <- file.path(reportDirectory, "Report 2. Normalization-report.html")
cell.type.reference <- "saliva gse48472"

## ===== Flags =====
# FIRST RUN with 191: keep as (FALSE/TRUE/TRUE/TRUE)
# FUTURE RUNS (load only): TRUE / FALSE / FALSE / FALSE
use_cached_qc           <- FALSE   # FALSE: recalculate QC (191); TRUE: load saved qc.objects/qc.summary
recompute_normalization <- TRUE    # TRUE: redo normalization and beta; FALSE: load beta/norm.dataset/pcs
rebuild_reports         <- TRUE    # TRUE: regenerate HTML reports/figures if present
force_overwrite_outputs <- TRUE    # TRUE: overwrite outputs even if they exist

# Cache/output paths for checks
qc_obj_path     <- file.path(outputDirectory, "qc.objectsOct2025.Robj")
qc_summary_path <- file.path(outputDirectory, "qc.summaryOct2025.Robj")
beta_path         <- file.path(outputDirectory, "norm.betaOct2025.RData")
norm_dataset_path <- file.path(outputDirectory, "norm.datasetOct2025.RData")
pcs_path          <- file.path(outputDirectory, "pcsOct2025.RData")

# Read the sample sheet (metadata CSV)
samplesheet <- meffil.read.samplesheet(dataDirectory, pattern = "SampleSheet.csv")

# Create and combine the sample sheet (to detect IDATs)
samplesheet2 <- meffil.create.samplesheet(dataDirectory, recursive = TRUE)

# Keep minimal necessary columns from IDATs
samplesheet2$Slide    <- format(samplesheet2$Slide, scientific = FALSE, trim = TRUE)
samplesheet2$Basename <- as.character(samplesheet2$Basename)
samplesheet2 <- samplesheet2[, c("Sample_Name", "Slide", "Basename", "sentrix_row", "sentrix_col")]

# Merge keeping metadata and enforcing correct IDAT paths
combined_samplesheet <- merge(samplesheet, samplesheet2, by = "Sample_Name",
                              all.x = TRUE, suffixes = c("", ".idat"))

# Overwrite critical columns with those from IDATs
combined_samplesheet$Slide    <- combined_samplesheet$Slide.idat
combined_samplesheet$Basename <- combined_samplesheet$Basename.idat
combined_samplesheet$Slide.idat <- combined_samplesheet$Basename.idat <- NULL

# ================================
# [CHANGE A] Restrict to 191 from the start (exclude 9 by Study_id)
# ================================
exclude9_study_ids <- c(
  "WASP39", # BR3990",  # WASP39   - No cell counts/phenotype
  "WASP137", # "MB1079",  # WASP137  - No cell counts/phenotype
  "WASP148", # "MB1147",  # WASP148  - Duplicate visit 2 + no counts
  "WASP149", #"MB1372",  # WASP149  - Duplicate visit 2 + no counts
  "WASP145", #"MB1436",  # WASP145  - Duplicate visit 2 + no counts
  "WASP155", #"MB1852",  # WASP155  - No cell counts/phenotype
  "WASP146", #"MB2080",  # WASP146  - Duplicate visit 2 + no counts
  "WASP156", #"NG836",   # WASP156  - Duplicate visit 2
  "WASP98" #"MB1812"   # WASP98   - No cell counts/phenotype
)

# Filter by Study_id if present; otherwise warn
if ("Study_id" %in% names(samplesheet)) {
  samplesheet <- samplesheet %>% dplyr::filter(!Study_id %in% exclude9_study_ids)
} else {
  warning("Column 'Study_id' not found in samplesheet; could not filter there.")
}

if ("Study_id" %in% names(combined_samplesheet)) {
  combined_samplesheet <- combined_samplesheet %>% dplyr::filter(!Study_id %in% exclude9_study_ids)
} else {
  warning("Column 'Study_id' not found in combined_samplesheet; could not filter there.")
}

cat("[CHECK] Expected N ~191 after study exclusions. Current N =", nrow(combined_samplesheet), "\n")

# Quick check: both IDATs must exist (already filtered to 191)
ok <- file.exists(paste0(combined_samplesheet$Basename, "_Grn.idat")) &
  file.exists(paste0(combined_samplesheet$Basename, "_Red.idat"))
if (!all(ok)) {
  miss <- combined_samplesheet$Sample_Name[!ok]
  stop("Missing IDATs for: ", paste(head(miss, 20), collapse = ", "),
       ifelse(length(miss) > 20, " ...", ""))
}

# Use the combined sample sheet (filtered to 191) for meffil
samplesheet <- combined_samplesheet
print(head(samplesheet))

# Save the list of 191 before QC (traceability for Script 3)
saveRDS(samplesheet %>% dplyr::select(Sample_Name, dplyr::any_of(c("Study_id","studysubjectid"))),
        file = file.path(outputDirectory, "epigen_191_samples_preQC.rds"))

# Free memory
rm(samplesheet2, combined_samplesheet)

# Verify combined sample sheet structure
print(head(samplesheet[, c("Sample_Name","Slide","Basename","sentrix_row","sentrix_col")]))

# List available cell-type references (informational)
print(meffil.list.cell.type.references())

# ================================
# [CHANGE B] QC: use cache or recompute over the 191
# ================================
need_qc <- !use_cached_qc || !file.exists(qc_obj_path) || !file.exists(qc_summary_path)

if (need_qc) {
  message("[QC] Recomputing QC over the 191 samples…")
  qc.objects <- meffil.qc(samplesheet, cell.type.reference = cell.type.reference, verbose = TRUE)
  qc.summary <- meffil.qc.summary(qc.objects, verbose = TRUE)
  save(qc.objects, file = qc_obj_path)
  save(qc.summary, file = qc_summary_path)
} else {
  message("[QC] Loading QC from cache…")
  load(qc_obj_path)     # -> qc.objects
  load(qc_summary_path) # -> qc.summary
}

# QC report (HTML) only if requested or missing
if (rebuild_reports || !file.exists(qc.file) || force_overwrite_outputs) {
  meffil.qc.report(qc.summary, output.file = qc.file, author = author, study = study)
  message("[QC] HTML report regenerated: ", qc.file)
} else {
  message("[QC] Skipping HTML report (set rebuild_reports=TRUE to regenerate).")
}

# ================================
# Save info of poor-quality samples (if any)
# ================================
bad_samples_df <- qc.summary$bad.samples
if (is.null(bad_samples_df) || nrow(bad_samples_df) == 0) {
  bad_sample_names <- character(0)
  message("[QC] No poor-quality samples detected in qc.summary$bad.samples.")
  # Still create an empty Excel file with useful headers
  bad_sample_info <- tibble(
    sample.name = character(0),
    Study_id = character(0),
    studysubjectid = character(0),
    issue = character(0)
  )
} else {
  bad_sample_names <- bad_samples_df$sample.name
  # Link metadata for Study_id / studysubjectid if present
  join_cols <- colnames(samplesheet)
  add_cols  <- intersect(c("Study_id","studysubjectid"), join_cols)
  bad_sample_info <- bad_samples_df %>%
    left_join(samplesheet %>% dplyr::select(c("Sample_Name", add_cols)), by = c("sample.name" = "Sample_Name")) %>%
    dplyr::select(c("sample.name", add_cols, "issue"))
}

# Save bad sample list
write.xlsx(bad_sample_info, file = file.path(reportDirectory, "bad_samples_with_study_id_Oct2025.xlsx"))
print(bad_sample_names)
if ("studysubjectid" %in% names(bad_sample_info)) print(bad_sample_info$studysubjectid)

# Remove poor-quality samples from QC object (if any)
if (length(bad_sample_names) > 0) {
  qc.objects <- meffil.remove.samples(qc.objects, bad_sample_names)
}

# ================================
# [CHANGE C] Save vector of samples that PASSED QC (~179)
# ================================
samples_qc_kept <- names(qc.objects)  # vector of Sample_Name retained after QC
meta_preQC <- readRDS(file.path(outputDirectory, "epigen_191_samples_preQC.rds"))
qc_pass_df <- meta_preQC %>% dplyr::filter(Sample_Name %in% samples_qc_kept)

save(samples_qc_kept, qc_pass_df, file = file.path(outputDirectory, "epigen_qc_passed_ids.RData"))
cat("[✓] Saved 'samples_qc_kept' and 'qc_pass_df' (≈179) for use in Script 3.\n")

# Quick checks
cat("N samples after QC:", length(qc.objects), "\n")
if (length(qc.objects) > 0) {
  print(names(qc.objects)[1:min(5, length(qc.objects))])
  print(names(qc.objects[[1]]))
  print(qc.objects[[1]]$sample.name)
}

# ================================
# Normalization: recompute or load from cache
# ================================
need_norm <- recompute_normalization ||
  !file.exists(beta_path) || !file.exists(norm_dataset_path) || !file.exists(pcs_path)

if (need_norm) {
  message("[NORMALIZATION] Performing quantile normalization and exporting beta...")
  # Plot PCs (only if requested reports / helps choose number.pcs)
  if (rebuild_reports || force_overwrite_outputs) {
    pc_plot <- meffil.plot.pc.fit(qc.objects)$plot
    ggsave(filename = file.path(reportDirectory, "pc_fit_plot_Oct2025.png"),
           plot = pc_plot, width = 8, height = 6, dpi = 300)
  }
  
  norm.objects <- meffil.normalize.quantiles(qc.objects, number.pcs = number.pcs, verbose = TRUE)
  norm.dataset <- meffil.normalize.samples(norm.objects, just.beta = FALSE,
                                           cpglist.remove = qc.summary$bad.cpgs$name, verbose = TRUE)
  
  beta <- meffil.get.beta(norm.dataset$M, norm.dataset$U)
  pcs  <- meffil.methylation.pcs(beta, verbose = TRUE)
  
  save(beta,         file = beta_path)
  save(norm.dataset, file = norm_dataset_path)
  save(pcs,          file = pcs_path)
  
  # Normalization report (optional)
  if (rebuild_reports || force_overwrite_outputs || !file.exists(norm.file)) {
    parameters <- meffil.normalization.parameters(norm.objects)
    parameters$batch.threshold <- 0.01
    norm.summary <- meffil.normalization.summary(norm.objects = norm.objects, pcs = pcs,
                                                 parameters = parameters, verbose = TRUE)
    meffil.normalization.report(norm.summary, output.file = norm.file, author = author, study = study)
    message("[NORMALIZATION] HTML report generated: ", norm.file)
  } else {
    message("[NORMALIZATION] Skipping report (set rebuild_reports=TRUE to regenerate).")
  }
  
} else {
  message("[NORMALIZATION] Loading beta, norm.dataset and pcs from cache…")
  load(beta_path)         # -> beta
  load(norm_dataset_path) # -> norm.dataset
  load(pcs_path)          # -> pcs
}

# Final message
print("Normalization completed / loaded and data saved successfully.")
