#!/bin/bash
set -e

# ensure runtime dirs exist
install -d -o sspa -g sspa -m 0755 /home/sspa
install -d -o root -g munge -m 0750 /etc/munge
install -d -o munge -g munge -m 0755 /var/lib/munge
install -d -o munge -g munge -m 0700 /var/log/munge
touch /var/log/munge/munged.log
chown munge:munge /var/log/munge/munged.log
chmod 0640 /var/log/munge/munged.log

install -d -o slurm -g slurm -m 0755 /etc/slurm-llnl
install -d -o slurm -g slurm -m 0755 /var/spool/slurmd

if [ ! -f /etc/slurm-llnl/slurm.conf ]; then
  cp /usr/local/etc/slurm.conf.template /etc/slurm-llnl/slurm.conf
  chown slurm:slurm /etc/slurm-llnl/slurm.conf
  chmod 0644 /etc/slurm-llnl/slurm.conf
fi

service ssh start || true
service munge start || true

/usr/sbin/slurmd -D -f /etc/slurm-llnl/slurm.conf &

tail -f /dev/null
