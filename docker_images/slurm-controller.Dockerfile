FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV WORK=/work
ENV SCRATCH=/scratch

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
# munge runtime dirs must be writable by the munge user; prep slurm config dir too
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
RUN mkdir -p /var/log/slurm \
    && chown slurm:slurm /var/log/slurm \
    && touch /var/log/slurm/slurm_jobacct.log \
    && touch /var/log/slurm/accounting \
    && chown slurm:slurm /var/log/slurm/slurm_jobacct.log /var/log/slurm/accounting \
    && chmod 0644 /var/log/slurm/slurm_jobacct.log /var/log/slurm/accounting

RUN useradd -m -s /bin/bash sspa || true \
    && echo 'sspa:sspa-password' | chpasswd

RUN printf 'export WORK=/work\nexport SCRATCH=/scratch\n' > /etc/profile.d/sspa_paths.sh \
    && chmod 0644 /etc/profile.d/sspa_paths.sh

RUN printf 'export SLURM_CONF=/etc/slurm-llnl/slurm.conf\n' > /etc/profile.d/slurm_conf.sh \
    && chmod 0644 /etc/profile.d/slurm_conf.sh

COPY slurm.conf /usr/local/etc/slurm.conf.template
RUN cp /usr/local/etc/slurm.conf.template /etc/slurm-llnl/slurm.conf \
    && chown slurm:slurm /etc/slurm-llnl/slurm.conf \
    && chmod 0644 /etc/slurm-llnl/slurm.conf

COPY cgroup.conf /etc/slurm-llnl/cgroup.conf
RUN chown slurm:slurm /etc/slurm-llnl/cgroup.conf \
    && chmod 0644 /etc/slurm-llnl/cgroup.conf

COPY docker-entrypoint-controller.sh /usr/local/bin/docker-entrypoint-controller.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-controller.sh

RUN usermod -aG sudo sspa \
    && printf 'sspa ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/zz-sspa \
    && chmod 0440 /etc/sudoers.d/zz-sspa

EXPOSE 6817 6818 22

CMD ["/usr/local/bin/docker-entrypoint-controller.sh"]
