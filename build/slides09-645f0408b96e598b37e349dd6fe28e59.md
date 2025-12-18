# Recap: Containers, CI, and Testing Workflows

----

## Goals for the recap

- Rebuild the full toolchain from scratch, end-to-end
- Three example stacks: LaTeX, Python+pytest, C++/googletest
- Three CI workflows per stack: build/push, local tests, registry tests
- Emphasize reproducibility and automation

----

## Lab 09 folder layout

```
codes/lab09/
├── python/
│   ├── docker/
│   ├── tests/
│   └── stats.py
├── cpp/
│   ├── docker/
│   ├── include/
│   ├── src/
│   └── tests/
└── latex/
    ├── docker/
    └── main.tex
```

- Each subproject is self-contained and buildable with Docker.

----

## Pattern to repeat across stacks

1. Minimal code + tests
2. Docker image that can run the tests
3. GitHub Actions workflow to build/push the image
4. GitHub Actions workflow to run tests/compile
5. GitHub Actions workflow to run from GHCR

----

## Python stack

- `stats.py` exposes a small numerical helper
- `tests/` uses pytest to validate mean/std outputs
- Docker image installs `numpy` + `pytest` and runs tests

```bash
docker build -t ghcr.io/luca-heltai/sspa:latest-python -f docker/Dockerfile .
docker run --rm ghcr.io/luca-heltai/sspa:latest-python pytest -q
```

----

## C++ stack

- `CMakeLists.txt` fetches googletest and builds tests
- `src/` + `include/` define a small library
- `tests/` verifies mean/std behavior

```bash
cmake -S . -B build
cmake --build build
ctest --test-dir build --output-on-failure
```

----

## LaTeX stack

- `main.tex` is a tiny document for CI compilation
- Docker image uses TeX Live + `latexmk`
- Workflow compiles the PDF and uploads it as an artifact

```bash
docker build -t ghcr.io/luca-heltai/sspa:latest-latex -f docker/Dockerfile .
docker run --rm -v "$PWD":/work -w /work ghcr.io/luca-heltai/sspa:latest-latex \
  latexmk -pdf -interaction=nonstopmode main.tex
```

----

## GitHub Actions: build and push images

- One workflow per stack (manual trigger)
- Uses `docker/build-push-action` with GHCR login
- Tags images consistently (`latest-python`, `latest-cpp`, `latest-latex`)

```yaml
name: Lab09 Python - Build Image
on: { workflow_dispatch: {} }
```

----

## GitHub Actions: run tests

- Build image, then run containerized tests
- C++ uses `ctest`, Python uses `pytest`, LaTeX compiles
- LaTeX workflow uploads the generated PDF

```yaml
- name: Run pytest
  run: docker run --rm sspa-lab09-python
```

----

## GitHub Actions: test from registry

- Pull tagged images from GHCR
- Mount the repo and run tests inside the container
- Matches CI environment with local code

```yaml
- name: Run pytest in registry image
  run: |
    docker run --rm \\
      -v ${{ github.workspace }}/codes/lab09/python:/work \\
      -w /work \\
      ghcr.io/luca-heltai/sspa:latest-python pytest -q
```

----

## Artifacts in CI

- `actions/upload-artifact` for build outputs
- Useful for PDFs, logs, or compiled binaries
- Makes CI feedback tangible and shareable

----

## Devcontainers

- `.devcontainer/devcontainer.json` per stack
- Uses the same GHCR images as CI
- Aligns local dev with remote testing

----

## Wrap-up checklist

- Can every stack build and test in a clean container?
- Are workflows minimal and readable?
- Do CI outputs (logs/artifacts) help debugging?
- Is the repo structure consistent across stacks?
