# Lecture 4 Exercises — Collaborative Git Workflows (1-week workload)

Objective: practice fork-based collaboration, PR hygiene, and recovery tools. Produce a lab log (`codes/lab04/lab-notebook.md`) with commands, short explanations, and screenshots where useful. Use a fork or a bare “upstream” plus a working clone under `codes/lab04/`.

## Exercise 1 — Fork, remotes, and PR prep

1. Fork the course repository (or create a local bare repo as `upstream.git`) and clone your fork as the working copy.
2. Add remotes: `origin` (your fork) and `upstream` (canonical). Show `git remote -v` and `git remote show upstream`.
3. Create `feature/review-checklist` from `upstream/main`, commit 2–3 focused changes (e.g., add a PR checklist doc + small script). Use meaningful messages.
4. Rebase onto latest `upstream/main`, resolve any conflicts, and push the branch to your fork (`git push -u origin feature/review-checklist`). Capture `git log --graph --oneline --decorate --all`.

## Exercise 2 — Clean history and review cycle

1. Run `git rebase -i upstream/main` to squash/fixup noisy commits; document the before/after `git log --oneline`.
2. Open a pull request (or simulate locally) and write a PR description with problem, approach, and tests. Note any CI/pre-push hooks run.
3. Receive simulated review feedback: make a follow-up commit addressing comments, then squash if your project prefers a tidy history.
4. Practice safe force-push: `git push --force-with-lease`. Explain why `--force-with-lease` is safer than `--force`.

## Exercise 3 — Conflict handling and recovery tools

1. Enable rerere (`git config --global rerere.enabled true`), manufacture a merge or rebase conflict, resolve it, and show rerere auto-applying on a second run.
2. Demonstrate `git worktree add ../wt-hotfix hotfix/critical` to work on two branches without stashing. Merge the hotfix back cleanly.
3. Run a mini `git bisect` on a provided script with a known regression; log commands and the identified bad commit.
4. Use `git reflog` to recover a deliberately “lost” commit (e.g., after a reset) and restore it via `git cherry-pick`. Include the reflog entries used.

## Submission checklist

- Lab notebook with commands, explanations, and conflict/resolution notes.
- Repository archive (`lab04.bundle` or `.zip`) including branch `feature/review-checklist` and tag `v0.1-collab` (if applicable).
- PR link or simulated PR description; mention open questions or tricky points for Lecture 5 discussion.
