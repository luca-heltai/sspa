#!/usr/bin/env python3

from __future__ import annotations

import argparse
import csv
import os
import statistics
from pathlib import Path

from bench_pi import estimate_pi


def _positive_int(value: str) -> int:
    parsed = int(value)
    if parsed <= 0:
        raise argparse.ArgumentTypeError("must be a positive integer")
    return parsed


def _default_process_list(max_procs: int) -> list[int]:
    procs: list[int] = [1]
    p = 2
    while p <= max_procs:
        procs.append(p)
        p *= 2
    if procs[-1] != max_procs:
        procs.append(max_procs)
    return sorted(set(procs))


def _parse_procs(procs: str) -> list[int]:
    values = []
    for part in procs.split(","):
        part = part.strip()
        if not part:
            continue
        values.append(_positive_int(part))
    if not values:
        raise argparse.ArgumentTypeError("empty --procs list")
    return sorted(set(values))


def run_trials(*, samples: int, processes: int, trials: int, seed: int) -> list[float]:
    times: list[float] = []
    for t in range(trials):
        result = estimate_pi(samples=samples, processes=processes, base_seed=seed + t)
        times.append(result.seconds)
    return times


def main() -> int:
    parser = argparse.ArgumentParser(description="Run strong/weak scaling sweeps for bench_pi.py and write CSV.")
    subparsers = parser.add_subparsers(dest="mode", required=True)

    strong = subparsers.add_parser("strong", help="Strong scaling: fixed total samples.")
    strong.add_argument("--samples", type=_positive_int, required=True, help="Total samples (fixed across p).")

    weak = subparsers.add_parser("weak", help="Weak scaling: fixed samples per process.")
    weak.add_argument(
        "--samples-per-proc",
        type=_positive_int,
        required=True,
        help="Samples per process (total samples = p * samples_per_proc).",
    )

    for sub in (strong, weak):
        sub.add_argument("--max-procs", type=_positive_int, default=os.cpu_count() or 1)
        sub.add_argument("--procs", type=_parse_procs, default=None, help="Comma-separated list (overrides --max-procs).")
        sub.add_argument("--trials", type=_positive_int, default=5, help="Trials per process count.")
        sub.add_argument("--seed", type=int, default=0, help="Base seed (trial seeds are derived deterministically).")
        sub.add_argument("--out", type=Path, required=True, help="Output CSV path.")

    args = parser.parse_args()

    if args.procs is None:
        process_list = _default_process_list(args.max_procs)
    else:
        process_list = args.procs

    rows: list[dict[str, object]] = []

    for p in process_list:
        if args.mode == "strong":
            total_samples = int(args.samples)
            samples_per_proc = total_samples / float(p)
        else:
            samples_per_proc = int(args.samples_per_proc)
            total_samples = int(samples_per_proc * p)

        times = run_trials(samples=total_samples, processes=p, trials=args.trials, seed=args.seed)
        for trial_idx, seconds in enumerate(times, start=1):
            rows.append(
                {
                    "mode": args.mode,
                    "processes": p,
                    "samples_total": total_samples,
                    "samples_per_proc": samples_per_proc,
                    "trial": trial_idx,
                    "time_s": seconds,
                }
            )

        best = min(times)
        median = statistics.median(times)
        print(f"p={p:>2}  samples={total_samples:<10}  best={best:.6f}s  median={median:.6f}s")

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w", newline="") as f:
        writer = csv.DictWriter(
            f, fieldnames=["mode", "processes", "samples_total", "samples_per_proc", "trial", "time_s"]
        )
        writer.writeheader()
        writer.writerows(rows)

    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

