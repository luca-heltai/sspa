import argparse
import csv
import math
from dataclasses import dataclass
from pathlib import Path
from typing import List


@dataclass
class PricePoint:
    date: str
    open: float
    high: float
    low: float
    close: float
    adj_close: float
    volume: int


def load_prices(path: Path) -> List[PricePoint]:
    rows: List[PricePoint] = []
    with path.open() as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append(
                PricePoint(
                    date=row["Date"],
                    open=float(row["Open"]),
                    high=float(row["High"]),
                    low=float(row["Low"]),
                    close=float(row["Close"]),
                    adj_close=float(row["Adj Close"]),
                    volume=int(row["Volume"]),
                )
            )
    return rows


def mean(values: List[float]) -> float:
    return sum(values) / len(values) if values else 0.0


def variance(values: List[float]) -> float:
    if len(values) < 2:
        return 0.0
    m = mean(values)
    return sum((v - m) ** 2 for v in values) / (len(values) - 1)


def daily_returns(prices: List[PricePoint]) -> List[float]:
    returns: List[float] = []
    for prev, curr in zip(prices, prices[1:]):
        returns.append((curr.close - prev.close) / prev.close)
    return returns


def annualized_return(daily: List[float]) -> float:
    if not daily:
        return 0.0
    avg = mean(daily)
    return (1.0 + avg) ** 252 - 1.0


def max_drawdown(prices: List[PricePoint]):
    peak = float("-inf")
    max_dd = 0.0
    peak_date = ""
    trough_date = ""

    for p in prices:
        if p.close > peak:
            peak = p.close
            peak_date = p.date
        dd = (peak - p.close) / peak
        if dd > max_dd:
            max_dd = dd
            trough_date = p.date

    return max_dd, peak_date, trough_date


def write_gnuplot_series(prices: List[PricePoint], out_path: Path) -> None:
    running_peak = float("-inf")
    with out_path.open("w") as f:
        f.write("# date index close running_peak drawdown\n")
        for idx, p in enumerate(prices):
            running_peak = max(running_peak, p.close)
            drawdown = (running_peak - p.close) / running_peak
            f.write(f"{p.date} {idx} {p.close} {running_peak} {drawdown}\n")


def main():
    parser = argparse.ArgumentParser(
        description="VWCE 2024 stats and gnuplot series"
    )
    parser.add_argument(
        "--csv",
        default="../vwce_2024.csv",
        type=Path,
        help="Path to CSV with columns Date,Open,High,Low,Close,Adj Close,Volume",
    )
    parser.add_argument(
        "--out",
        default=Path("vwce_gnuplot.dat"),
        type=Path,
        help="Output data file for gnuplot",
    )
    args = parser.parse_args()

    prices = load_prices(args.csv)
    if len(prices) < 2:
        raise SystemExit("Not enough data points")

    closes = [p.close for p in prices]
    rets = daily_returns(prices)

    avg_close = mean(closes)
    var_close = variance(closes)
    avg_daily = mean(rets)
    ann_return = annualized_return(rets)
    volatility = math.sqrt(variance(rets) * 252)
    dd, dd_start, dd_end = max_drawdown(prices)

    print(f"Data points: {len(prices)}")
    print(f"Average close: {avg_close:.4f}")
    print(f"Close variance: {var_close:.4f}")
    print(f"Avg daily return: {avg_daily:.4f}")
    print(f"Annualized return: {ann_return:.4f}")
    print(f"Annualized volatility: {volatility:.4f}")
    print(f"Max drawdown: {dd:.4f} (from {dd_start} to {dd_end})")

    write_gnuplot_series(prices, args.out)
    print(f"Gnuplot-ready series written to {args.out}")
    print(
        "Example: gnuplot -e \"set xdata time; set timefmt '%Y-%m-%d'; "
        f"plot '{args.out}' using 1:3 with lines title 'Close', "
        f"'{args.out}' using 1:5 with lines title 'Drawdown'\""
    )


if __name__ == "__main__":
    main()
