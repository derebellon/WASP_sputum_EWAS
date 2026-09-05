# WASP sputum EWAS — differentially methylated position (DMP) lists and cross-study comparison

Open data and code from the World Asthma Phenotypes Study (WASP) sputum
epigenome-wide association study (Illumina EPIC, n = 183; models adjusted for
age, sex, sputum cell fractions and comparison-specific surrogate variables).
Significance threshold for the listed DMPs: FDR < 0.05 and |Δβ| > 0.01.

Released so that others can reuse our results and run their own cross-study
comparisons / meta-analyses.

## Our DMP lists

| File | Comparison | DMPs |
|---|---|---|
| `WASP_A1_asthma_vs_nonasthmatic_DMPs.csv` | Global asthma vs non-asthmatic (A1) | 23,378 |
| `WASP_C1_severe_atopic_vs_rest_DMPs.csv` | Severe atopic (C1) vs rest | 2,479 |
| `WASP_C2_severe_nonatopic_vs_rest_DMPs.csv` | Severe non-atopic (C2) vs rest | 33 |
| `WASP_C1_KEGG_pathways.csv` / `WASP_C1_GO_terms.csv` | C1 enrichment | — |
| `WASP_C2_KEGG_pathways.csv` / `WASP_C2_GO_terms.csv` | C2 enrichment | — |

### Column dictionary (DMP files)

- `probeID`: Illumina EPIC CpG identifier (e.g. cg01635668)
- `gene`: annotated gene symbol (UCSC), blank if intergenic
- `chromosome`, `position`: genome coordinate (hg19/GRCh37)
- `beta_delta`: effect size (Δβ, methylation difference)
- `p_value`: nominal p-value
- `FDR`: Benjamini-Hochberg false discovery rate
- `comparison`: which contrast the row belongs to

## Cross-study comparison (WASP vs Reese et al.)

We compared our signatures, at the level of the individual CpG, with the 179
childhood-asthma CpGs reported by Reese et al. (PACE consortium, J Allergy Clin
Immunol 2019; their Supplementary Table E5).

| File | Contents |
|---|---|
| `compare_signatures_vs_reese.py` | Reproducible script: matches our DMPs against Reese's CpGs by exact probe id, with direction concordance and a hypergeometric enrichment test |
| `overlap_C1_vs_Reese179_CpG_level.csv` | The 59 CpGs shared between our C1 (severe atopic) signature and Reese's 179, with effect sizes and direction |

**Result.** The severe atopic (C1) signature shared **59 of Reese's 179 CpGs**
at the exact same probe, all hypomethylated in the same direction
(hypergeometric p ≈ 4.4 × 10⁻¹⁰³). The global asthma (A1) and severe non-atopic
(C2) signatures shared none, and A1 and C1 were themselves largely distinct sets.

**To reproduce:** download Reese et al.'s Supplementary Table E5 from the journal
(not redistributed here for copyright reasons) and run:

```
python compare_signatures_vs_reese.py \
  --hits-dir <results_fresh/04_ewas> \
  --reese <reese_TableE5.docx> \
  --out overlap_C1_vs_Reese179_CpG_level.csv
```

## Notes

- Matching is by exact CpG (probe id); direction is the sign of the effect.
- Reese et al.'s CpG table is their copyrighted supplementary material and is
  **not** redistributed here — supply it yourself via `--reese`.
- Individual-level WASP data are governed by the WASP consortium and are not
  shared here; these files are aggregate summary statistics only.

## Citation

Rebellón-Sánchez DE, et al. DNA Methylation Signatures of Asthma Phenotypes in
High, Middle and Low-Income Countries: A Multi-Centre Analysis from the WASP
Study. (WASP study group.)
