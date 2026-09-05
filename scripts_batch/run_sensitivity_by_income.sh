#!/bin/bash
# Sensitivity: repeat the primary EWAS within INCOME strata (Lucy/Camila request).
#
# Reuses the FRESH per-contrast .RData already built by the fresh step 03 (they
# carry the fresh LCA labels + all participants + centre_name), subsetting by
# study centre inside 04a via EWAS_KEEP_CENTRES. Each stratum writes to its own
# results tree, so nothing already on disk is overwritten.
#
# Power caveat: each stratum is a subset of the 183 methylation participants, so
# do NOT read these as independent genome-wide discovery. Read them as whether the
# primary signature (mainly C1, severe atopic) is CONCORDANT across income settings
# or driven by a single group. The 04b summary gives hit counts + lambda per stratum.
#
# Bristol is not included (no methylation); the four EWAS centres are grouped by
# income as Lucy proposed: Brazil+Ecuador (middle), Uganda (low), New Zealand (high).
#
# Run from the repository root:  bash scripts_batch/run_sensitivity_by_income.sh
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p logs

submit_stratum () {
  local name="$1" centres="$2"
  # Export in the shell + --export=ALL so a comma inside EWAS_KEEP_CENTRES
  # (e.g. "Brazil,Ecuador") is preserved, instead of being read by sbatch as a
  # variable separator (which previously kept only the first centre).
  export RESULTS_ROOT="results_income_${name}" FIG_ROOT="figures_income_${name}"
  export EWAS_KEEP_CENTRES="${centres}" EWAS_DROP_CENTRES=""
  local J4A J4B
  J4A=$(sbatch --parsable --export=ALL                          scripts_batch/run_04a_ewas_array.sh)
  J4B=$(sbatch --parsable --export=ALL --dependency=afterany:$J4A scripts_batch/run_04b_ewas_summary.sh)
  echo "  ${name}: centres='${centres}' -> ${RESULTS_ROOT}/04_ewas/  (04a=$J4A 04b=$J4B)"
}

echo "Income-stratified sensitivity EWAS (fresh labels, subset inside 04a):"
submit_stratum "brazil_ecuador" "Brazil,Ecuador"
submit_stratum "uganda"         "Uganda"
submit_stratum "new_zealand"    "New Zealand"
echo
echo "Watch:    squeue -u \$USER"
echo "Summaries: results_income_*/04_ewas/EWAS_SUMMARY_A1_to_A14.csv"
