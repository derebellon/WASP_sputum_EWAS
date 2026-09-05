#!/bin/bash
#SBATCH --job-name=wasp_02_lca
#SBATCH --output=logs/02_lca_%j.out
#SBATCH --error=logs/02_lca_%j.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
source ~/miniconda3/etc/profile.d/conda.sh
conda activate R_env
cd "${SLURM_SUBMIT_DIR:-$(pwd)}"
# LCA stability: 200 random starts by default (override with LCA_N_SEEDS / LCA_NREP)
# export LCA_N_SEEDS=200
# export LCA_NREP=5
Rscript "scripts_R/02_clinical_phenotype_lca.R"
