#!/bin/bash
###############################################################################
# autopush_thesis_updates.sh — wait for the two light thesis-update jobs
# (wasp_08e_top200 + wasp_03b_table2p) to finish, then commit and push the new
# outputs to GitHub so Athenea can pull them and build the thesis figures/tables.
#
# Run on a LOGIN node (compute nodes have no outbound internet):
#   cd ~/EPIC/WASP_sputum_EWAS
#   nohup bash scripts_batch/autopush_thesis_updates.sh > logs/autopush_thesis.out 2>&1 &
#
# It does NOT re-run the heavy paper figures; it only pushes the two new outputs:
#   - results/06_sensitivity_inflammatory/enrichment_top200/*.csv   (08e)
#   - results/03_cohort_tables/Table2_QC-EPIGEN_by_LCA*.{html,csv}  (03b)
#
# The push token must be set once in the remote:
#   git remote set-url origin https://TOKEN@github.com/derebellon/WASP_sputum_EWAS.git
###############################################################################
set -u
cd ~/EPIC/WASP_sputum_EWAS || exit 1
mkdir -p logs
echo "[autopush-thesis] started $(date -u +%FT%TZ)"

# 1) Wait until both thesis-update jobs leave the queue.
while squeue -u "$USER" -h -o "%j" 2>/dev/null | grep -qE "^wasp_(08e_top200|03b_table2p)"; do
  sleep 30
done
echo "[autopush-thesis] thesis-update jobs finished $(date -u +%FT%TZ)"

# 2) Safety: list any oversized non-ignored file (should be none).
echo "[autopush-thesis] oversized (>50M) non-ignored files (should be empty):"
git ls-files -oc --exclude-standard -z 2>/dev/null | xargs -0 -r ls -l 2>/dev/null \
  | awk '$5 > 52428800 {print $5, $9}'

# 3) Stage only the thesis-update outputs + the scripts (keeps the commit focused).
git add -A \
  scripts_R/03b_table2_pvalues.R \
  scripts_R/08e_enrichment_inflammatory_top200.R \
  scripts_R/03_data_harmonization.R \
  scripts_batch/run_03b_table2_pvalues.sh \
  scripts_batch/run_08e_enrichment_top200.sh \
  scripts_batch/autopush_thesis_updates.sh \
  "results/03_cohort_tables/Table2_QC-EPIGEN_by_LCA.html" \
  "results/03_cohort_tables/Table2_QC-EPIGEN_by_LCA_pvalues.csv" \
  "results/06_sensitivity_inflammatory/enrichment_top200" 2>/dev/null

if git -c user.name="David Esteban Rebellón Sánchez" \
      -c user.email="derebellons@gmail.com" \
      commit -m "thesis: Table 2 between-phenotype p-values (03b) + inflammatory enrichment top-200 KEGG/GO (08e) ($(date -u +%FT%TZ))"; then
  if git push origin main; then
    echo "[autopush-thesis] PUSH OK $(date -u +%FT%TZ)"
  else
    echo "[autopush-thesis] PUSH FAILED — set the token remote and push manually:"
    echo "  git remote set-url origin https://TOKEN@github.com/derebellon/WASP_sputum_EWAS.git && git push origin main"
  fi
else
  echo "[autopush-thesis] nothing new to commit"
fi
echo "[autopush-thesis] done $(date -u +%FT%TZ)"
