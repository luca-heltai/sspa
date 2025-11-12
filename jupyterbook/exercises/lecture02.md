# Lecture 2 Exercises — SSH & Slurm Practice (1-week workload)

Objective: practice secure access patterns and Slurm job engineering inside the Docker cluster. Deliver a short lab notebook (Markdown) with command transcripts, screenshots, and timing tables. Keep code under `codes/lab02/` unless otherwise noted.

## Exercise 1 — Hardened SSH workflow

1. Generate two SSH key pairs: one Ed25519 for personal logins, one RSA limited to Git interactions. Store them under `~/.ssh/keys/lecture02/` with descriptive names.
2. Create a multi-host SSH config:
   - `sspa-controller` (localhost:2222) using the Ed25519 key.
   - `sspa-worker1` reachable via `ProxyJump sspa-controller`.
   - A fake campus cluster entry that demonstrates `ProxyJump` chaining plus a local port forward example.
3. Set up local and remote SSH agents (`ssh-agent` + `ssh-add`). Document how you forwarded the agent through the controller to worker1 (`ssh -A`).
4. Provide a troubleshooting section: how to rotate host keys, what to do when permissions are wrong, and how to test tunnels with `nc` or `curl`.

## Exercise 2 — Job arrays & dependencies

1. Extend the provided `vec_add_array.sbatch` to cover ntasks `{1,2,4}` and capture results into `$WORK/results/vec_add_ntasks-<n>.txt`.
2. Modify `montecarlo_array.sbatch` so that each array task writes metadata into `$SCRATCH/montecarlo/meta/<jobid>_<taskid>.json` alongside the `.npz` file.
3. Write a new cleanup job `cleanup.sh` that deletes scratch artifacts older than 2 days (use `find -mtime +2`). Chain it with `--dependency=afterany:<aggregate_jobid>`.
4. Keep an experiment log summarizing queue wait time, run time, and resource requests. Include at least one `scontrol show job` output annotated to explain key fields.

## Exercise 3 — Interactive debugging workflow

1. Request an interactive allocation (`salloc --nodes=1 --time=00:20:00`) and within it:
   - Launch `htop` or `top` to observe CPU usage.
   - Run `srun --pty bash` on worker1 and verify `$SLURM_JOB_ID` remains the same.
2. Demonstrate live code editing: modify `montecarlo.py` to print progress every 5 seconds, run it interactively, then revert the change.
3. Capture the commands required to forward a Jupyter notebook from worker1 back to your laptop using SSH tunnels (`ssh -L`). Explain how you would adapt the ports when bridging through the controller.

## Submission checklist

- Provide SLURM job IDs, command transcripts, and relevant log snippets.
- Include any helper scripts you wrote (cleanup, metadata writer, etc.).
- Note open issues or unanswered questions you encountered; these feed future lectures.
