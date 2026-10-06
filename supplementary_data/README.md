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

## Cross-study comparison (Table 3 of the paper)

We compared our signatures, at the level of the individual CpG (exact probe id),
with three published blood-based asthma methylation studies:

- **Reese et al. 2019** (J Allergy Clin Immunol; PACE consortium): 179 childhood-asthma CpGs (their Supplementary Table E5).
- **Xu et al. 2018 / MeDALL** (Lancet Respir Med): 35 asthma-associated CpGs (their Supplementary Tables S2–S8).
- **Perez-Garcia et al. 2026** (medRxiv preprint; Pino-Yanes group): 505 CpGs for asthma with severe exacerbations (their Supplementary Table S3).

**Result.** Only the severe atopic (C1) signature recovers previously reported
CpGs, and it does so for all three studies, all hypomethylated in the same
direction; the global (A1) and severe non-atopic (C2) signatures recover
essentially none.

| Signature | Reese (179) | MeDALL (35) | Perez-Garcia (505) |
|---|---|---|---|
| A1 global asthma | 0 | 0 | 2 |
| C1 severe atopic | 59 (p=4.4×10⁻¹⁰³) | 6 (p=8.4×10⁻¹⁰) | 8 (p=1.3×10⁻⁴) |
| C2 severe non-atopic | 0 | 0 | 0 |

### Files

| File | Contents |
|---|---|
| `cross_study_concordance.csv` | The summary table above (overlap counts + hypergeometric p per signature × study) |
| `overlap_C1_vs_Reese179_CpG_level.csv` | The 59 CpGs shared between C1 and Reese, with effect sizes and direction |
| `overlap_C1_vs_MeDALL_CpG_level.csv` | The 6 CpGs shared between C1 and MeDALL |
| `overlap_C1_vs_PinoYanes505_CpG_level.csv` | The 8 CpGs shared between C1 and Perez-Garcia/Pino-Yanes |
| `overlap_our_hits_vs_reese.csv` | Earlier gene-level overlap with Reese (superseded by the CpG-level files) |
| `compare_signatures_vs_reese.py` | Reproducible script: matches our DMPs against a published CpG list by exact probe id, with direction concordance and a hypergeometric enrichment test |

### To reproduce

Our input DMP lists are in this folder. The three studies' CpG lists are their
own copyrighted supplementary material and are **not** redistributed here;
download them from each journal (Reese Table E5, MeDALL Tables S2–S8,
Perez-Garcia Table S3), then run the matching for each, e.g.:

```
python compare_signatures_vs_reese.py \
  --hits-dir <results/04_ewas> \
  --reese <published_CpG_table> \
  --out overlap_C1_vs_<study>_CpG_level.csv
```

The overlap is by exact CpG (probe id); direction is the sign of the effect;
enrichment is a hypergeometric test against the 864,152 CpGs analysed.

## Notes

- Cross-study concordance is assessed at the CpG (probe) level.
- Published CpG tables are the respective authors' copyrighted supplementary material and are not redistributed here.
- Individual-level WASP data are governed by the WASP consortium and are not shared; these files are aggregate summary statistics only.

## Citation

Rebellón-Sánchez DE, et al. DNA Methylation Signatures of Asthma Phenotypes in
High, Middle and Low-Income Countries: A Multi-Centre Cross-Sectional Analysis
from the WASP Study. (WASP study group.)
