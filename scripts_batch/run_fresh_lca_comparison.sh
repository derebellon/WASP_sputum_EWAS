#!/bin/bash
###############################################################################
# run_fresh_lca_comparison.sh — run the pipeline in FRESH-LCA mode, in SEPARATE
# output folders, so it can be compared against the frozen-mode results already
# in results/04_ewas and results/05_enrichment.
#
# Chain: make_fresh_lca_assignment -> 03 -> 04a(array) -> 04b -> 06, all afterok.
# The fresh assignment CSV is passed via LCA_FROZEN_CSV; outputs go to *_fresh
# folders via the config's env-overridable dir variables, so the frozen results
# are NOT overwritten. Submit from a login node at the repo root:
#   bash scripts_batch/run_fresh_lca_comparison.sh
###############################################################################
set -euo pipefail
cd ~/EPIC/WASP_sputum_EWAS 2>/dev/null || cd "$(pwd)"

FRESH_CSV="${FRESH_LCA_CSV:-/home/lsh2301541/EPIC/data/LCA_class_assignment_FRESH_profile.csv}"
# Fresh-mode env: point every output dir at a *_fresh sibling, and read the fresh CSV.
FRESH_ENV="LCA_FROZEN_CSV=${FRESH_CSV},\
COHORT_DIR=results/03_cohort_tables_fresh,\
EWAS_TAB_DIR=results/04_ewas_fresh,EWAS_FIG_DIR=figures/04_ewas_fresh,\
ENRICH_TAB_DIR=results/05_enrichment_fresh,ENRICH_FIG_DIR=figures/05_enrichment_fresh"

# 1) Generate the fresh assignment CSV (writes FRESH_CSV).
J_MK=$(sbatch --parsable --export=ALL,FRESH_LCA_CSV=${FRESH_CSV} scripts_batch/run_make_fresh_lca.sh)
echo "make_fresh_lca = $J_MK"

# 2) 03 harmonization in fresh mode (rebuilds df_ from the fresh labels).
J03=$(sbatch --parsable --dependency=afterok:$J_MK --export=ALL,${FRESH_ENV} scripts_batch/run_03_harmonization.sh)
echo "03 (fresh) = $J03"

# 3) 04a array + 04b summary.
J04A=$(sbatch --parsable --dependency=afterok:$J03  --export=ALL,${FRESH_ENV} scripts_batch/run_04a_ewas_array.sh)
J04B=$(sbatch --parsable --dependency=afterok:$J04A --export=ALL,${FRESH_ENV} scripts_batch/run_04b_ewas_summary.sh)
echo "04a (fresh) = $J04A | 04b (fresh) = $J04B"

# 4) 06 enrichment.
J06=$(sbatch --parsable --dependency=afterok:$J04B --export=ALL,${FRESH_ENV} scripts_batch/run_06_enrichment.sh)
echo "06 (fresh) = $J06"

echo
echo "Fresh-mode chain submitted. Frozen results in results/04_ewas are untouched;"
echo "fresh results will appear in results/04_ewas_fresh and results/05_enrichment_fresh."
echo "When done, push so the comparison can be made:  git add -A && git commit && git push"
