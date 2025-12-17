# Continuous Integration with GitHub Actions

----

## Why CI

- Automatic checks on every push/PR keep `main` healthy; catch regressions early.
- Reproducible runners (Ubuntu/Windows/macOS) reduce “works on my machine” drift.
- Fast feedback for students/reviewers; artifacts/logs aid debugging.
- Today: GitHub Actions workflow anatomy, running tests, caching, containers, docs.

----

## GitHub Actions basics

- Workflows live in `.github/workflows/*.yml`; each has triggers (`on:`), jobs, steps.
- Jobs run on runners (`runs-on: ubuntu-latest` etc.); steps use shell or reusable actions.
- Marketplace actions speed up setup (e.g., `actions/checkout`, `actions/setup-python`).
- Permissions/secrets are scoped to the workflow; avoid storing secrets in repo.

----

## Minimal Python test workflow

```yaml
name: Tests
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  pytest:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Install deps
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      - name: Run tests
        run: pytest -q
```

- Keep workflows small and readable; pin action versions (e.g., `@v4`, not `@master`).

----

## Anatomy of a job

- `runs-on`: runner image; use `ubuntu-latest` unless OS-specific.
- `steps`: mix of `uses:` actions and `run:` shell commands.
- `env:` for job-wide variables; `defaults.run.shell: bash` to standardize.
- `timeout-minutes` guards against hung jobs; set per job.

----

## Matrix builds

- Test across versions quickly with `strategy.matrix`:

```yaml
strategy:
  fail-fast: false
  matrix:
    python-version: ["3.10", "3.11", "3.12"]
```

- Reference matrix vars via `${{ matrix.python-version }}` in steps.
- Use `include`/`exclude` to tweak specific combos (e.g., extra deps on 3.12).

----

## Caching dependencies

- Speed up installs with `actions/cache` or built-in caches:
  - `actions/setup-python` exposes `cache: pip`.
  - For Node: `actions/setup-node` with `cache: npm`/`pnpm`/`yarn`.
- Keys include lockfiles to bust cache on dependency changes.
- Always keep `pip install` deterministic (lockfile/constraints) for reproducibility.

----

## Managing secrets and permissions

- Store tokens/keys in repo/org secrets; access via `${{ secrets.MY_TOKEN }}`.
- Minimal scopes: `permissions:` at workflow/job level (e.g., `contents: read`).
- Avoid echoing secrets; prefer `env:` + tools that read from env vars.
- For GHCR pushes: `secrets.GITHUB_TOKEN` (with `packages: write`) or PAT.

----

## Artifacts and test reports

- Upload outputs to debug failures:
  - `actions/upload-artifact` for logs, coverage reports, built binaries.
  - `actions/upload-pages-artifact` for docs previews.
- Name artifacts clearly; keep sizes small (trim caches, compress if needed).
- Combine with `if: always()` to collect logs even when tests fail.

----

## Building and pushing containers

- Enable BuildKit with `docker/setup-buildx-action` for faster multi-platform builds.
- Sample steps:

```yaml
- uses: docker/setup-buildx-action@v3
- uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
- uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: ghcr.io/<org>/<image>:${{ github.sha }}
```

- Use branch/tag-based tags (`main`, `v1.2.0`) and digest pinning for downstream pulls.

----

## Docs and notebooks in CI

- Build docs to prevent bitrot: `pip install -r docs/requirements.txt && make html`.
- JupyterBook/Sphinx: fail on warnings (`-W`) to catch broken links.
- Publish previews:
  - To GitHub Pages via `actions/deploy-pages`.
  - As artifacts for PR reviewers (`upload-pages-artifact`).
- Clear cache of `_build`/`.jupyter_cache` before archiving to keep artifacts small.

----

## Common triggers and filters

- `on: push` (specific branches) and `on: pull_request` for PR gating.
- Path filters to skip CI on doc-only edits:

```yaml
on:
  pull_request:
    paths-ignore: ["docs/**", "*.md"]
```

- `workflow_dispatch` adds a manual “Run workflow” button for one-off runs.
- `concurrency` prevents overlapping runs on the same branch.

----

## Debugging failures

- Re-run failed jobs with “Re-run jobs” or use `actions/upload-artifact` logs.
- Add `actions/setup-python` `cache: pip` debugging with `pip cache dir`.
- Use `--verbose`/`set -x` temporarily; remove once fixed to keep logs clean.
- For flaky tests, mark and fix; avoid `continue-on-error` except for experimental jobs.

----

## Lab 08 outline

- Add a workflow in `.github/workflows/ci.yml` that runs tests (e.g., `pytest`, `ctest`) on pushes/PRs.
- Include caching to speed up installs; parameterize Python/C++ versions if relevant.
- Optional: build a Docker image and push to GHCR on `main`/tags using `docker/build-push-action`.
- Upload artifacts (logs, coverage, docs preview) to help reviewers diagnose failures.
- Break something on purpose, observe CI failing, then fix and confirm green runs.
