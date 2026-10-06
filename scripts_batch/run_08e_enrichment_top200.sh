#!/bin/bash
#SBATCH --job-name=wasp_08e_top200
#SBATCH --output=logs/08e_top200_%j.out
#SBATCH --error=logs/08e_top200_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
###############################################################################
# Re-run ONLY the inflammatory-phenotype enrichment with the SAME top-200 method
# used for the LCA phenotypes (script 06), for consistency. Reads the EXISTING
# sensitivity toptables (results/06_sensitivity_inflammatory/EWAS_SENSITIVITY_*.csv)
# written by a previous Script 08 run - it does NOT recompute the EWAS. Writes
# KEGG + GO top-200 tables to results/06_sensitivity_inflammatory/enrichment_top200/.
###############################################################################
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
export RESULTS_ROOT="${RESULTS_ROOT:-results}"
echo "[08e] RESULTS_ROOT=$RESULTS_ROOT  (reads existing toptables, no EWAS recompute)"
Rscript "scripts_R/08e_enrichment_inflammatory_top200.R"
