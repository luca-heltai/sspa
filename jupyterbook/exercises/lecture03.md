# Lecture 3 Exercises — Git Fundamentals (1-week workload)

Objective: gain fluency with Git workflows used in collaborative HPC projects. Produce a short lab log (`codes/lab03/lab-notebook.md`) containing command transcripts (`script` logs or `git status` snapshots), screenshots when useful, and short reflections on pitfalls. Use a single repository under `codes/lab03/` unless noted; keep commits clean and chronologically meaningful.

## Exercise 1 — Repository bootstrap & hygiene

1. Initialize a repository in `codes/lab03/` and add a starter `README.md` describing the experiment plus a `src/` directory with a minimal program or script (any language).
2. Create `.gitignore` entries for build artifacts, editor configs, and datasets you expect to generate. Document why each pattern belongs there.
3. Configure local Git settings (`user.name`, `user.email`, `core.editor`, `init.defaultBranch`) and capture the output of `git config --list --local`.
4. Make at least two initial commits: one for the scaffold, one for the ignore/configuration setup. Include commit messages that match the lecture guidance (50-char subject, descriptive body). Paste `git log --oneline` into the notebook.

## Exercise 2 — Intentional branching & merging

1. Create `feature/parser` and `feature/report` branches from `main`. On each branch implement a focused change (e.g., parser adds CLI flags, report adds Markdown summary). Ensure each branch contains 2+ commits.
2. Before merging, run `git fetch --all` and inspect divergence with `git log --graph --oneline --decorate --all`. Embed a screenshot or copy of the graph.
3. Merge `feature/parser` into `main` with a fast-forward. Then intentionally diverge `main` and `feature/report` so the merge requires a merge commit (e.g., edit the same paragraph in different ways). Resolve the conflict, documenting the decision process and the final merged diff.
4. Tag the resulting state as `v0.1-gitlabs` and push the tag to a remote (use `git remote add origin <path>` to another folder if GitHub is unavailable). Verify with `git tag -n` and `git push --tags` output.

## Exercise 3 — History inspection & rollback practice

1. Use `git blame`, `git show`, and `git diff main..feature/parser` to answer specific questions: who added the CLI flag, which commit changed the README introduction, and what files differ between branches. Copy the commands + condensed outputs.
2. Demonstrate three undo strategies on throwaway commits: `git restore <file>` (working tree only), `git reset --soft HEAD~1` (rewrite staging), and `git revert <hash>` (create corrective commit). Explain when each is safe on shared branches.
3. Simulate a mishap: create a commit with an undesirable binary file, then remove it properly using `git rm --cached` + `.gitignore`. Show that history no longer includes the blob by running `git cat-file -s <hash>` before/after.
4. Bundle the repository (`git bundle create lab03.bundle main feature/report`) or export a patch series (`git format-patch main~3..main`) and note how teammates could review or apply it offline.

## Submission checklist

- Lab notebook with commands, commentary, and screenshots.
- Repository archive (`lab03.bundle` or `.zip`) plus tag `v0.1-gitlabs`.
- Mention open questions (e.g., how to split commits better, CLI flags you’d like to automate) for discussion in Lecture 4.
