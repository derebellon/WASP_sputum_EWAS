#!/bin/bash
# Orchestrator: submit the EWAS array (A), then the summary (B) after A finishes.
JOB_A=$(sbatch scripts_batch/run_04a_ewas_array.sh | awk '{print $4}')
echo "Submitted 04a EWAS array as job $JOB_A"
sbatch --dependency=afterok:$JOB_A scripts_batch/run_04b_ewas_summary.sh
echo "Submitted 04b summary (starts after $JOB_A completes)"
