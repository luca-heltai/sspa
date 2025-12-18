# Collaborative Git Workflows

----

## Why collaboration is hard

- Collaborate via forks, feature branches, and pull requests without stepping on each other.
- Keep history clean with rebase, topic branches, and review gates.
- Recover quickly from mistakes using reflog, cherry-pick, and bisect.
- Today: end-to-end PR flow, sync forks, and diagnose regressions.

----

## Online resources

Workflow guide:
<https://docs.github.com/en/pull-requests>

Rebase deep dive:
<https://git-scm.com/docs/git-rebase>

History surgery:
<https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History>

Debugging:
<https://git-scm.com/docs/git-bisect>

---

## Remote basics

| Command | Meaning |
| ------- | ------- |
| `git remote -v` | List remotes and fetch/push URLs. |
| `git remote add origin <url>` | Define a primary remote (often your fork). |
| `git remote add upstream <url>` | Track the canonical repo when working from a fork. |
| `git fetch --all --prune` | Update remote-tracking branches and drop deleted refs. |
| `git push -u origin feature/api` | Push a branch and set upstream for future pulls.

----

## Fork/PR workflow (canonical)

1. Fork the repo on GitHub (or create a bare upstream on shared storage).
2. Clone your fork, add `upstream` pointing to the canonical repo.
3. Create a topic branch from `upstream/main`: `git switch -c feature/foo upstream/main`.
4. Commit small, testable changes; rebase onto `upstream/main` before pushing.
5. Push to your fork and open a pull request targeting `upstream/main`.
6. Iterate on review feedback; keep the branch updated via `git pull --rebase upstream main`.

---

## Keeping your fork in sync

```bash
git fetch upstream
git switch main
git rebase upstream/main   # or: git merge upstream/main
git push origin main
```

- Prefer `rebase` for a linear fork main; use `merge` if the team discourages history rewrites.
- Force-pushing your fork’s feature branches is fine until they are merged; avoid rewriting `origin/main`.
- Use `git branch -vv` to verify tracking: `main` → `origin/main`, updates from `upstream/main`.

----

## Rebase vs merge

| Command | When to use | Notes |
| ------- | ----------- | ----- |
| `git merge <branch>` | Preserve true history, create merge commits for divergent lines. | Safe for shared branches; can produce complex graphs. |
| `git rebase <base>` | Linearize your local/topic history before review. | Avoid rebasing published branches; keep conflicts small by rebasing often. |
| `git pull --rebase` | Update current branch without merge commits. | Set `pull.rebase=true` for consistency. |

---

## Interactive cleanup

```bash
git rebase -i upstream/main
# reorder, squash, or drop commits
git commit --amend
git push --force-with-lease
```

- Use `--force-with-lease` to protect others’ work while updating your branch.
- Squash noisy fixup commits before opening/merging PRs.
- Keep signed-off commits if the project requires DCO: `git commit -s`.

----

## Code review essentials

- Small PRs (<300 lines) merge faster; keep one logical change per PR.
- Add context in the PR description: problem, approach, tests run.
- Respond to review with follow-up commits, then squash if the project expects clean history.
- Use `git diff --stat upstream/main..HEAD` and `git diff --word-diff` to check textual changes.

---

## Conflict handling (multi-remote)

```bash
git pull --rebase upstream main   # resolve conflicts once locally
git merge --abort                 # if you need to restart a merge
git rebase --continue             # after fixing files
```

- Enable rerere to auto-remember resolutions: `git config --global rerere.enabled true`.
- If conflicts are messy, create a throwaway branch to experiment, then cherry-pick the clean commits back.
- After resolving, run tests before pushing to avoid breaking CI.

----

## Safety nets

| Command | Purpose |
| ------- | ------- |
| `git reflog` | Recover lost commits/branches by walking `HEAD` history. |
| `git stash push -m "<msg>"` | Temporarily park work-in-progress changes. |
| `git worktree add ../wt-feature feature/foo` | Multiple working trees for parallel tasks without stashing. |
| `git cherry-pick <rev>` | Apply specific commits onto another branch. |
| `git bisect start` | Binary search commits to find regressions. |

---

## Hooks and automation

| Hook | Use case |
| ---- | -------- |
| `pre-commit` | Lint/format before commits; can block bad code. |
| `commit-msg` | Enforce message conventions (prefixes, ticket IDs). |
| `pre-push` | Run smoke tests before pushing to CI. |
| `post-checkout` | Auto-install deps or switch configs per branch. |

- Keep hooks in-repo via frameworks like `pre-commit` so teammates share tooling.
- Use CI to duplicate critical checks; hooks are fast guards, not a substitute.

----

## Release hygiene

- Tag release candidates and finals (`v1.2.0-rc1`, `v1.2.0`) after CI passes.
- Generate release notes from commits: `git log --oneline upstream/main..HEAD`.
- Cut maintenance branches (`release/1.2`) and cherry-pick hotfixes from `main`.
- Archive reproducible states with `git bundle create release.bundle main`.

---

## Lab 04 outline

- Fork the course repo (or mirror locally), add `upstream`, and open a PR from `feature/review-checklist`.
- Practice `rebase -i` to squash fixups, then `push --force-with-lease` safely.
- Enable rerere, trigger a CI run, and recover a “lost” commit using `reflog`.
- Run a `git bisect` mini-demo on a provided failing test; document the steps and culprit commit.
