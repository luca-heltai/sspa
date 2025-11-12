#!/bin/bash
#SBATCH --job-name=vec-add
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=1
#SBATCH --time=00:05:00
#SBATCH --array=1-2
#SBATCH --output=results/vec_add_%A_%a.out

set -euo pipefail

LAB_ROOT="${SLURM_SUBMIT_DIR:-$(pwd)}"
BIN_DIR="${WORK:-$LAB_ROOT}/bin"
BIN="${BIN_DIR}/vec_add"

if [[ ! -x "$BIN" ]]; then
  echo "Binary missing; building with run_vec_add.sh"
  "$LAB_ROOT/run_vec_add.sh"
fi

VECTOR_SIZE=${VECTOR_SIZE:-50000000}
TASKS=$SLURM_ARRAY_TASK_ID

mkdir -p "$LAB_ROOT/results"
RESULT_FILE="$LAB_ROOT/results/vec_add_ntasks-${TASKS}.txt"

srun --ntasks=$TASKS --cpus-per-task=1 "$BIN" --size "$VECTOR_SIZE" | tee "$RESULT_FILE"
