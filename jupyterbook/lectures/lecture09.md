# Lecture 9 — Recap: Reproducible Dev Environments (3h)

Objectives

- Summarize the course tooling: containers, CI, and testing workflows
- Build three example Docker images (LaTeX, Python+pytest, C++/googletest)
- Implement GitHub Actions workflows to build/push images and run tests inside them
- Compile a LaTeX document and publish artifacts in CI

Content summary

We revisit all major themes by assembling three minimal projects under `codes/lab09`:

- `python`: NumPy-based utilities with pytest tests
- `cpp`: a CMake project with googletest and a sample test suite
- `latex`: a minimal document compiled in CI with artifacts uploaded

Each project includes a Docker image recipe plus GitHub Actions workflows to build/push the image and run the corresponding tests using `container.image`.

<!-- FOOTER START -->
<iframe src="/slideshow/slides09.html" width="100%" height="800px" style="border: none;"></iframe>

---

```{admonition} 🎬 View Slides
:class: tip

**[Open slides in full screen](/slideshow/slides09.html)** for the best viewing experience.
```
<!-- FOOTER END -->
