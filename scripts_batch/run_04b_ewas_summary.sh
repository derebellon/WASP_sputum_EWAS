#!/bin/bash
#SBATCH --job-name=wasp_04b_summary
#SBATCH --output=logs/04b_summary_%j.out
#SBATCH --error=logs/04b_summary_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/04b_ewas_summary.R"
