FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
COPY . .

RUN cmake -S . -B build \
    && cmake --build build

CMD ["ctest", "--test-dir", "build", "--output-on-failure"]
