#!/bin/bash
#SBATCH --job-name=mc-array
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --array=0-4
#SBATCH --output=results/montecarlo_%A_%a.out

set -euo pipefail

LAB_ROOT="${SLURM_SUBMIT_DIR:-$(pwd)}"
SAMPLES=(50000 100000 200000 400000 800000)
SAMPLE_COUNT=${SAMPLES[$SLURM_ARRAY_TASK_ID]}
BETA=${BETA:-0.25}

SCRATCH_DIR=${SCRATCH:-$LAB_ROOT/scratch}
mkdir -p "$SCRATCH_DIR/montecarlo"

srun python3 "$LAB_ROOT/montecarlo.py" --samples "$SAMPLE_COUNT" --beta "$BETA" --outdir "$SCRATCH_DIR/montecarlo"
