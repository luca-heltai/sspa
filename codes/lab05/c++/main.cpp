#include <algorithm>
#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct PricePoint
{
  std::string date;
  double      open{};
  double      high{};
  double      low{};
  double      close{};
  double      adj_close{};
  long        volume{};
};

struct Drawdown
{
  double      value{};
  std::string start_date;
  std::string end_date;
};

std::vector<PricePoint>
load_prices(const std::string &path)
{
  std::ifstream in(path);
  if (!in)
    {
      throw std::runtime_error("Cannot open file: " + path);
    }

  std::vector<PricePoint> data;
  std::string             line;

  // Skip header
  std::getline(in, line);

  while (std::getline(in, line))
    {
      std::stringstream ss(line);
      std::string       cell;
      PricePoint        p;
      std::getline(ss, p.date, ',');
      std::getline(ss, cell, ',');
      p.open = std::stod(cell);
      std::getline(ss, cell, ',');
      p.high = std::stod(cell);
      std::getline(ss, cell, ',');
      p.low = std::stod(cell);
      std::getline(ss, cell, ',');
      p.close = std::stod(cell);
      std::getline(ss, cell, ',');
      p.adj_close = std::stod(cell);
      std::getline(ss, cell, ',');
      p.volume = std::stol(cell);
      data.push_back(p);
    }
  return data;
}

double
mean(const std::vector<double> &values)
{
  double sum = 0.0;
  for (double v : values)
    sum += v;
  return values.empty() ? 0.0 : sum / static_cast<double>(values.size());
}

double
variance(const std::vector<double> &values)
{
  if (values.size() < 2)
    return 0.0;
  const double m     = mean(values);
  double       accum = 0.0;
  for (double v : values)
    {
      const double diff = v - m;
      accum += diff * diff;
    }
  return accum / static_cast<double>(values.size() - 1);
}

std::vector<double>
daily_returns(const std::vector<PricePoint> &prices)
{
  std::vector<double> r;
  for (std::size_t i = 1; i < prices.size(); ++i)
    {
      double prev = prices[i - 1].close;
      double curr = prices[i].close;
      r.push_back((curr - prev) / prev);
    }
  return r;
}

double
annualized_return(const std::vector<double> &daily)
{
  if (daily.empty())
    return 0.0;
  const double avg = mean(daily);
  return std::pow(1.0 + avg, 252.0) - 1.0;
}

Drawdown
max_drawdown(const std::vector<PricePoint> &prices)
{
  double      peak   = -1e18;
  double      max_dd = 0.0;
  std::string peak_date;
  std::string trough_date;

  for (const auto &p : prices)
    {
      if (p.close > peak)
        {
          peak      = p.close;
          peak_date = p.date;
        }
      double dd = (peak - p.close) / peak;
      if (dd > max_dd)
        {
          max_dd      = dd;
          trough_date = p.date;
        }
    }

  return {max_dd, peak_date, trough_date};
}

void
write_gnuplot_series(const std::vector<PricePoint> &prices,
                     const Drawdown                &dd,
                     const std::string             &out_path)
{
  std::ofstream out(out_path);
  if (!out)
    throw std::runtime_error("Cannot write file: " + out_path);

  out << "# date index close running_peak drawdown\n";
  double running_peak = -1e18;
  for (std::size_t i = 0; i < prices.size(); ++i)
    {
      running_peak    = std::max(running_peak, prices[i].close);
      double drawdown = (running_peak - prices[i].close) / running_peak;
      out << prices[i].date << " " << i << " " << prices[i].close << " "
          << running_peak << " " << drawdown << "\n";
    }

  std::cout << "Gnuplot-ready series written to " << out_path << "\n";
  std::cout << "Example plot command:\n"
            << "  gnuplot -e \"set xdata time; set timefmt '%Y-%m-%d'; "
            << "plot '" << out_path << "' using 1:3 with lines title 'Close', "
            << "'" << out_path << "' using 1:5 with lines title 'Drawdown'\""
            << std::endl;
}

int
main(int argc, char **argv)
{
  const std::string csv_path = (argc > 1) ? argv[1] : "../vwce_2024.csv";

  try
    {
      auto prices = load_prices(csv_path);
      if (prices.size() < 2)
        {
          std::cerr << "Not enough data points.\n";
          return 1;
        }

      std::vector<double> closes;
      closes.reserve(prices.size());
      for (const auto &p : prices)
        closes.push_back(p.close);

      const auto   returns          = daily_returns(prices);
      const double avg_close        = mean(closes);
      const double var_close        = variance(closes);
      const double avg_daily_return = mean(returns);
      const double ann_return       = annualized_return(returns);
      const double volatility       = std::sqrt(variance(returns) * 252.0);
      const auto   dd               = max_drawdown(prices);

      std::cout << std::fixed << std::setprecision(4);
      std::cout << "Data points: " << prices.size() << "\n";
      std::cout << "Average close: " << avg_close << "\n";
      std::cout << "Close variance: " << var_close << "\n";
      std::cout << "Avg daily return: " << avg_daily_return << "\n";
      std::cout << "Annualized return: " << ann_return << "\n";
      std::cout << "Annualized volatility: " << volatility << "\n";
      std::cout << "Max drawdown: " << dd.value << " (from " << dd.start_date
                << " to " << dd.end_date << ")\n";

      write_gnuplot_series(prices, dd, "vwce_gnuplot.dat");
    }
  catch (const std::exception &e)
    {
      std::cerr << "Error: " << e.what() << "\n";
      return 1;
    }

  return 0;
}
