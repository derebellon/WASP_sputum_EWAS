#!/bin/bash
#SBATCH --job-name=wasp_lca_diag
#SBATCH --output=logs/lca_diag_%j.out
#SBATCH --error=logs/lca_diag_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/lca_solution_diagnostics.R"
