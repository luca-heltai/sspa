FROM python:3.11-slim

# System deps for building/running C++ tests with GoogleTest
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      libgtest-dev \
    && cd /usr/src/gtest && cmake . && make \
    && cp lib/libgtest*.a /usr/local/lib/ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Python tooling (includes pytest)
RUN pip install --no-cache-dir jupyterlab pytest sphinx myst-parser jupyter-book

RUN useradd -m -s /bin/bash student || true
WORKDIR /home/student
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''"]
