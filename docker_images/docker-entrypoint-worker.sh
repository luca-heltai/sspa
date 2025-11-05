#!/bin/bash
set -e

service ssh start || true
service munge start || true

if [ ! -f /etc/slurm-llnl/slurm.conf ]; then
  echo "Waiting for controller to provide slurm.conf..."
  # simple wait loop; in compose we mount same config via volume in controller normally
  sleep 2
fi

/usr/sbin/slurmd -D -f /etc/slurm-llnl/slurm.conf &

tail -f /dev/null
