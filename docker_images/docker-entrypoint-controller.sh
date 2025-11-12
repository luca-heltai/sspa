#!/bin/bash
set -e

# ensure runtime dirs exist (volumes may override image defaults)
install -d -o sspa -g sspa -m 0755 /home/sspa
install -d -o root -g munge -m 0750 /etc/munge
install -d -o munge -g munge -m 0755 /var/lib/munge
install -d -o munge -g munge -m 0750 /var/log/munge
touch /var/log/munge/munged.log
chown munge:munge /var/log/munge/munged.log
chmod 0640 /var/log/munge/munged.log

install -d -o slurm -g slurm -m 0755 /etc/slurm-llnl
install -d -o slurm -g slurm -m 0755 /var/spool/slurm
install -d -o slurm -g slurm -m 0755 /var/spool/slurm/state
install -d -o slurm -g slurm -m 0755 /var/spool/slurmd
for state_file in node_state job_state resv_state trigger_state; do
  touch "/var/spool/slurm/${state_file}"
  chown slurm:slurm "/var/spool/slurm/${state_file}"
  chmod 0644 "/var/spool/slurm/${state_file}"
done

# create a minimal munge key if none exists
if [ ! -f /etc/munge/munge.key ]; then
  dd if=/dev/urandom of=/etc/munge/munge.key bs=1 count=1024
  chown munge:munge /etc/munge/munge.key || true
  chmod 400 /etc/munge/munge.key || true
fi

# start ssh
service ssh start || true

# start munge
service munge start || true

# generate a basic slurm.conf if missing
if [ ! -f /etc/slurm-llnl/slurm.conf ]; then
  cp /usr/local/etc/slurm.conf.template /etc/slurm-llnl/slurm.conf
  chown slurm:slurm /etc/slurm-llnl/slurm.conf
  chmod 0644 /etc/slurm-llnl/slurm.conf
fi

# start slurm controller
/usr/sbin/slurmctld -D -f /etc/slurm-llnl/slurm.conf &

tail -f /dev/null
