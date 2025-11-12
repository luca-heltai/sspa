FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV WORK=/work
ENV SCRATCH=/scratch

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 python3-pip \
    slurm-wlm munge openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/munge /var/lib/munge /var/log/munge /etc/slurm-llnl \
    && chown root:munge /etc/munge \
    && chmod 0750 /etc/munge \
    && chown munge:munge /var/lib/munge /var/log/munge \
    && chmod 0755 /var/lib/munge \
    && chmod 0700 /var/log/munge \
    && touch /var/log/munge/munged.log \
    && chown munge:munge /var/log/munge/munged.log \
    && chmod 0640 /var/log/munge/munged.log \
    && chown -R slurm:slurm /etc/slurm-llnl

RUN useradd -m -s /bin/bash sspa || true \
    && echo 'sspa:sspa-password' | chpasswd

RUN printf 'export WORK=/work\nexport SCRATCH=/scratch\n' > /etc/profile.d/sspa_paths.sh \
    && chmod 0644 /etc/profile.d/sspa_paths.sh

RUN printf 'export SLURM_CONF=/etc/slurm-llnl/slurm.conf\n' > /etc/profile.d/slurm_conf.sh \
    && chmod 0644 /etc/profile.d/slurm_conf.sh

RUN usermod -aG sudo sspa \
    && printf 'sspa ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/zz-sspa \
    && chmod 0440 /etc/sudoers.d/zz-sspa

COPY slurm.conf /usr/local/etc/slurm.conf.template
RUN cp /usr/local/etc/slurm.conf.template /etc/slurm-llnl/slurm.conf \
    && chown slurm:slurm /etc/slurm-llnl/slurm.conf \
    && chmod 0644 /etc/slurm-llnl/slurm.conf

COPY docker-entrypoint-worker.sh /usr/local/bin/docker-entrypoint-worker.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-worker.sh

EXPOSE 6818 22

CMD ["/usr/local/bin/docker-entrypoint-worker.sh"]
