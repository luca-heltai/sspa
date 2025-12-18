#include "stats.hpp"

#include <cmath>

#include <gtest/gtest.h>

TEST(Stats, MeanStdSimple) {
    const std::vector<double> values{1.0, 2.0, 3.0};
    const auto [mean, stddev] = mean_std(values);
    EXPECT_DOUBLE_EQ(mean, 2.0);
    EXPECT_NEAR(stddev, std::sqrt(2.0 / 3.0), 1e-12);
}

TEST(Stats, MeanStdEmpty) {
    EXPECT_THROW(mean_std({}), std::invalid_argument);
}
