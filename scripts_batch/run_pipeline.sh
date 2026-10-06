#!/bin/bash
# Master pipeline for the WASP sputum EWAS.
# Submits every step in order with SLURM dependencies, so each starts only after
# the previous one finishes successfully. Per-step logs are written to logs/
# (one .out and one .err per job), so a failure is easy to locate.
#
# Run from the repository root:   bash scripts_batch/run_pipeline.sh
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"   # repository root
mkdir -p logs

J01=$(sbatch --parsable scripts_batch/run_01_quality_control.sh)
J02=$(sbatch --parsable --dependency=afterok:$J01 scripts_batch/run_02_clinical_lca.sh)
J03=$(sbatch --parsable --dependency=afterok:$J02 scripts_batch/run_03_harmonization.sh)
J04A=$(sbatch --parsable --dependency=afterok:$J03 scripts_batch/run_04a_ewas_array.sh)
J04B=$(sbatch --parsable --dependency=afterok:$J04A scripts_batch/run_04b_ewas_summary.sh)
J05=$(sbatch --parsable --dependency=afterok:$J04B scripts_batch/run_05_figures.sh)
J06=$(sbatch --parsable --dependency=afterok:$J04B scripts_batch/run_06_enrichment.sh)
J07=$(sbatch --parsable --dependency=afterok:$J06  scripts_batch/run_07_enrichment_figures.sh)
J08=$(sbatch --parsable --dependency=afterok:$J04B scripts_batch/run_08_sensitivity.sh)
J09=$(sbatch --parsable --dependency=afterok:$J03 scripts_batch/run_09_supplementary_table.sh)
J10=$(sbatch --parsable --dependency=afterok:$J08 scripts_batch/run_10_paper_figures.sh)

echo "Submitted jobs (in dependency order):"
echo "  01 QC=$J01  02 LCA=$J02  03 harmon=$J03  04a EWAS=$J04A  04b summary=$J04B"
echo "  05 figures=$J05  06 enrichment=$J06  07 enrich-fig=$J07  08 sensitivity=$J08"
echo "Watch:  squeue -u \$USER"
echo "Logs:   logs/  (each step writes NN_*_<jobid>.out and .err)"
