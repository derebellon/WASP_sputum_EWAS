#!/bin/bash
#SBATCH --job-name=wasp_03_harmon
#SBATCH --output=logs/03_harmon_%j.out
#SBATCH --error=logs/03_harmon_%j.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/03_data_harmonization.R"
