#!/bin/bash
#SBATCH --job-name=wasp_07_enrich_fig
#SBATCH --output=logs/07_enrich_fig_%j.out
#SBATCH --error=logs/07_enrich_fig_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
Rscript "scripts_R/07_enrichment_figures.R"
