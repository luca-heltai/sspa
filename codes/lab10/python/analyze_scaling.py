#!/usr/bin/env python3

from __future__ import annotations

import argparse
import csv
import statistics
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path

from scaling import efficiency, karp_flatt_serial_fraction, speedup


@dataclass(frozen=True)
class Summary:
    mode: str
    processes: int
    samples_total: int
    samples_per_proc: float
    time_s: float


def _read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as f:
        reader = csv.DictReader(f)
        return list(reader)


def _summarize(rows: list[dict[str, str]], time_stat: str) -> list[Summary]:
    by_p: dict[int, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        by_p[int(row["processes"])].append(row)

    summaries: list[Summary] = []
    for p, group in sorted(by_p.items()):
        mode = group[0].get("mode", "unknown")
        samples_total = int(float(group[0]["samples_total"]))
        samples_per_proc = float(group[0]["samples_per_proc"])
        times = [float(g["time_s"]) for g in group]
        if time_stat == "min":
            t = min(times)
        elif time_stat == "median":
            t = statistics.median(times)
        else:
            raise ValueError(f"unknown time_stat={time_stat}")
        summaries.append(
            Summary(
                mode=mode,
                processes=p,
                samples_total=samples_total,
                samples_per_proc=samples_per_proc,
                time_s=t,
            )
        )
    return summaries


def _is_strong_scaling(summaries: list[Summary]) -> bool:
    totals = {s.samples_total for s in summaries}
    return len(totals) == 1


def _md_table(lines: list[list[str]]) -> str:
    if not lines:
        return ""
    header = lines[0]
    sep = ["---"] * len(header)
    rendered = ["| " + " | ".join(header) + " |", "| " + " | ".join(sep) + " |"]
    for row in lines[1:]:
        rendered.append("| " + " | ".join(row) + " |")
    return "\n".join(rendered) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Analyze scaling CSV from run_scaling.py.")
    parser.add_argument("csv", type=Path, help="Input CSV (from run_scaling.py).")
    parser.add_argument("--time-stat", choices=["min", "median"], default="min", help="Aggregate trials per p.")
    parser.add_argument("--out", type=Path, default=None, help="Write a Markdown report to this path.")
    args = parser.parse_args()

    rows = _read_rows(args.csv)
    if not rows:
        raise SystemExit(f"empty CSV: {args.csv}")

    summaries = _summarize(rows, args.time_stat)
    strong = _is_strong_scaling(summaries)

    out_lines: list[str] = []
    out_lines.append(f"# Scaling report: `{args.csv.name}`")
    out_lines.append("")
    out_lines.append(f"- mode: `{summaries[0].mode}`")
    out_lines.append(f"- time statistic: `{args.time_stat}`")
    out_lines.append("")

    if strong:
        t1 = next(s.time_s for s in summaries if s.processes == 1)
        table = [["p", "time_s", "speedup", "efficiency", "karp_flatt_f"]]
        for s in summaries:
            spd = speedup(t1, s.time_s)
            eff = efficiency(t1, s.time_s, s.processes)
            if s.processes == 1:
                f = ""
            else:
                f = f"{karp_flatt_serial_fraction(s.processes, spd):.4f}"
            table.append([str(s.processes), f"{s.time_s:.6f}", f"{spd:.3f}", f"{eff:.3f}", f])
        out_lines.append("## Strong scaling")
        out_lines.append("")
        out_lines.append(_md_table(table))
    else:
        t1 = next(s.time_s for s in summaries if s.processes == 1)
        table = [["p", "samples_total", "time_s", "time_ratio(Tp/T1)", "weak_eff(T1/Tp)"]]
        for s in summaries:
            ratio = s.time_s / t1
            weak_eff = t1 / s.time_s
            table.append(
                [str(s.processes), str(s.samples_total), f"{s.time_s:.6f}", f"{ratio:.3f}", f"{weak_eff:.3f}"]
            )
        out_lines.append("## Weak scaling")
        out_lines.append("")
        out_lines.append(_md_table(table))

    report = "\n".join(out_lines).rstrip() + "\n"
    print(report)

    if args.out is not None:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(report, encoding="utf-8")
        print(f"wrote {args.out}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

