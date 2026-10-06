#!/bin/bash
#SBATCH --job-name=wasp_01_qc
#SBATCH --output=logs/01_qc_%j.out
#SBATCH --error=logs/01_qc_%j.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/01_quality_control_normalization.R"
