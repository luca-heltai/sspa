# Unit and Functional Testing

----

## Why we test

- Catch regressions early instead of in production; quantify correctness with fast feedback.
- Build confidence to refactor (tests become safety net); document expected behavior via examples.
- Separate concerns: cheap unit tests on logic, heavier functional tests on flows.
- Today: gtest for C++, pytest for Python, plus small-data strategies and TDD loops.

----

## Online resources

gtest primer: <https://google.github.io/googletest/primer.html>  
gtest advanced: <https://google.github.io/googletest/advanced.html>  
pytest docs: <https://docs.pytest.org/>  
TDD intro: <https://martinfowler.com/bliki/TestDrivenDevelopment.html>

----

## Test taxonomy

| Type | Scope | Purpose | Example |
| ---- | ----- | ------- | ------- |
| Unit | Single function/class; no I/O | Pin down logic; fast feedback. | `daily_returns` on 3 prices. |
| Integration | A few modules together | Check contracts between parts. | CSV loader + stats pipeline. |
| Functional/E2E | Realistic user flow | Validate business outcome. | CLI generates `vwce_gnuplot.dat`. |
| Smoke/Regression | Minimal run / bug guard | Ensure binary runs; prevent recurrence. | Run main on sample CSV. |

----

## Qualities of good tests

- Deterministic: no randomness/time/network; seed data; fixed tolerances.
- Isolated: no shared state; use temp dirs/files; clean up outputs.
- Small and focused: one behavior per test; descriptive names.
- Assertions that explain: prefer `EXPECT_NEAR`, `EXPECT_THROW`, `assert dd == pytest.approx(...)`.
- Fast: keep <100 ms per unit test; functional tests still bounded.

----

## gtest essentials (C++)

```cpp
#include <gtest/gtest.h>

TEST(Stats, DailyReturns)
{
  std::vector<PricePoint> prices = {{.close = 100}, {.close = 110}};
  auto r = daily_returns(prices);
  EXPECT_EQ(r.size(), 1);
  EXPECT_NEAR(r[0], 0.1, 1e-12);
}

int main(int argc, char **argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
```

- Compile/link: `g++ -std=c++17 -Iinclude test.cpp -lgtest -lgtest_main -pthread`.
- Use `EXPECT_*` for non-fatal checks, `ASSERT_*` when later lines depend on the result.

----

## gtest fixtures and parameters

- `TEST_F(FixtureName, Case)` to share setup/teardown; put common data in `SetUp()`/`TearDown()`.
- `TEST_P` + `INSTANTIATE_TEST_SUITE_P` for table-driven cases without copy/paste.
- Combine with custom matchers or `EXPECT_THAT` (gmock) for readable assertions.
- Keep fixtures lean: prefer helper functions that return ready-to-test vectors.

----

## pytest essentials (Python)

- Discovery: files named `test_*.py` or `*_test.py`, functions/classes named `Test*`.
- Plain `assert` is rewritten with helpful diffs; use `pytest.approx` for floats.
- CLI: `pytest -q`, `pytest tests/test_stats.py -k returns`, `pytest -x` to stop on first failure.
- Parametrize cases: `@pytest.mark.parametrize("prices, expected", [...])`.

----

## pytest fixtures and helpers

- Built-ins: `tmp_path` for temp files/dirs, `capfd`/`capsys` for stdout/stderr capture.
- Custom fixtures share setup: put in `conftest.py`; yield resources to auto-clean.
- Markers: `@pytest.mark.slow`, `@pytest.mark.xfail` for known issues.
- Monkeypatching: `monkeypatch.setenv`, `monkeypatch.setattr` to isolate from the environment.

----

## Edge cases for the VWCE examples

- Empty or 1-row CSV → loader errors or zero returns; ensure graceful handling.
- Constant closes → zero variance/volatility; no division by zero.
- Known mini-series → expected annualized return and drawdown dates.
- Bad paths/permissions → throw/exit cleanly and emit helpful messages.
- Output file contents → first/last line structure, monotone running peak.

----

## Red–green–refactor loop

![Red–green–refactor loop (Martin Fowler card)](https://martinfowler.com/bliki/images/test-driven-development/card.png)

---

- Red: write a failing test that expresses intent; run to see it fail.
- Green: implement the smallest change to pass; no heroic refactors yet.
- Refactor: clean code/tests with safety net; keep tests green after each small step.
- Commit in small increments; keep CI scripts (`ctest`, `pytest`) easy to run.

----

## Running tests and structure

- Suggested layout:  
  `c++/{src,tests}` with `CMakeLists.txt` + `add_executable(tests ...)`;  
  `python/` with `tests/` and `conftest.py`.
- C++ one-shot build:  
  `g++ -std=c++17 main.cpp tests/test_vwce.cpp -lgtest -lgtest_main -pthread -o test_vwce && ./test_vwce`

---

- Python: `pytest -q python/tests` (add `-vv` for verbose).
- Make tests hermetic: bundle tiny CSV fixtures in the repo; avoid using the full 2024 dataset unless needed.

----

## Lab 06 outline

- Use the VWCE C++ and Python examples into `<name.surname>/` in your `sspa-sandbox`.
- Add gtest-based unit tests for the C++ functions (loader, returns, variance, drawdown) and a smoke test for the CLI.
- Add pytest suites for the Python functions and CLI, using fixtures for sample CSVs and temp output paths.
- Run tests in the provided container/toolchain; fix any bugs uncovered; keep a short lab log and push a clean branch for review.
