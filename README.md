# DNA methylation signatures of asthma phenotypes across high-, middle- and low-income countries: analysis code for the WASP sputum EWAS

**Author and analyst:** David Esteban Rebellon-Sanchez
**Study:** World Asthma Phenotypes Study (WASP)
**Ethics:** London School of Hygiene and Tropical Medicine (LSHTM approval reference 31403)

This repository holds the analysis code for our study of sputum DNA methylation and
data-driven asthma phenotypes in the WASP study. It is intended to be read
alongside the manuscript: the scripts reproduce the epigenome-wide association
analyses, the pathway enrichment, and the phenotype-overlap analyses, and the
repository documents how the pipeline is organised so that the analysis is
transparent and reproducible on an HPC cluster.

The individual-level data are not deposited publicly; they can be requested under
the conditions described in [Data availability](#data-availability).

---

## Study overview

WASP is an international, cross-sectional collaboration studying clinical and
inflammatory asthma phenotypes in children, adolescents and young adults recruited
between 2016 and 2020 across five centres: Bristol (United Kingdom),
Wellington (New Zealand), Salvador (Brazil), Esmeraldas (Ecuador) and
Entebbe (Uganda). Recruitment, questionnaires, clinical assessment and laboratory
work followed harmonised protocols. The published WASP protocol contains the full
account of design, recruitment and measurement and should be consulted for those
details (see [References](#references)).

The analysis has two stages:

1. **Clinical phenotyping (whole study population, N = 1,354).** Latent class analysis (LCA)
   on harmonised clinical and immunological variables (asthma status, atopy by skin
   prick test and IgE, asthma control by ACQ, and severity by ISAAC and 12-month
   attack count). Sex and study centre are deliberately excluded from the model so
   that classes reflect disease expression rather than demographics or geography.
   Methylation is not an input, keeping the classes independent of the EWAS. Model
   selection uses BIC and AIC together with clinical interpretability, and is
   checked for stability by refitting across many random starts. The retained
   solution has six classes (C1 to C6).

2. **Sputum EWAS (subset, n = 183).** DNA methylation in induced sputum, measured on
   the Illumina Infinium MethylationEPIC BeadChip (over 850,000 CpG sites), is
   tested against the LCA-derived phenotypes across 14 pre-specified contrasts, and
   in a complementary analysis against the classical sputum inflammatory phenotypes.
   The sample selected for methylation was purposively stratified across
   inflammatory phenotypes to give adequate power for the contrasts.

---

## Sample and laboratory methods (sputum)

Summarised here for readers re-analysing the data. For anything not covered, the
published WASP protocol is the reference.

- **Specimen.** Induced sputum, sampling the lower-airway luminal compartment
  (neutrophils, eosinophils, macrophages, lymphocytes and desquamated epithelial
  cells) in proportions that reflect the airway inflammatory milieu. Sputum was
  chosen over blood or nasal brushings for its proximity to the target tissue.
- **Sputum induction and processing.** Sputum was induced and processed under the
  standardised WASP protocol, with differential cell counts and aliquoting for DNA
  extraction. Viscid mucus plugs were isolated to reduce salivary contamination, and
  samples with excessive squamous-cell contamination or with low viability or yield
  were excluded a priori.
- **Inflammatory phenotypes.** From the sputum differential cell count each sample
  was classified as eosinophilic, neutrophilic, mixed-granulocytic or
  paucigranulocytic.
- **Methylation platform.** Illumina Infinium MethylationEPIC BeadChip. Methylation
  at each CpG is expressed as a Beta value (0 = unmethylated, 1 = fully methylated).
- **Processing and QC (R, meffil).** Raw IDAT files were processed with the *meffil*
  package. QC covered sex concordance, probe detection p-values, bead counts and
  control-probe performance; probes failing QC were removed. Functional
  normalisation with 12 principal components corrected dye bias and background.
  Surrogate Variable Analysis estimated contrast-specific surrogate variables for
  unmeasured technical variation, with the number chosen de novo per contrast.

---

## Analytical methods

### Primary EWAS (LCA phenotypes)

Probe-wise linear regression (meffil), adjusted for age, sex, estimated sputum cell
fractions (neutrophils, eosinophils, lymphocytes, monocytes/macrophages and
squamous cells) and contrast-specific surrogate variables. The 14 contrasts are
grouped into four domains: asthma signatures, atopy signatures, severity/control
signatures, and one-versus-rest phenotype signatures (each class C1 to C6 against
the pool of the rest). A CpG is a differentially methylated position (a Hit) when it
meets both **FDR < 0.05** and an absolute methylation difference **|Delta beta| > 0.01**.

### Complementary EWAS by inflammatory phenotype

Each of the four sputum inflammatory phenotypes is tested one-versus-rest. Because
these phenotypes are defined directly by the sputum differential cell count,
adjusting for estimated cell fractions would be partly circular and would remove the
biology under study; these models are therefore run **without cell-fraction
adjustment**, keeping age, sex and contrast-specific surrogate variables. The
analysis is hypothesis-generating: CpGs shared between this inflammation-anchored
EWAS and the primary phenotype EWAS may flag airway-proximal loci of
pathophysiological rather than purely compositional interest. This analysis, its
enrichment and the overlap figures are reported as Supplementary Material.

### Pathway enrichment

KEGG and GO enrichment with `missMethyl::gometh`, which corrects for the
probe-number bias of the EPIC array. Enrichment uses an adaptive selection of the
input CpGs (successively relaxing the effect-size threshold until a sufficient set
is available) and reports pathways passing a false-discovery threshold, prioritised
by FDR and enrichment percentage.

### Phenotype overlap

The complementary analysis quantifies how much of each inflammatory-phenotype
signature is shared with the other inflammatory phenotypes and with the primary LCA
phenotype signatures (CpG counts, percentages and Jaccard indices), and produces a
total overlap figure, a per-phenotype figure, a four-set Venn and a shared-count
heatmap.

---

## Repository structure

```
WASP_sputum_EWAS/
├── README.md
├── scripts_R/        R analysis scripts, numbered in run order (00_config.R holds all paths).
├── scripts_batch/    SLURM submission scripts, one per step (+ run_pipeline.sh).
├── config/           Templates for the input tables (synthetic values, no data).
├── data/             Inputs. Not committed. See Data availability.
├── results/          Analysis outputs (tables, reports), organised by phase. Published with the repo.
├── figures/          Generated figures, organised by phase. Published with the repo.
└── paper_final/      Hand-picked figures and tables for the manuscript (main / supplementary).
```

The whole pipeline runs on an HPC cluster (SLURM). All input and output paths live
in one place, `scripts_R/00_config.R`, which every step sources, so each step reads
exactly what the previous one wrote. Inputs default to the cluster data locations
(`/…/EPIC/data`, `/…/EPIC/merged_data`) and can be overridden with environment
variables. Outputs are written inside the repository, organised by phase:

```
results/                              figures/
  01_quality_control/  QC reports       02_lca/                 LCA model selection, heatmap
  02_clinical_lca/     LCA tables        04_ewas/                per-contrast volcano/Manhattan/QQ + montages
  03_cohort_tables/    Table 1/2         05_enrichment/          enrichment plots
  04_ewas/             EWAS results      06_sensitivity_inflammatory/  inflammatory volcanoes, Venn, heatmap
  05_enrichment/       KEGG/GO tables
  06_sensitivity_inflammatory/  inflammatory EWAS + overlap tables
```

`paper_final/main/` and `paper_final/supplementary/` are filled in by hand with the
chosen final outputs (all inflammatory-phenotype analyses are supplementary).

Run every step from the repository root with `scripts_batch/run_pipeline.sh`, which
submits the steps in order using SLURM dependencies and writes one log per step to
`logs/`.

### Pipeline

| Step | Script | Purpose |
|------|--------|---------|
| 01 | `01_quality_control_normalization.R` | meffil QC and functional normalisation of the EPIC IDATs; produces the Beta matrix. |
| 02 | `02_clinical_phenotype_lca.R` | Latent class analysis on clinical/immunological variables; defines classes C1 to C6. Includes a multi-seed stability check of the class-number selection. |
| 03 | `03_data_harmonization.R` | Builds the per-contrast analysis datasets used by the EWAS. |
| 04a | `04a_ewas_contrasts.R` | Runs one of the 14 contrasts per array task (probe-wise EWAS; volcano, Manhattan and QQ plots). |
| 04b | `04b_ewas_summary.R` | Consolidates the array results and the per-domain union summaries. |
| 05 | `05_figures_montage.R` | Composes the per-contrast figures into publication montages. |
| 06 | `06_enrichment_kegg_go.R` | KEGG and GO enrichment (missMethyl gometh), one contrast per array task. |
| 07 | `07_enrichment_figures.R` | Enrichment figures and tables. |
| 08 | `08_sensitivity_inflammatory_phenotypes.R` | Complementary sensitivity analysis: one-vs-rest EWAS by sputum inflammatory phenotype (no cell adjustment), KEGG/GO enrichment, and cross-signature overlap with the primary phenotype EWAS. |
| 09 | `09_supplementary_centre_table.R` | Supplementary tables: LCA and sputum inflammatory phenotype distribution by centre and by income setting (HIC vs LMIC), with chi-square heterogeneity tests. |

Contrasts are numbered A1 to A14, matching the manuscript. The mapping to the latent
classes is: A1 asthma vs controls; A2 atopic asthma vs atopic controls; A3
non-atopic asthma vs non-atopic controls; A4 atopy among controls; A5 atopy within
asthma; A6 atopy overall; A7 severity independent of atopy; A8 severe vs mild atopic
asthma; A9 to A14 the one-versus-rest signatures of classes C1 to C6 respectively.

Figure titles use the biological comparison; `04a_ewas_contrasts.R` and
`07_enrichment_figures.R` carry a `PUBLICATION_TITLES` block near the top that sets
those titles in one place.

---

## How to run

On the cluster, from the repository root, run the whole pipeline in order:

```
cd WASP_sputum_EWAS
bash scripts_batch/run_pipeline.sh
```

This submits every step with SLURM dependencies (each starts after the previous one
succeeds) and writes one `.out` and one `.err` per step to `logs/`. Watch progress
with `squeue -u $USER`. To run a single step instead, submit its script from the
repository root, e.g. `sbatch scripts_batch/run_03_harmonization.sh`.

Steps must run in order because later steps read the outputs of earlier ones. The QC
(01) and LCA (02) steps are the heavy ones; the LCA stability check in step 02 refits
the model across 200 random starts by default (adjust with `LCA_N_SEEDS` and
`LCA_NREP`).

### Software

R (>= 4.3) with `meffil` (QC, normalisation and the EWAS engine), `poLCA` and `mice`
(latent class analysis and imputation), `missMethyl` and
`IlluminaHumanMethylationEPICanno.ilm10b4.hg19` (enrichment), and `dplyr`, `tidyr`,
`stringr`, `purrr`, `tibble`, `readr`, `ggplot2`, `ggrepel`, `ggVennDiagram`,
`scales` and `gt` for figures and tables. Bioconductor packages are installed with
`BiocManager::install()`.

---

## Data availability

The individual-level clinical and DNA methylation data are governed by the WASP
consortium and are not open. They can be shared with projects that have appropriate
ethical approval, once the intended use and analysis plan have been specified. To
request access, and for the full account of recruitment, sampling and data-collection
methods, contact the WASP study coordinator, **Lucy Pembrey** (LSHTM;
`Lucy.Pembrey@lshtm.ac.uk`), and consult the published WASP protocol.

This repository contains code and documentation only. No individual-level data,
Beta matrices or IDAT files are included; the templates under `config/` describe the
expected input formats using synthetic values.

---

## References

- Pembrey L, et al. Understanding asthma phenotypes: the World Asthma Phenotypes
  (WASP) international collaboration. *ERJ Open Research* 2018;4(3):00013-2018.
- Pembrey L, et al. Asthma inflammatory phenotypes on four continents: most asthma
  is non-eosinophilic. *International Journal of Epidemiology* 2023.
- Methodological references for the pipeline (meffil, poLCA, missMethyl/gometh) are
  cited in the manuscript.

---

## Citation

If you use this code, please cite the accompanying manuscript (details to be added on
publication) and this repository. Analysis by David Esteban Rebellon-Sanchez on
behalf of the WASP study team.
