# Lecture 7 Exercises — Containers (Docker & Apptainer) (1-week workload)

Objective: containerize the Python VWCE example from Lecture 6, including its pytest suite. Build a Docker image from scratch (no pre-made course image), run the app and tests inside the container, and optionally convert to Apptainer for HPC. Keep a lab log (`codes/lab07/lab-notebook.md`) with build/run commands and notes.

## Exercise 1 — Prep and copy sources

1. In your `sspa-sandbox`, create `codes/lab07/<name.surname>/`.
2. Copy the Lecture 6 Python materials (source + tests you wrote) into that folder: `cp -r /path/to/lab06/<name.surname>/python codes/lab07/<name.surname>/`.
3. Confirm the code and tests still run on the host: `pytest -q`.

## Exercise 2 — Write the Dockerfile from scratch

1. Create `Dockerfile` in `codes/lab07/<name.surname>/` with a small base (e.g., `python:3.11-slim`).
2. Add a non-root user, set `WORKDIR`, copy the code, install Python deps (at least `pytest`; pin versions via `requirements.txt` if you have one), and set a sensible default `CMD` (e.g., `["python", "-m", "main", "--csv", "vwce_2024.csv"]`).
3. Add a build target or stage for tests so you can run `pytest` inside the image without polluting the final runtime layer. Document the target name (e.g., `--target test`).
4. Include a `.dockerignore` to keep images lean (no `__pycache__`, `.git`, large CSVs if unnecessary).

## Exercise 3 — Build and run

1. Build the runtime image: `docker build -t vwce:latest .`
2. Run the app with a bind mount for your working directory:  
   `docker run --rm -v "$PWD":/app -w /app vwce:latest python -m main --csv vwce_2024.csv --out /app/out.dat`
3. Verify output and logs; capture the command and output snippet in your notebook.

## Exercise 4 — Run tests inside the container

1. Execute the test stage/target: `docker build -t vwce:test --target test .` or `docker run --rm vwce:latest pytest -q`.
2. Confirm the suite passes; if it fails, fix code/tests and rebuild.
3. Record failing/passing outputs in the notebook, along with the final commands used.

## Exercise 5 — Optional: Apptainer for HPC

1. If Apptainer is available, convert your Docker image:  
   `apptainer build vwce.sif docker-daemon://vwce:latest`
2. Run the CLI inside the `.sif`: `apptainer exec vwce.sif python -m main --csv vwce_2024.csv`.
3. Note any path binding requirements (`-B`) or permission quirks in the notebook.

## Submission checklist

- `codes/lab07/<name.surname>/Dockerfile` (and `.dockerignore`/`requirements.txt` if used) plus the Python source/tests.
- `lab-notebook.md` with build/run commands, outputs, and any issues.
- Runtime image runs the VWCE script; test stage/command runs pytest successfully. Optional `.sif` if you tried Apptainer.
