cmake_minimum_required(VERSION 3.20)
project(lab09_cpp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(stats src/stats.cpp)
target_include_directories(stats PUBLIC include)

enable_testing()

if(POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
endif()

include(FetchContent)
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(googletest)

add_executable(stats_tests tests/test_stats.cpp)
target_link_libraries(stats_tests PRIVATE stats GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(stats_tests)
