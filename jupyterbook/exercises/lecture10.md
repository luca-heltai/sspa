# Lecture 10 Exercises — Scaling Analysis (1-week workload)

Objective: measure **strong** and **weak** scaling on a small parallel benchmark, compute **speedup/efficiency**, and interpret results using **Amdahl’s** and **Gustafson’s** laws. Keep a lab log in `codes/lab10/lab-notebook.md`.

## Exercise 1 — Prepare your workspace

1. In your `sspa-sandbox`, create `codes/lab10/<name.surname>/` and copy the starter code from `codes/lab10/python/` into it.
2. Verify the benchmark runs serially:
   - `python bench_pi.py --processes 1 --samples 2000000`
3. Record your environment in the lab log (CPU model, OS, `python --version`).

## Exercise 2 — Strong scaling experiment

1. Fix the total work (e.g., `--samples 20000000`) and run with `p = 1, 2, 4, 8, ...` up to the core count you can access.
2. Use the provided runner to collect multiple trials and save a CSV:
   - `python run_scaling.py strong --samples 20000000 --max-procs 16 --trials 5 --out strong.csv`
3. In the lab log, note any anomalies (slow outliers, oversubscription effects, noisy runs).

## Exercise 3 — Weak scaling experiment

1. Keep work per process constant (e.g., base samples per process) and scale the total samples with `p`.
2. Collect a second CSV:
   - `python run_scaling.py weak --samples-per-proc 2000000 --max-procs 16 --trials 5 --out weak.csv`
3. Discuss: does the wall time stay roughly constant? If not, why?

## Exercise 4 — Analyze and interpret

1. Analyze both CSV files:
   - `python analyze_scaling.py strong.csv`
   - `python analyze_scaling.py weak.csv`
2. For strong scaling:
   - compute \(S(p)\) and \(E(p)\)
   - estimate the serial fraction using the Karp–Flatt metric
   - compare the observed trend with Amdahl’s bound
3. For weak scaling:
   - report time growth (if any) and propose the likely bottleneck(s)

## Exercise 5 — Short write-up

Write a short report (can be in `lab-notebook.md`) that includes:

- experimental setup (hardware, commands, parameters)
- strong scaling table (p, time, speedup, efficiency, estimated serial fraction)
- weak scaling table and interpretation
- at least 2 actionable performance ideas (e.g., reduce overhead, bigger chunks, different RNG strategy)

## Submission checklist

- `codes/lab10/<name.surname>/` containing:
  - your benchmark and scripts
  - `strong.csv` and `weak.csv`
  - `lab-notebook.md` with results and interpretation

