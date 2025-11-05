# An Introduction to Scientific Software Tools & Parallel Algorithms (SSPA)

| Item | Link |
| --- | --- |
| Jupyter Book Status | [![Jupyter Book Status](https://github.com/luca-heltai/sspa/actions/workflows/build-book.yml/badge.svg)](https://github.com/luca-heltai/sspa/actions/workflows/build-book.yml) |
| Rendered book | <https://luca-heltai.github.io/sspa/> |
| Course repository | <https://github.com/luca-heltai/sspa> |
| Author | [Luca Heltai](https://github.com/luca-heltai) |
| Course slides | <https://luca-heltai.github.io/sspa/slides/slideshow.html>|

Course materials for a 30-hour PhD-level class (10 × 3h sessions) on practical tools for scientific software and introductory parallel algorithms.

## Overview

This course provides a comprehensive, hands-on introduction to the tools and workflows used in modern scientific software development and an applied introduction to parallel algorithms and performance analysis. Topics include:

- Unix shell and HPC usage (ssh, tmux, Slurm job scheduler)
- Version control using Git (local and collaborative workflows)
- Automated documentation (Doxygen for C/C++, Sphinx/MyST for Python and general docs)
- Unit and functional testing (Google Test for C++, pytest for Python)
- Containerization and reproducibility (Docker, Apptainer/Singularity)
- Continuous Integration and automation (GitHub Actions)
- Basics of parallel computing: speedup, efficiency, Amdahl's and Gustafson's laws

## Learning outcomes

By the end of the course, students will be able to:

- Operate comfortably in a Linux command-line environment and write basic Bash scripts.
- Submit and monitor jobs on a Slurm-based cluster (we provide a Dockerized simulator for exercises).
- Use Git to manage projects, branch, merge, resolve conflicts, and collaborate via pull requests.
- Produce documentation with Doxygen and Sphinx/MyST, including API references and tutorial pages.
- Write unit and functional tests for C++ and Python code and integrate them into CI.
- Build and run Docker and Apptainer containers to package software environments for reproducibility.
- Set up simple CI workflows (GitHub Actions) to run tests and build artifacts automatically.
- Measure simple parallel programs, compute speedup and efficiency, and interpret results using Amdahl's and Gustafson's laws.

## Quick start

1. Browse the compact course book in `jupyterbook/` (index and `lectures/`).

1. To build the book locally (requires jupyter-book):

```bash
pip install -U jupyter-book
jupyter-book build jupyterbook
```

1. Hands-on examples commonly use Docker. See `docker-images/` for Dockerfiles and usage notes if present.

## License

Content: CC-BY. Code examples: MIT. See `LICENSE` for details.

## Course repository structure

Typical layout (some folders may be added later):

- `jupyterbook/` — the course book (index, TOC, lectures)
- `jupyterbook/lectures/` and `jupyterbook/slides/` — session notes and slides
- `codes/` — example programs used in lectures
- `exercises/` — assignment descriptions and starter files
- `docker-images/` — Dockerfiles and compose files for the mini-cluster
- `.github/workflows/` — example CI pipelines used to build/test the material
