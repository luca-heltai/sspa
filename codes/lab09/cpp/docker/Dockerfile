FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
COPY . .

# Image provides the build environment only; CI builds/tests the project.
CMD ["bash"]
