#!/bin/bash
###############################################################################
# autopush_when_done.sh — wait for the WASP re-run jobs to finish, then push
# results and figures to GitHub so the paper can be updated with the new numbers.
#
# Run on a LOGIN node (compute nodes usually have no outbound internet):
#   cd ~/EPIC/WASP_sputum_EWAS
#   nohup bash scripts_batch/autopush_when_done.sh > logs/autopush.out 2>&1 &
#
# It waits until no SLURM job named wasp_* remains for this user, refreshes the
# paper figures (best effort), then commits and pushes. The huge per-probe EWAS
# CSVs are gitignored, so they are not pushed.
#
# Requires the push token to be set in the remote once:
#   git remote set-url origin https://TOKEN@github.com/derebellon/WASP_sputum_EWAS.git
###############################################################################
set -u
cd ~/EPIC/WASP_sputum_EWAS || exit 1
mkdir -p logs
echo "[autopush] started $(date -u +%FT%TZ)"

# 1) Wait until all wasp_* jobs leave the queue.
while squeue -u "$USER" -h -o "%j" 2>/dev/null | grep -q "^wasp_"; do
  sleep 60
done
echo "[autopush] all wasp_* jobs finished $(date -u +%FT%TZ)"

# 2) Best-effort refresh of the paper figures (non-blocking).
if [ -f scripts_R/10_paper_figures.R ]; then
  source ~/miniconda3/etc/profile.d/conda.sh 2>/dev/null && conda activate R_env 2>/dev/null
  Rscript scripts_R/10_paper_figures.R || echo "[autopush] 10_paper_figures failed (non-blocking)"
fi

# 3) Safety: warn about any oversized file that is not gitignored (should be none).
echo "[autopush] oversized (>50M) non-ignored files (should be empty):"
git ls-files -oc --exclude-standard -z 2>/dev/null | xargs -0 -r ls -l 2>/dev/null \
  | awk '$5 > 52428800 {print $5, $9}'

# 4) Commit and push.
git add -A
if git -c user.name="David Esteban Rebellón Sánchez" \
      -c user.email="derebellons@gmail.com" \
      commit -m "results: LCA-freeze re-run — corrected primaries + inflammatory overlap + figures ($(date -u +%FT%TZ))"; then
  if git push origin main; then
    echo "[autopush] PUSH OK $(date -u +%FT%TZ)"
  else
    echo "[autopush] PUSH FAILED — set the token remote and push manually:"
    echo "  git remote set-url origin https://TOKEN@github.com/derebellon/WASP_sputum_EWAS.git && git push origin main"
  fi
else
  echo "[autopush] nothing new to commit"
fi
echo "[autopush] done $(date -u +%FT%TZ)"
