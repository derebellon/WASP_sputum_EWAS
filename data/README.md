# data/

Inputs for the analysis pipeline. Individual-level clinical and DNA methylation
data are governed by the WASP consortium and are not stored in this repository.

Expected objects (not committed), produced by the earlier pipeline steps:

- `beta_total_meffil.RData` -> `beta_total_meffil`: functional-normalised Beta
  matrix (CpGs in rows, samples in columns), from Step 1.
- `clinical_QC-EPIGEN_meffil.RData` -> `qc_epigen_df`: harmonised clinical table
  containing `Sample_Name`, `group`, the sputum inflammatory phenotype column
  `sputum_phenotype1_first`, `sex` and `age`. See
  `../config/clinical_columns_TEMPLATE.csv` for the relevant columns.
- The primary EWAS result CSVs from Step 4 (e.g. `EWAS_A11_...csv`), used for the
  inflammatory-vs-primary signature overlap.

To request access to the underlying data, see the Data availability section of the
top-level README.
