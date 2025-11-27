FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       git \
       graphviz \
       make \
       python3 \
       python3-venv \
       python3-pip \
       doxygen \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir \
        sphinx \
        myst-parser \
        sphinx-autobuild \
        sphinx-rtd-theme \
        breathe

ENV PATH="/opt/venv/bin:${PATH}"

WORKDIR /workspace

CMD ["bash"]
