from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class ScalingPoint:
    processes: int
    time_s: float


def speedup(t1: float, tp: float) -> float:
    if t1 <= 0 or tp <= 0:
        raise ValueError("times must be > 0")
    return t1 / tp


def efficiency(t1: float, tp: float, p: int) -> float:
    if p < 1:
        raise ValueError("p must be >= 1")
    return speedup(t1, tp) / float(p)


def amdahl_speedup(p: int, serial_fraction: float) -> float:
    if p < 1:
        raise ValueError("p must be >= 1")
    if not (0.0 <= serial_fraction <= 1.0):
        raise ValueError("serial_fraction must be in [0, 1]")
    return 1.0 / (serial_fraction + (1.0 - serial_fraction) / float(p))


def gustafson_speedup(p: int, serial_fraction: float) -> float:
    if p < 1:
        raise ValueError("p must be >= 1")
    if not (0.0 <= serial_fraction <= 1.0):
        raise ValueError("serial_fraction must be in [0, 1]")
    return float(p) - serial_fraction * float(p - 1)


def karp_flatt_serial_fraction(p: int, measured_speedup: float) -> float:
    if p <= 1:
        raise ValueError("p must be > 1")
    if measured_speedup <= 0:
        raise ValueError("measured_speedup must be > 0")
    inv_s = 1.0 / measured_speedup
    inv_p = 1.0 / float(p)
    return (inv_s - inv_p) / (1.0 - inv_p)

