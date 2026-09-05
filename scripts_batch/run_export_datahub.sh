#!/bin/bash
#SBATCH --job-name=wasp_export_datahub
#SBATCH --output=logs/export_datahub_%j.out
#SBATCH --error=logs/export_datahub_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=48G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/export_datahub.R"
