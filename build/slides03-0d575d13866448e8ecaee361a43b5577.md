# Git Fundamentals

----

## Why Git?

- Track every change, switch contexts quickly, and revert when experiments go wrong.
- Branch-first workflows let you collaborate asynchronously without overwriting each other.
- Git’s distributed history keeps the full project in every clone—perfect for HPC/offline work.
- Today’s target: from `git init` to confident branching + conflict resolution.

----

## Online resources

Tutorial:
<https://gitimmersion.com/>

Sandbox:
<https://learngitbranching.js.org/>

Recap:
<https://jwiegley.github.io/git-from-the-bottom-up/>

Book:
<https://git-scm.com/book/en/v2>

---

## Git Terminology — Foundations

| Command | Meaning |
| ------- | ------- |
| `git init` | Create a `.git/` metadata directory and begin tracking history in the current folder. |
| `git clone <url>` | Copy an existing repository, including all commits, branches, and remotes. |
| `git status` | Summarize working tree, staging area, and untracked files at a glance. |
| `git add <path>` | Stage file changes so the next commit snapshot includes them. |

---

## Git Terminology — Commits & History

| Command | Meaning |
| ------- | ------- |
| `git commit` | Record staged changes as an immutable snapshot with author + message. |
| `git log` | Walk through commit history; combine with `--graph`/`--oneline` for structure. |
| `git show <rev>` | Inspect a single commit’s metadata and diff. |
| `git diff A..B` | Compare two revisions (branches, tags, hashes) to see how they diverge. |

---

## Git Terminology — Branching & Recovery

| Command | Meaning |
| ------- | ------- |
| `git branch -vv` | Create/list/delete branch refs and display upstream tracking info. |
| `git switch <branch>` | Move `HEAD` to another branch or commit (optionally create it with `-c`). |
| `git merge <branch>` | Integrate another branch into the current branch via fast-forward or merge commit. |
| `git rebase <base>` | Replay commits onto a new base to linearize local history. |
| `git tag <name>` | Label specific commits (typically releases) with immutable names. |
| `git stash` | Shelve working tree changes temporarily to restore a clean state. |

----

## Create a repository (or clone)

```bash
# start from scratch
mkdir lab03 && cd lab03
git init

# or clone existing work
git clone git@github.com:luca-heltai/sspa.git
cd sspa
```

- `git init` creates a `.git` directory with object store + refs; nothing is tracked until staged.
- Always double-check `pwd` before running `git init` to avoid nesting repos.
- Cloning copies commits, branches, and remotes; `origin` is just a convention.

----

## Configure identity and defaults

```bash
git config --global user.name  "Luca Heltai"
git config --global user.email "luca.heltai@unipi.it"
git config --global core.editor "code --wait"
git config --global init.defaultBranch main
```

- Use `--global` for workstation-wide defaults, `--local` per repo, and `--system` when administering labs.
- Keep `.gitconfig` in version control if you manage multiple hosts (dotfiles repo).
- Set `.gitignore` early (`build/`, `*.o`, `.vscode/`) to avoid accidental blobs.

----

## Staging area workflow

```bash
git status -sb
git add src/main.cpp docs/README.md
git restore --staged docs/README.md   # unstage
git diff --staged                     # review
```

- Index (a.k.a. staging area) lets you curate commits: add files piecemeal or even select hunks (`git add -p`).
- `git status -sb` shows concise state; `??` = untracked, `M` = modified, `A` = added.
- Clean working trees make rebases and merges painless; commit once tests/docs pass.

----

## Crafting commits

```bash
git commit -m "Grid: add MPI halo exchange for lab"
git commit --amend            # rewrite last commit (before push)
```

- Think “one logical change per commit”; tests + docs included.
- Present tense, <= 50-char subject, blank line, then optional wrapped body (~72 columns).
- Use `git commit --amend` only on unpublished commits; otherwise create a fixup (`git commit --fixup <hash>` + rebase).

----

## Inspect history

```bash
git log --oneline --graph --decorate -n 8
git show HEAD^
git diff main..feature/parser
git blame src/io.cpp
```

- `git log --stat` reveals touched files, perfect for review prep.
- `git show` works on any revision: `HEAD`, `HEAD~2`, tags, or full hashes.
- Range syntax (`A..B`, `A...B`) highlights divergent work: `git log main..feature` shows commits only on `feature`.

----

## Branching model

```bash
git switch -c feature/cli-enhancements
git switch main
git branch -vv
```

- Lightweight pointers: branches just reference commits; switching moves `HEAD`.
- Naming convention: `topic/<goal>` or `feature/<issue-number>` keeps history readable.
- Remote tracking branches (`origin/main`) update with `git fetch`; never commit directly on them.

----

## Merging and fast-forwards

```bash
git switch main
git merge feature/cli-enhancements
```

- If `main` is behind `feature`, Git performs a fast-forward (no merge commit).
- Divergent histories produce a true merge commit with two parents; include a good message (`-m`).
- Keep main linear with `git pull --ff-only`; if that fails, rebase your branch before merging.

----

## Resolve merge conflicts

1. Run `git merge feature/api` and let Git stop at conflicts.
2. Open marked files (`<<<<<<<`, `=======`, `>>>>>>>`) and edit to the desired result.
3. `git add <file>` after each fix; verify with `git status`.
4. Finish with `git commit` (merges reuse combined log).

```bash
git merge --abort   # bail out if you need to restart
```

- VS Code, `git mergetool`, or CLI diff3 markers help compare versions.
- Commit frequently; conflict scopes stay small when branches are short-lived.

----

## Undo strategies

- `git restore <file>` – discard working copy changes.
- `git reset HEAD~1` – move branch pointer (use `--hard` only when sure; data rewrites).
- `git revert <hash>` – new commit that negates an older change; safe on shared branches.
- Tag releases (`git tag -a v0.3 -m "Lab03 baseline"`) before risky refactors.

----

## Lab 03 outline

- Initialize a repo under `codes/lab03`, add a `.gitignore`, and commit the scaffold.
- Implement a small program or markdown report, split into at least three focused commits.
- Create `feature/refactor` and `feature/docs`, merge both into `main`, and capture a deliberate conflict to practice resolution.
- Use `git log --graph` screenshot or `git bundle` export to submit proof of workflow mastery.
