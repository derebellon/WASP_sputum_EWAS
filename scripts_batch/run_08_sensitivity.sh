#!/bin/bash
#SBATCH --job-name=wasp_08_sens
#SBATCH --output=logs/08_sens_%j.out
#SBATCH --error=logs/08_sens_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=48G
#SBATCH --time=12:00:00
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
# Sensitivity EWAS by sputum inflammatory phenotype (one-vs-rest, no cell
# adjustment) + KEGG/GO enrichment + cross-signature overlap. Paths default to the
# cluster layout; override with DATA_FOLDER, MAIN_DIR, SENS_DIR, VENN_DIR, PRIMARY_PATTERN.
Rscript "scripts_R/08_sensitivity_inflammatory_phenotypes.R"
