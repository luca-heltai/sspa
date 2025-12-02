
# Lecture 6 Exercises — Unit and Functional Testing (1-week workload)

Objective: turn the VWCE C++ and Python examples from Lecture 5 into test-driven mini-projects. Work in your `sspa-sandbox` under `./<name.surname>/`, keeping a lab log (`lab-notebook.md`) with commands, design notes, and failing/passing test outputs. Aim for repeatable suites: no network calls, small fixtures, deterministic assertions.

## Exercise 1 — Setup and baseline

1. Copy the Lecture 5 materials into `./<name.surname>/`:  
   `cp -r /path/to/course/codes/lab05/{c++,python,vwce_2024.csv,fetch_vwce.sh} codes/lab06/<name.surname>/`
2. Verify the original programs still run on the full CSV (C++ and Python) and note current outputs in the lab log.
3. Ensure toolchains are ready: C++17 compiler plus gtest (system package or vendored), Python 3 with `pytest`. Record versions: `g++ --version`, `pytest --version`.

## Exercise 2 — gtest suite for the C++ code

1. Create `c++/tests/test_vwce.cpp` (or similar) and wire a build: a simple `CMakeLists.txt` with `find_package(GTest)` + `enable_testing()` is fine, or a one-shot command like  
   `g++ -std=c++17 main.cpp tests/test_vwce.cpp -lgtest -lgtest_main -pthread -o test_vwce`.
2. Add unit tests for pure functions: `mean`, `variance` (including single-value/empty vectors), `daily_returns` (constant and increasing prices), `annualized_return` (zero/positive series), `max_drawdown` (known mini-series with expected start/end dates), and CSV error handling (`load_prices` throws on missing file).
3. Add a functional/smoke test that runs the main pipeline on a tiny CSV fixture (3–5 rows) written in the test and checks the gnuplot output file has monotonically non-decreasing running peaks and matching row count.
4. Run `ctest` or `./test_vwce` until all cases pass; fix any bugs discovered in `main.cpp` rather than weakening tests. Capture failures and fixes in the notebook.

## Exercise 3 — pytest suite for the Python code

1. Under `python/tests/`, add `conftest.py` for shared fixtures (e.g., a small `PricePoint` list and a temporary CSV writer using `tmp_path`).
2. Write unit tests mirroring the C++ coverage: loader error path, mean/variance, daily/annualized returns, drawdown tuple, and gnuplot writer (verify header + running peak monotonicity).
3. Add a CLI smoke test: run `python -m main --csv <tiny_csv> --out <tmp>` via `subprocess.run` (capture stdout) and assert exit code 0 plus file creation.
4. Execute `pytest -q` (or `pytest -q python/tests`) and iterate until green. Note any discrepancies with the C++ results and align behaviors if appropriate.

## Exercise 4 — Regression guards and hygiene

1. Add at least one regression test for a bug you fixed (mark it clearly in the test name/docstring).
2. Keep fixtures small and checked in; avoid relying on the full 2024 CSV for fast runs. If you need floating-point comparisons, use `EXPECT_NEAR`/`pytest.approx` with justified tolerances.
3. Optionally add `ctest`/`pytest` targets to a root `Makefile` or CI config in your sandbox to make running both suites a one-liner.

## Submission checklist

- `./<name.surname>/` contains the C++/Python sources plus test suites and any minimal fixtures; no large generated artifacts committed.
- `lab-notebook.md` with commands, failing/passing outputs, and brief notes on fixes/regressions.
- A clean git history in your sandbox branch; push and open a PR to the teachers’ repository, mentioning remaining questions for Lecture 7.
