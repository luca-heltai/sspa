# Lecture 8 Exercises — Continuous Integration with GitHub Actions (1-week workload)

Objective: add a working CI workflow to your sandbox that runs tests, caches dependencies, and (optionally) builds and publishes a container image. Keep a lab log (`codes/lab08/lab-notebook.md`) with commands, failing/passing runs, and fixes you applied.

## Exercise 1 — Prep and baseline

1. In your `sspa-sandbox`, create `codes/lab08/<name.surname>/` and copy your Lecture 6/7 project there (code plus tests).
2. Run the local suites (e.g., `pytest -q`, `ctest` or your C++ test binary) and note the current status in the lab log.
3. Ensure you have a clean branch dedicated to this lab; record tool versions (`python --version`, `g++ --version`, `pytest --version`).

## Exercise 2 — Minimal CI workflow

1. Create `.github/workflows/ci.yml` under `codes/lab08/<name.surname>/`.
2. Add triggers on `push` and `pull_request` to `main` (or your branch) and a job that:
   - Checks out the repo.
   - Sets up Python (pin a version, e.g., 3.11).
   - Installs dependencies deterministically (`pip install -r requirements.txt` or constraints).
   - Runs your test suite (`pytest -q`, `ctest`, or both).
3. Push and confirm the workflow runs on GitHub; capture screenshots/links and log any failures and fixes.

## Exercise 3 — Matrix and caching

1. Extend the workflow with a matrix over Python versions (e.g., 3.10–3.12) or compilers if you have C++ tests.
2. Enable caching (`actions/setup-python` with `cache: pip` or `actions/cache` keyed on lockfiles) to speed installs.
3. Add sensible job guards: `timeout-minutes`, `fail-fast: false`, and `concurrency` to avoid overlapping runs on the same branch.
4. Rerun CI and note timing improvements or cache hits in the lab log.

## Exercise 4 — Artifacts and docs

1. Upload useful artifacts when jobs succeed or fail (use `if: always()`): test logs, coverage reports, or build outputs.
2. If you have docs (Sphinx/JupyterBook), add a job/step to build them with warnings-as-errors; upload the HTML as an artifact for preview.
3. Check artifact sizes and naming; keep them small and clear. Document what you uploaded and why.

## Exercise 5 — Optional: container build and publish

1. Add steps to build a Docker image with `docker/build-push-action` (enable BuildKit via `docker/setup-buildx-action`).
2. Log in to GHCR using `${{ github.actor }}` and `${{ secrets.GITHUB_TOKEN }}` (ensure `packages: write` permissions) and push tags for `main` and `git tags`.
3. Pin action versions (e.g., `@v5`, `@v3`) and avoid leaking secrets in logs. Record image tags/digests in the lab log.

## Submission checklist

- `codes/lab08/<name.surname>/.github/workflows/ci.yml` with working tests, caching, and matrix (where relevant).
- Optional container build/publish steps configured and documented.
- Artifacts configured for logs/coverage/docs where applicable.
- `lab-notebook.md` with CI run links/screenshots, failures, fixes, and timing notes.
