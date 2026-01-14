#!/usr/bin/env python3

from __future__ import annotations

import argparse
import math
import multiprocessing as mp
import os
import random
import time
from dataclasses import dataclass


@dataclass(frozen=True)
class BenchResult:
    pi: float
    inside: int
    samples: int
    seconds: float
    processes: int


def _count_inside_circle(samples: int, seed: int) -> int:
    rng = random.Random(seed)
    inside = 0
    for _ in range(samples):
        x = rng.random()
        y = rng.random()
        if x * x + y * y <= 1.0:
            inside += 1
    return inside


def estimate_pi(samples: int, processes: int, base_seed: int = 0) -> BenchResult:
    if processes < 1:
        raise ValueError("processes must be >= 1")
    if samples < 1:
        raise ValueError("samples must be >= 1")

    t0 = time.perf_counter()

    if processes == 1:
        inside = _count_inside_circle(samples, base_seed)
    else:
        base = samples // processes
        extras = samples % processes
        work = [base + (1 if i < extras else 0) for i in range(processes)]

        # Derive deterministic, distinct seeds for each worker.
        seeds = [base_seed + 1000003 * i for i in range(processes)]
        with mp.Pool(processes=processes) as pool:
            inside_parts = pool.starmap(_count_inside_circle, zip(work, seeds))
        inside = int(sum(inside_parts))

    seconds = time.perf_counter() - t0

    pi = 4.0 * inside / float(samples)
    return BenchResult(pi=pi, inside=inside, samples=samples, seconds=seconds, processes=processes)


def _positive_int(value: str) -> int:
    parsed = int(value)
    if parsed <= 0:
        raise argparse.ArgumentTypeError("must be a positive integer")
    return parsed


def main() -> int:
    parser = argparse.ArgumentParser(description="Monte Carlo pi benchmark (serial or multiprocessing).")
    parser.add_argument("--samples", type=_positive_int, required=True, help="Total random samples to draw.")
    parser.add_argument("--processes", type=_positive_int, default=1, help="Number of worker processes.")
    parser.add_argument(
        "--seed",
        type=int,
        default=0,
        help="Base RNG seed (deterministic; each worker derives a distinct seed).",
    )
    args = parser.parse_args()

    # If the user runs with processes > available CPUs, show a helpful hint.
    cpu_count = os.cpu_count() or 1
    if args.processes > cpu_count:
        print(f"warning: --processes={args.processes} exceeds detected CPUs ({cpu_count})", flush=True)

    result = estimate_pi(samples=args.samples, processes=args.processes, base_seed=args.seed)

    err = abs(result.pi - math.pi)
    print(f"pi={result.pi:.8f}  abs_err={err:.3e}  time_s={result.seconds:.6f}  p={result.processes}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

