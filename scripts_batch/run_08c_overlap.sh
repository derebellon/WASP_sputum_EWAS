#!/bin/bash
#SBATCH --job-name=wasp_08c_overlap
#SBATCH --output=logs/08c_overlap_%j.out
#SBATCH --error=logs/08c_overlap_%j.err
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/08c_overlap_only.R"
