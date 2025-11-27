# Lecture 1 Exercises — Command Line Foundations (1-week workload)

Goal: internalize shell fluency, scripting discipline, and reproducible environment setup. Submit a short report (Markdown or PDF) describing your approach, commands used, and lessons learned. Keep scripts in this repo under `codes/lab01` or your personal fork.

## Exercise 1 — Personal shell profile & prompt hygiene

1. Starting from the base image used in lecture (Zsh or Bash), craft a reproducible shell profile:
   - Define at least three aliases that speed up navigation and Git interactions.
   - Write one shell function `mkproj <name>` that creates a project folder with subdirs `src/`, `data/`, `notes/` and initializes Git.
   - Configure a prompt that shows the current Git branch and changes color when the last command failed.
2. Store the profile snippets in `~/dotfiles/lecture01/` and provide a `setup.sh` that symlinks them into `~/.bashrc` or `~/.zshrc`.
3. Document testing steps: open a fresh shell to verify aliases, run `mkproj demo` and confirm structure + git init.

## Exercise 2 — Portable log analyzer

1. Write a POSIX-compliant shell script `bin/log_analyzer.sh` that reads a glob of log files (e.g., `logs/*.log`) and prints:
   - Total number of lines, warnings (`[WARNING]`), and errors (`[ERROR]`).
   - Top five most frequent warning messages.
2. Support two flags:
   - `-p pattern` to filter lines before counting.
   - `-o file` to send the summary to a text file instead of stdout.
3. Add usage/help text and exit codes for bad inputs.
4. Prove portability: run under both Bash and `dash` (or BusyBox `sh`). Mention any differences observed.

## Exercise 3 — Data pipeline with pipes & tools

1. Fetch the latest release list of this repository (use `curl` + GitHub API or the locally cloned repo if offline).
2. Build a pipeline that produces a table with columns `tag`, `published_at`, `commit_sha` (first 10 chars).
3. Save the command sequence in `pipelines/releases.sh` and ensure it accepts an optional `--json path.json` argument to read from a saved file instead of hitting the network.
4. Include `shellcheck` output (or a justification if unavailable) to show the script passes linting.

## Submission checklist

- Provide paths to your scripts/profile files, plus sample invocations.
- Compress the working directory or push to a fork so the instructor can reproduce.
- Highlight one stumbling block and how you solved it.
