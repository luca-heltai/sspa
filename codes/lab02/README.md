# Lab 02 — Slurm job practice: vector scaling + Monte Carlo sweeps

This lab mirrors Lecture 02. You will (i) compile and time a multi-process vector addition and (ii) run a Monte Carlo parameter sweep with Slurm job arrays and dependencies. The cluster exposes two shared volumes: `$WORK` (persisted under `./docker_images/work`) and `$SCRATCH` (temporary, `./docker_images/scratch`). Keep source and compiled artifacts in `$WORK`; write large intermediates to `$SCRATCH` and clean them up.

## Files

- `vec_add.cpp` – standalone C++ program that adds two vectors and reports throughput.
- `run_vec_add.sh` – helper that builds the binary into `$WORK/bin` and runs a quick local sanity check.
- `vec_add_array.sbatch` – Slurm job array that sweeps `ntasks` = {1,2} to compare scaling; results land in `results/vec_add_ntasks-X.txt`.
- `montecarlo.py` – Monte Carlo integral/simulation producing `.npz` files with the statistics.
- `montecarlo_array.sbatch` – array job that varies the number of samples per task and stores each outcome under `$SCRATCH/montecarlo`.
- `aggregate.sh` – dependency job that runs once to gather `.npz` files into `results/montecarlo_summary.csv`.
- `results/` – committed with a `.gitkeep` placeholder; use it for human-readable outputs you want to persist.

## Exercise 1 — Vector addition scaling

1. SSH into the controller (`ssh sspa-controller`) and the files to `$WORK`.
2. Build the binary:

   ```bash
   cd $WORK/../codes/lab02
   ./run_vec_add.sh build
   ```

3. Submit the job array:

   ```bash
   sbatch vec_add_array.sbatch
   ```

4. Monitor with `squeue -u $USER`. When finished, inspect `results/vec_add_ntasks-*.txt` for effective bandwidth.
5. Extend by editing `vec_add_array.sbatch` to test more `--ntasks` values or adjust `VECTOR_SIZE` in the script.

## Exercise 2 — Monte Carlo sweep + dependency

1. Ensure NumPy is available (`python3 -m pip install --user numpy` inside the controller if needed).
2. Launch the parameter sweep:

   ```bash
   sbatch montecarlo_array.sbatch
   ```

3. Note the array JobID (e.g., `123`). Submit the dependent aggregation job:

   ```bash
   sbatch --dependency=afterok:123 aggregate.sh
   ```

   The provided `aggregate.sh` expects the ID via `$PARENT_JOB_ID`, but you can hardcode `--dependency` directly in the submission line as shown above.

4. Review `results/montecarlo_summary.csv` for sample counts, estimated means, standard deviations, and runtimes.
5. Try changing the `SAMPLES` list in `montecarlo_array.sbatch` or add another parameter such as `--beta` to explore richer sweeps.

## Cleanup tips

- Delete run-specific intermediates from `$SCRATCH/montecarlo` after verifying the summary.
- Keep only small text outputs in `results/` so Git diffs stay readable.
- Use `scancel` liberally if jobs misbehave.
- When done, commit modifications to scripts or source code; binaries and generated results should stay out of Git (except the small summaries we explicitly keep).
