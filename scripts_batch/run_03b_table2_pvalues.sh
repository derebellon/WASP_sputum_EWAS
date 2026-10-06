#!/bin/bash
#SBATCH --job-name=wasp_03b_table2p
#SBATCH --output=logs/03b_table2p_%j.out
#SBATCH --error=logs/03b_table2p_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=00:30:00
###############################################################################
# Re-build ONLY Table 2 (QC-EPIGEN by LCA phenotype) adding the between-phenotype
# p-value column (reviewer request, Paul). Loads the already-saved harmonised
# cohort object (clinical_QC-EPIGEN_meffil.RData); does NOT reload the methylation
# matrix and does NOT rebuild the A1-A14 EWAS datasets. Requires Script 03 to have
# been run once before.
###############################################################################
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
export RESULTS_ROOT="${RESULTS_ROOT:-results}"
export DATA_DIR="${DATA_DIR:-/home/lsh2301541/EPIC/data}"
echo "[03b] RESULTS_ROOT=$RESULTS_ROOT  DATA_DIR=$DATA_DIR"
Rscript "scripts_R/03b_table2_pvalues.R"
