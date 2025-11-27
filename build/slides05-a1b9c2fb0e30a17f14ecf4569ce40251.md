# Automated Documentation

----

## Why automate docs

- Keep API reference and tutorials in sync with code; avoid stale README snippets.
- Reuse docstrings/comments to generate HTML/PDF without manual copy/paste.
- Enforce structure (API vs how-to vs background) so newcomers ramp up fast.
- Today: Doxygen for C/C++, Sphinx (MyST) for Python/projects, plus docstring hygiene.

----

## Online resources

Doxygen manual:
<https://www.doxygen.nl/manual/index.html>

Sphinx + MyST:
<https://www.sphinx-doc.org/en/master/>  
<https://myst-parser.readthedocs.io/>

Autodoc/autosummary:
<https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html>

----

## Doc types you need

| Type | Purpose | Example |
| ---- | ------- | ------- |
| Reference | Precise API surface (functions, classes, params). | `doxygen` HTML, `sphinx.ext.autodoc` pages. |
| How-to | Task-focused guides. | “Add a new solver”, “Build on GPU”. |
| Tutorials | Narrative, runnable demos. | Jupyter notebooks or MyST markdown. |
| Explanations | Background and design decisions. | “Why we chose PETSc”, “Mesh pipeline”. |

----

## Doxygen comment syntax

- `/** ... */` or `///` for C/C++; `@brief`, `@param name`, `@return`, `@tparam`.
- Use Markdown inside blocks; enable `MARKDOWN_SUPPORT`.
- Group related symbols: `\addtogroup io`, `\ingroup io`, `\page`, `\section`.
- Prefer documenting headers; keep private symbols hidden unless needed.

----

## Minimal Doxyfile knobs

| Key | Typical value | Why |
| --- | ------------- | --- |
| `PROJECT_NAME` | `"MyProject"` | Branding in HTML. |
| `INPUT` / `RECURSIVE` | `src include` / `YES` | Where to scan. |
| `FILE_PATTERNS` | `*.h *.hpp *.cc *.cpp` | Limit languages. |
| `EXTRACT_ALL` | `YES` (for labs) | Show undocumented symbols while learning. |
| `GENERATE_HTML` | `YES` | Primary output. |
| `GENERATE_LATEX` | `NO` | Speed up; enable only if PDF needed. |

----

## Doxygen workflow

```bash
doxygen -g Doxyfile           # create template
sed -i '' 's/EXTRACT_ALL.*/EXTRACT_ALL = YES/' Doxyfile
doxygen Doxyfile              # build HTML in html/ by default
```

- Open `html/index.html`; fix warnings for undocumented params.
- Add `docs/doxygen/` to `.gitignore` if you do not publish the artifacts.
- For mixed C++/Python repos, keep Doxygen focused on C/C++ headers.

----

## Sphinx + MyST quickstart

```bash
python -m pip install sphinx myst_parser
sphinx-quickstart docs
```

- Enable MyST in `conf.py`: `extensions = ["myst_parser"]`.
- Build: `sphinx-build -b html docs docs/_build/html`.
- Keep source in `docs/`; commit `conf.py`, `index.md`, `.md` pages.

----

## Sphinx config essentials

| Option | Example | Effect |
| ------ | ------- | ------ |
| `extensions` | `["myst_parser", "sphinx.ext.autodoc", "sphinx.ext.autosummary", "sphinx.ext.napoleon"]` | Enable markdown, API import, summary tables, Google/NumPy docstrings. |
| `autosummary_generate` | `True` | Auto-create stub pages for modules/classes. |
| `html_theme` | `"furo"` or `"sphinx_rtd_theme"` | Choose a clean default theme. |
| `templates_path` / `exclude_patterns` | `["_templates"]` / `["_build"]` | Keep builds out of the tree. |
| `nitpicky` | `True` | Fail on broken references; keeps links healthy. |

----

## Docstring styles (Python)

```python
def step(x, *, atol=1e-8):
    """Compute a damped step.

    Args:
        x (float): Current iterate.
        atol (float, optional): Absolute tolerance.

    Returns:
        float: Next iterate.
    """
```

- Google/NumPy/NumpyDoc formats all work with `sphinx.ext.napoleon`.
- Keep one-line summary on top; include types and units where relevant.
- Show examples in doctests to validate docs automatically.

----

## Autodoc + autosummary pages

```md
```{autosummary}
:toctree: api
:recursive:
myproj.module
myproj.module.Class
```

```

- Imports modules during the build—ensure dependencies are installed or mock them via `autodoc_mock_imports`.
- Combine with MyST prose pages so API links appear inline (`{py:func}` roles).
- Regenerate stubs after adding modules; commit the generated `.rst`/`.md` files.

----

## Connecting C++ and Sphinx

- To present C++ APIs alongside Python docs, export XML from Doxygen (`GENERATE_XML=YES`) and bridge via `breathe`.
- Use `.. doxygenfunction::` / `.. doxygenclass::` directives inside MyST (````{eval-rst}``` blocks).
- Keep namespaces short and header paths consistent to avoid duplicate entries.

----

## Publishing docs

- Local preview: `python -m http.server 8000 -d docs/_build/html`.
- CI/Pages: build with `sphinx-build -b html ...` then upload `_build/html` to GitHub Pages/Artifacts.
- Cache virtualenvs and Doxygen output in CI to speed builds; fail the job on warnings.
- Add `docs/` target to `Makefile` for one-liners (`make docs-html`, `make doxygen`).

----

## Lab 05 outline

- Copy the provided VWCE C++/Python examples into `./<name.surname>/` in your `sspa-sandbox` clone.
- Add Doxygen comments/docstrings, generate HTML+XML with `doxygen` in the `sspa/docs` container, and fix warnings.
- Build Sphinx+MyST with `autodoc`, `autosummary`, `napoleon`, and `breathe` to combine Python API and C++ XML.
- Add a short tutorial page and verify cross-links (`sphinx-build -n`), then push a branch and open a PR to the teachers’ repo.
