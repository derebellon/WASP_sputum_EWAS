#!/bin/bash
#SBATCH --job-name=wasp_fresh_lca
#SBATCH --output=logs/fresh_lca_%j.out
#SBATCH --error=logs/fresh_lca_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/make_fresh_lca_assignment.R"
