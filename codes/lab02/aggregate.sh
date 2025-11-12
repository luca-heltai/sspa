#!/bin/bash
#SBATCH --job-name=mc-aggregate
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:05:00
#SBATCH --output=results/montecarlo_aggregate_%j.out

set -euo pipefail

LAB_ROOT="${SLURM_SUBMIT_DIR:-$(pwd)}"
SCRATCH_DIR=${SCRATCH:-$LAB_ROOT/scratch}/montecarlo
SUMMARY_FILE="$LAB_ROOT/results/montecarlo_summary.csv"

export LAB_ROOT SCRATCH_DIR SUMMARY_FILE

python3 - <<'PY'
import csv
import os
import pathlib
import sys

import numpy as np

lab_root = pathlib.Path(os.environ.get('LAB_ROOT', '.'))
scratch_dir = pathlib.Path(os.environ.get('SCRATCH_DIR', 'scratch/montecarlo'))
summary_file = pathlib.Path(os.environ.get('SUMMARY_FILE', 'results/montecarlo_summary.csv'))

scratch_dir.mkdir(parents=True, exist_ok=True)
summary_file.parent.mkdir(parents=True, exist_ok=True)
rows = []
for npz_path in sorted(scratch_dir.glob('*.npz')):
    data = np.load(npz_path)
    rows.append({
        'file': npz_path.name,
        'samples': int(data['samples']),
        'beta': float(data['beta']),
        'mean': float(data['mean']),
        'std': float(data['std']),
        'elapsed': float(data['elapsed']),
    })

if not rows:
    print(f"No .npz files found in {scratch_dir}; nothing to aggregate.")
    sys.exit(0)

with summary_file.open('w', newline='') as fp:
    writer = csv.DictWriter(fp, fieldnames=['file', 'samples', 'beta', 'mean', 'std', 'elapsed'])
    writer.writeheader()
    writer.writerows(rows)

print(f"Wrote {len(rows)} rows to {summary_file}")
PY
