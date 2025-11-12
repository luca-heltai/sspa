# Lecture 2 — HPC Cluster Usage & Slurm

----

## Secure Shell (SSH) refresher

- SSH encrypts remote shells and tunnels; clients verify server host keys, then authenticate using passwords or key pairs.
- Preferred workflow: generate a key pair, load it into `ssh-agent`, and avoid typing passwords for every login.
- Everything rides over TCP port 22 (or remapped host ports like `2222` here); you can multiplex shells, port-forward VS Code, or copy files with `scp`.
- Understanding SSH well is essential before we rely on it to reach the Slurm login node.

---

## Generate and manage keys

```bash
ssh-keygen -t ed25519 -C "you@uni" -f ~/.ssh/sspa_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/sspa_ed25519
```

- Use modern `ed25519`; keep the private key mode `600` and protect it with a passphrase.
- `ssh-agent` (or `gpg-agent`) holds decrypted keys, so CLI tools reopen shells without prompts.
- Keep backups of your private key in secure password managers or hardware tokens.

---

## Custom SSH config for the mini-cluster

`~/.ssh/config`

```sshconfig
Host sspa-controller
  HostName localhost
  Port 2222
  User sspa
  IdentityFile ~/.ssh/sspa_ed25519
  IdentitiesOnly yes
```

- Lets you run `ssh sspa-controller` and reuse the profile in `scp`, VS Code, etc.
- Add more hosts (e.g., campus clusters) with `ProxyJump` once you outgrow the Docker playground.
- Keep file permissions at `600`; OpenSSH ignores overly permissive configs.

---

## Chaining hosts with ProxyJump

- `ProxyJump` (alias `-J`) lets SSH connect through one or more bastion hosts before reaching a private node.
- Example:

  ```sshconfig
  Host campus-cluster
    HostName cluster.internal
    User you
    ProxyJump bastion.example.edu
  ```

- When you run `ssh campus-cluster`, OpenSSH first logs into `bastion.example.edu`, opens a tunnel, then connects to `cluster.internal`.
- Use commas to list multiple jumps (`ProxyJump bastion1,bastion2`); combine with `IdentityFile` to use different keys per hop.

---

## SSH tunnels (port forwarding)

- **Local forwarding** (`-L`): expose a remote service on your laptop.

  ```bash
  ssh -L 8899:worker1:8888 sspa-controller
  ```

  Visit `http://localhost:8899` to reach Jupyter on `worker1:8888`.

- **Remote forwarding** (`-R`): publish a local port to the remote host (e.g., debugging tools).
- **Dynamic forwarding** (`-D`): create a SOCKS proxy for browsers or package managers.
- Tunnels respect the same keys/configs; combine with `ProxyJump` to reach otherwise sealed networks.

---

## Push keys for passwordless access

```bash
ssh-copy-id -i ~/.ssh/sspa_ed25519.pub -p 2222 sspa@localhost
# manual fallback:
cat ~/.ssh/sspa_ed25519.pub | ssh -p 2222 sspa@localhost \
  "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

- `ssh-copy-id` validates host keys, uploads yours, and fixes permissions automatically.
- Re-run this after you rebuild containers (home directories reset).
- Once keys are installed, commands, VS Code remote tunnels, and git-over-ssh all work without passwords.

----

# Slurm

----

## Why Slurm?

- Real HPC clusters rarely allow ad-hoc logins; everything goes through a scheduler.
- Slurm is the de-facto standard in EuroHPC + many university clusters, so practicing here pays off immediately.
- We ship a self-contained Docker mini-cluster (`docker_images/`) so you can experiment safely.
- Today: go from connecting to the controller, to writing job scripts, to managing arrays and dependencies.

---

## Learning goals

- Understand Slurm concepts, job scripts, and management commands.
- Practice full lifecycle: `sinfo` → `sbatch` → `squeue`/`sacct` → `scancel`.
- Use interactive allocations for debugging and job arrays for sweeps.
- Prepare exercises that will live under `codes/lab02`.

----

## Mini-cluster layout (Docker)

- `docker compose` file defines `controller`, `worker1`, `worker2`, and an optional `jupyter` helper.
- Ports: controller forwards `22` → host `2222`, Slurm daemons on `6817/6818` stay internal.
- Volume `docker_images/slurm-state` keeps Slurm state between restarts; remove if you want a clean slate.
- Shared host volumes: `codes/lab02/work` → `/work`, `codes/lab02/scratch` → `/scratch`.
- Default user inside images: `sspa` (password `sspa-password`, sudo available on controller).

---

## Start or reset the environment

```bash
cd docker_images              # called docker_files in the IDE overview
./build_images.sh             # only first time or after Dockerfile edits
docker compose up -d controller worker1 worker2
```

- `docker compose ps` should show 3 containers `Up`.
- Rebuild only when Dockerfiles change; otherwise `docker compose pull`/`up` is instant.
- Use `docker compose logs controller -f` if Slurm fails to start.

----

## SSH into the controller (step-by-step)

1. Ensure containers are running (`docker compose ps`).
2. Password defaults to `sspa-password`, but reset it anytime from the host:

   ```bash
   cd docker_images
   docker compose exec controller bash -lc 'echo "sspa:sspa-password" | chpasswd'
   ```

3. On the host, trust the controller and log in:

   ```bash
   ssh -p 2222 sspa@localhost
   ```

4. (Optional, safer) copy your SSH key for passwordless logins:

   ```bash
   ssh-copy-id -p 2222 sspa@localhost
   ```

5. Verify you are on the controller: `hostname` should print `controller`.
6. Test Slurm visibility: `sinfo` must list the `debug` partition with `worker[1-2]` nodes.

---

## Troubleshooting the SSH hop

- Connection refused → check Docker Desktop is running and `docker compose up -d` succeeded.
- Password rejected → rerun the `chpasswd` command or `docker compose exec controller passwd sspa` interactively.
- Key mismatch warnings → remove old host entry: `ssh-keygen -R [localhost]:2222`.
- Absolute fallback: `docker compose exec controller bash` keeps you productive even without SSH.

----

## Slurm concepts refresher

- **Controller (slurmctld)** accepts requests and schedules work on nodes running **slurmd**.
- **Partitions** group nodes with similar features; default here is `debug`.
- **Job** = resource request + script. Slurm enforces limits and tracks state.
- Canonical command set: `sinfo`, `squeue`, `sbatch`, `srun`, `salloc`, `scancel`, `sacct`.

---

## Step-by-step Slurm workflow

1. **Inspect resources** — `sinfo -Nl` shows nodes, states, core counts.
2. **Author a job script** — encode directives (`#SBATCH`) + workload commands.
3. **Submit** — `sbatch job.sh` returns a job ID.
4. **Monitor** — `squeue -j <id>` during runtime; `sacct -j <id>` for completed history.
5. **Interact** — `srun` inside scripts launches tasks; `salloc` grants an interactive shell.
6. **Terminate early** — `scancel <id>` (single job) or `scancel -u $USER` (bulk) when something goes wrong.
7. **Collect outputs** — Slurm writes `<jobname>.o<jobid>` / `.e<jobid>` unless you override paths.

---

## Resource requests that matter

- `#SBATCH --partition=debug` — partition choice.
- `#SBATCH --nodes=1`, `#SBATCH --ntasks=2`, `#SBATCH --cpus-per-task=1` — how many processes/cores.
- `#SBATCH --mem=2G` — per-node memory; enforce realistic values.
- `#SBATCH --time=00:05:00` — wall-clock limit avoids runaway jobs.
- Use `scontrol show job <id>` to confirm what the scheduler understood vs what you asked.

----

## Minimal batch script template

```bash
#!/bin/bash
#SBATCH --job-name=hello-slurm
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --time=00:02:00
#SBATCH --output=slurm-%j.out

module purge            # no modules here, but keep habit
set -euo pipefail

srun -l hostname        # label output with rank IDs
python3 codes/lab02/hello.py
```

- Put scripts under version control (`jupyterbook/slides` references them).
- Use `%j` token to stamp log files with the job ID.
- `-l` flag on `srun` prefixes each line with the task number for clarity.

---

## Interactive allocations

- `salloc --nodes=1 --ntasks=1 --time=00:30:00` gives you a shell with reserved resources.
- Run `srun --pty bash` if you prefer to keep login shell untouched.
- Great for debugging MPI/OpenMP initialization before wrapping it in `sbatch`.
- Remember to `exit` when done; otherwise the allocation blocks others.

---

## Job arrays & dependencies

```bash
#!/bin/bash
#SBATCH --job-name=param-scan
#SBATCH --array=0-9
#SBATCH --output=logs/scan_%A_%a.out

PARAMS=(0.1 0.2 0.5 1 2 5 10 20 50 100)
python3 codes/lab02/sweep.py --beta "${PARAMS[$SLURM_ARRAY_TASK_ID]}"
```

- `%A` = array master ID, `%a` = task index.
- Chain workloads: `sbatch --dependency=afterok:<jobid> next-step.sh` to run only when the first job succeeds.
- Use arrays for embarrassingly parallel scans; combine with dependencies for staged pipelines.

----

## Monitoring & debugging checklist

- `squeue -u $USER` → quick look at what is pending/running.
- `sacct -j <jobid>` (not available in the minimal Docker setup, but expect it on production clusters) → historical state, elapsed time, resource use.
- `scontrol show node worker1` → inspect node state if jobs stay pending (maybe `drain`).
- Check Slurm logs inside controller: `/var/log/slurm/slurmctld.log` (via `sudo less`).
- Container-specific: restart a misbehaving worker with `docker compose restart worker1`.

---

## Work vs scratch spaces

- `$WORK` (`/work`) is persistent: use it for source trees, compiled binaries, notebooks, lab writeups.
- `$SCRATCH` (`/scratch`) is fast but disposable: stage temporary inputs, checkpoints, and job outputs you intend to post-process soon.
- Copy critical results back to `$WORK` or Git before stopping the cluster; `scratch` can be wiped between sessions.
- Many production clusters enforce quotas/expiry on scratch, so start practicing good hygiene now (clean up after big runs).

----

## Exercises to place under `codes/lab02`

- **Exercise 1 – CPU scaling probe**: add `codes/lab02/vec_add.cpp` + `codes/lab02/run_vec_add.sh`. Compile with `cmake` or `g++`, then write a batch script that sweeps `--ntasks=1,2` using a job array to compare elapsed times (store results in `codes/lab02/results/`).
- **Exercise 2 – Parameter sweep w/ dependencies**: create `codes/lab02/montecarlo.py` producing intermediate `.npz` files. Submit an array job to vary sample counts, then a dependent `aggregate.sh` that runs once (`--dependency=afterok:$ARRAY_JOBID`) to merge outputs into a summary table.
- Document findings in a short `README` inside `codes/lab02/` so future students can reuse the workflow.
