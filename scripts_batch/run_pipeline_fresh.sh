#!/bin/bash
# FRESH-mode pipeline for the WASP sputum EWAS.
#
# Runs the analysis on the FRESH, profile-based LCA assignment
# (scripts_R/make_fresh_lca_assignment.R) instead of the frozen Feb-2026
# manuscript assignment. This is the reproducible recipe for the new analysis:
#
#   1) sbatch scripts_batch/run_make_fresh_lca.sh          # writes the FRESH CSV
#      -> $DATA_DIR/LCA_class_assignment_FRESH_profile.csv
#   2) bash   scripts_batch/run_pipeline_fresh.sh          # this script
#
# Step 03 injects the fresh labels via the LCA_FROZEN_CSV env var (see
# scripts_R/03_data_harmonization.R). The EWAS contrasts are defined by the
# canonical C1..C6 labels, so they follow the fresh labelling automatically.
# Each step waits for the previous one with SLURM dependencies; per-step logs
# land in logs/NN_*_<jobid>.{out,err}.
#
# Run from the repository root.
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p logs

DATA_DIR="${DATA_DIR:-/home/lsh2301541/EPIC/data}"
FRESH_CSV="${LCA_FROZEN_CSV:-$DATA_DIR/LCA_class_assignment_FRESH_profile.csv}"
if [[ ! -f "$FRESH_CSV" ]]; then
  echo "ERROR: fresh LCA assignment not found: $FRESH_CSV" >&2
  echo "Run scripts_batch/run_make_fresh_lca.sh first." >&2
  exit 1
fi
echo "FRESH-mode: using LCA assignment -> $FRESH_CSV"

# Write into a PARALLEL output tree so the previous (frozen-based / manuscript)
# results/ and figures/ are never overwritten. Override RESULTS_ROOT/FIG_ROOT to
# rename the tree; both default to the *_fresh siblings.
RESULTS_ROOT="${RESULTS_ROOT:-results_fresh}"
FIG_ROOT="${FIG_ROOT:-figures_fresh}"
echo "FRESH-mode: outputs -> $RESULTS_ROOT/  and  $FIG_ROOT/  (previous results/ figures/ untouched)"

# Pass the fresh assignment + parallel output roots to every job.
EXP="ALL,LCA_FROZEN_CSV=$FRESH_CSV,RESULTS_ROOT=$RESULTS_ROOT,FIG_ROOT=$FIG_ROOT"

J03=$(sbatch  --parsable --export="$EXP"                        scripts_batch/run_03_harmonization.sh)
J04A=$(sbatch --parsable --export="$EXP" --dependency=afterok:$J03  scripts_batch/run_04a_ewas_array.sh)
J04B=$(sbatch --parsable --export="$EXP" --dependency=afterok:$J04A scripts_batch/run_04b_ewas_summary.sh)
J05=$(sbatch  --parsable --export="$EXP" --dependency=afterok:$J04B scripts_batch/run_05_figures.sh)
J06=$(sbatch  --parsable --export="$EXP" --dependency=afterok:$J04B scripts_batch/run_06_enrichment.sh)
J07=$(sbatch  --parsable --export="$EXP" --dependency=afterok:$J06  scripts_batch/run_07_enrichment_figures.sh)
J08=$(sbatch  --parsable --export="$EXP" --dependency=afterok:$J04B scripts_batch/run_08_sensitivity.sh)
J09=$(sbatch  --parsable --export="$EXP" --dependency=afterok:$J03  scripts_batch/run_09_supplementary_table.sh)
J10=$(sbatch  --parsable --export="$EXP" --dependency=afterok:$J08  scripts_batch/run_10_paper_figures.sh)

echo "Submitted FRESH-mode jobs (dependency order):"
echo "  03 harmon=$J03  04a EWAS=$J04A  04b summary=$J04B"
echo "  05 figures=$J05  06 enrichment=$J06  07 enrich-fig=$J07"
echo "  08 sensitivity=$J08  09 supp-table=$J09  10 paper-fig=$J10"
echo "Watch:  squeue -u \$USER"
echo "Logs:   logs/  (NN_*_<jobid>.out / .err)"
echo "Sanity after 03: grep -A8 'QC-EPIGEN class counts' logs/03_harmon_${J03}.out"
