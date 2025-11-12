#include <chrono>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <random>
#include <string>
#include <vector>

using Clock = std::chrono::high_resolution_clock;

std::size_t parse_size(char **begin, char **end) {
  const std::string flag = "--size";
  for (auto it = begin; it != end; ++it) {
    if (*it && flag == *it && (it + 1) != end) {
      return static_cast<std::size_t>(std::stoll(*(it + 1)));
    }
  }
  return 50'000'000; // default elements (~400 MB traffic)
}

int main(int argc, char **argv) {
  std::size_t n = parse_size(argv, argv + argc);
  std::vector<double> a(n), b(n), c(n);

  std::mt19937_64 rng(42);
  std::uniform_real_distribution<double> dist(0.0, 1.0);
  for (std::size_t i = 0; i < n; ++i) {
    a[i] = dist(rng);
    b[i] = dist(rng);
  }

  auto start = Clock::now();
  for (std::size_t i = 0; i < n; ++i) {
    c[i] = a[i] + b[i];
  }
  auto stop = Clock::now();

  double seconds = std::chrono::duration<double>(stop - start).count();
  double bytes = static_cast<double>(n) * 3.0 * sizeof(double);
  double bandwidth = (bytes / seconds) / 1.0e9; // GB/s

  double checksum = 0.0;
  for (double v : c) {
    checksum += v;
  }

  std::cout << "Elements: " << n << '\n'
            << "Elapsed (s): " << std::fixed << std::setprecision(6) << seconds << '\n'
            << "Effective bandwidth (GB/s): " << std::setprecision(3) << bandwidth << '\n'
            << "Checksum: " << std::setprecision(10) << checksum << std::endl;
  return 0;
}
