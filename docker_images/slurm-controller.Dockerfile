FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    openssh-server \
    build-essential \
    cmake \
    python3 python3-pip python3-venv \
    wget curl vim ca-certificates \
    slurm-wlm slurm-wlm-basic-plugins munge \
    && rm -rf /var/lib/apt/lists/*

# basic munge setup
RUN mkdir -p /etc/munge /var/lib/munge /var/log/munge \
    && chown -R root:root /etc/munge /var/lib/munge /var/log/munge

RUN useradd -m -s /bin/bash instructor || true

COPY docker-entrypoint-controller.sh /usr/local/bin/docker-entrypoint-controller.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-controller.sh

EXPOSE 6817 6818 22

CMD ["/usr/local/bin/docker-entrypoint-controller.sh"]
