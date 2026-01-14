# Lab 10 — Scaling analysis (starter materials)

This lab supports Lecture 10 (speedup/efficiency, strong vs weak scaling, Amdahl/Gustafson).

## What’s included

- `python/bench_pi.py`: Monte Carlo π benchmark (serial or multiprocessing)
- `python/run_scaling.py`: run strong/weak scaling sweeps and write CSV
- `python/analyze_scaling.py`: compute tables (speedup/efficiency or weak-scaling ratios)
- `lab-notebook.md`: template for your lab notes

## Quick start

From `codes/lab10/python/`:

```bash
python bench_pi.py --processes 1 --samples 2000000
python run_scaling.py strong --samples 20000000 --max-procs 16 --trials 5 --out strong.csv
python analyze_scaling.py strong.csv
```

