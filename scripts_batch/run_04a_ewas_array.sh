#!/bin/bash
#SBATCH --job-name=wasp_04a_ewas
#SBATCH --array=1-14
#SBATCH --output=logs/04a_ewas_%A_%a.out
#SBATCH --error=logs/04a_ewas_%A_%a.err
#SBATCH --time=08:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
# One of the 14 pre-specified contrasts per array task.
Rscript "scripts_R/04a_ewas_contrasts.R" $SLURM_ARRAY_TASK_ID
