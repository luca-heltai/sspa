# Lecture 5 Exercises — Automated Documentation (1-week workload)

Objective: use the provided VWCE examples (C++ and Python) to generate automated docs with Doxygen + Sphinx/MyST. Work inside your `sspa-sandbox` repository: copy the starter files into a personal folder `codes/lab05/<name.surname>/`, build docs in the `sspa/docs` container, and open a pull request to the teachers’ repository when done. Produce a lab log (`codes/lab05/lab-notebook.md`) with commands, screenshots, and short reflections. Good Git hygiene: commit early/often with clear messages, keep changes focused, and push regularly.

## Exercise 1 — Prepare workspace and tools

1. Build the docs image: from `docker_images/`, run `./build_images.sh` (or `docker build -t sspa/docs -f docs.Dockerfile .`).
2. In your `sspa-sandbox` clone, create `codes/lab05/<name.surname>/` and copy the provided examples:  
   `cp -r /path/to/course/codes/lab05/{c++,python,vwce_2024.csv,fetch_vwce.sh} codes/lab05/<name.surname>/`
3. Start a container mounting the sandbox repo:  
   `docker run --rm -it -v "$PWD":/workspace -w /workspace sspa/docs bash`.
4. Inside the container, record tool versions: `doxygen --version`, `sphinx-build --version`, `python -c "import myst_parser; print(myst_parser.__version__)"`.

## Exercise 2 — Doxygen reference for the C++ example

1. In `codes/lab05/<name.surname>/c++`, add Doxygen-style comments to `main.cpp` (briefs, params, returns, grouping if you split files).
2. Generate a `Doxyfile` (`doxygen -g Doxyfile`), set `INPUT` to the C++ folder, `EXTRACT_ALL=YES`, `GENERATE_HTML=YES`, `GENERATE_LATEX=NO`, and enable `GENERATE_XML=YES` for Sphinx later.
3. Run `doxygen Doxyfile`; fix warnings (undocumented params, missing brief) until clean. Include a screenshot of the HTML index.
4. Commit the C++ source + `Doxyfile` to your branch with a concise message (e.g., `docs: add doxygen config for vwce cpp`).

## Exercise 3 — Sphinx + MyST for the Python example (and Breathe bridge)

1. In `codes/lab05/<name.surname>/python`, add clear docstrings (Google or NumPy style) to functions in `main.py` covering parameters, returns, and examples.
2. In `codes/lab05/<name.surname>/`, run `sphinx-quickstart docs`. Enable `myst_parser`, `autodoc`, `autosummary`, `napoleon`, and `breathe` in `docs/conf.py`; set `autosummary_generate = True`.
3. Point `breathe_projects` to the C++ Doxygen XML output so the C++ API appears in Sphinx. Add an `api.md` page with `{autosummary}` for Python modules and a `cpp.md` page using Breathe directives.
4. Add a short tutorial page (`docs/tutorial.md`) showing how to run the scripts and interpret `vwce_gnuplot.dat`; link to at least two API entries via MyST roles.
5. Build with `sphinx-build -n -b html docs docs/_build/html`; fix warnings. Commit Sphinx sources (not `_build/`) with a focused message (e.g., `docs: add sphinx+myst with python/cpp api`).

## Submission checklist

- `codes/lab05/lab-notebook.md` with commands, notes, and screenshots of Doxygen + Sphinx HTML.
- Source changes committed under `codes/lab05/<name.surname>/` (C++ comments + Doxyfile, Python docstrings, Sphinx/MyST pages, Breathe wiring).
- Open a pull request from your `sspa-sandbox` fork/branch to the teachers’ repository; keep commits small and well-labeled. Ensure `git status` is clean before the PR. Mention any open issues/questions for Lecture 6.
