#!/bin/bash
# Sensitivity: leave-one-centre-out EWAS, to test whether the primary hits are
# driven by a single centre or are reproducible across all of them.
#
# Same mechanism as run_sensitivity_by_income.sh but dropping one centre at a time
# (EWAS_DROP_CENTRES), keeping ~140 participants per run so it stays adequately
# powered for the C1 signature. Compare each run's EWAS_SUMMARY to the full-183
# result (results_fresh/04_ewas): if the C1 (A9) hits survive every drop, the
# signature is not carried by one site.
#
# Run from the repository root:  bash scripts_batch/run_sensitivity_leave_one_centre.sh
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p logs

submit_drop () {
  local name="$1" centre="$2"
  # export + --export=ALL keeps any comma inside the centre value intact.
  export RESULTS_ROOT="results_drop_${name}" FIG_ROOT="figures_drop_${name}"
  export EWAS_DROP_CENTRES="${centre}" EWAS_KEEP_CENTRES=""
  local J4A J4B
  J4A=$(sbatch --parsable --export=ALL                          scripts_batch/run_04a_ewas_array.sh)
  J4B=$(sbatch --parsable --export=ALL --dependency=afterany:$J4A scripts_batch/run_04b_ewas_summary.sh)
  echo "  drop ${centre}: -> ${RESULTS_ROOT}/04_ewas/  (04a=$J4A 04b=$J4B)"
}

echo "Leave-one-centre-out sensitivity EWAS (fresh labels):"
submit_drop "brazil"      "Brazil"
submit_drop "ecuador"     "Ecuador"
submit_drop "uganda"      "Uganda"
submit_drop "new_zealand" "New Zealand"
echo
echo "Watch:    squeue -u \$USER"
echo "Summaries: results_drop_*/04_ewas/EWAS_SUMMARY_A1_to_A14.csv"
