#!/bin/bash
#SBATCH --job-name=wasp_05_figures
#SBATCH --output=logs/05_figures_%j.out
#SBATCH --error=logs/05_figures_%j.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/05_figures_montage.R"
