#!/usr/bin/env python3
"""Simple Monte Carlo sweep producing .npz outputs for later aggregation."""

from __future__ import annotations

import argparse
import json
import os
import pathlib
import time

import numpy as np


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(description="Monte Carlo toy simulation")
  parser.add_argument("--samples", type=int, default=200_000, help="Number of samples")
  parser.add_argument("--beta", type=float, default=0.1, help="Parameter for the integrand")
  parser.add_argument("--outdir", type=pathlib.Path, default=None, help="Override output directory")
  return parser.parse_args()


def main() -> None:
  args = parse_args()
  scratch_root = pathlib.Path(os.environ.get("SCRATCH", pathlib.Path.cwd())) / "montecarlo"
  outdir = args.outdir or scratch_root
  outdir.mkdir(parents=True, exist_ok=True)

  rng = np.random.default_rng()
  x = rng.random(args.samples)
  values = np.exp(-args.beta * x * x)

  start = time.perf_counter()
  estimate = values.mean()
  std = values.std(ddof=1)
  stop = time.perf_counter()

  payload = {
      "beta": args.beta,
      "samples": args.samples,
      "mean": float(estimate),
      "std": float(std),
      "elapsed": stop - start,
  }

  outfile = outdir / f"beta{args.beta:.2f}_n{args.samples}.npz"
  np.savez(outfile, **payload)

  print(json.dumps({"output": str(outfile), **payload}, indent=2))


if __name__ == "__main__":
  main()
