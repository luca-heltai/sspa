FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 python3-pip \
    slurm-wlm munge openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash instructor || true

COPY docker-entrypoint-worker.sh /usr/local/bin/docker-entrypoint-worker.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-worker.sh

EXPOSE 6818 22

CMD ["/usr/local/bin/docker-entrypoint-worker.sh"]
