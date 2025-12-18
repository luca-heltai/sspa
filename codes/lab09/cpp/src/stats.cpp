#include "stats.hpp"

#include <cmath>
#include <numeric>
#include <stdexcept>

std::pair<double, double> mean_std(const std::vector<double> &values) {
    if (values.empty()) {
        throw std::invalid_argument("mean_std expects at least one value");
    }

    const double sum = std::accumulate(values.begin(), values.end(), 0.0);
    const double mean = sum / static_cast<double>(values.size());

    double variance = 0.0;
    for (double value : values) {
        const double diff = value - mean;
        variance += diff * diff;
    }
    variance /= static_cast<double>(values.size());

    return {mean, std::sqrt(variance)};
}
