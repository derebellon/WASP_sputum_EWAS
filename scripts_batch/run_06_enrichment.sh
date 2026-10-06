#!/bin/bash
#SBATCH --job-name=wasp_06_enrich
#SBATCH --array=1-14
#SBATCH --output=logs/06_enrich_%A_%a.out
#SBATCH --error=logs/06_enrich_%A_%a.err
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
# KEGG and GO enrichment (missMethyl gometh), one contrast per array task.
Rscript "scripts_R/06_enrichment_kegg_go.R"
