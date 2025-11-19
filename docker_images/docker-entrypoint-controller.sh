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
install -d -o slurm -g slurm -m 0755 /var/log/slurm
install -d -o slurm -g slurm -m 0755 /slurm-config

# wipe stale state artifacts from bind-mounted volume (files, dirs, sockets, etc.)
find /var/spool/slurm -mindepth 1 -maxdepth 1 -exec rm -rf {} +

touch /var/log/slurm/slurm_jobacct.log /var/log/slurm/accounting
chown slurm:slurm /var/log/slurm/slurm_jobacct.log /var/log/slurm/accounting
chmod 0644 /var/log/slurm/slurm_jobacct.log /var/log/slurm/accounting
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

IFS=',' read -ra slurm_nodes <<< "${SLURM_NODE_LIST:-worker1,worker2}"
node_files=()
for raw_node in "${slurm_nodes[@]}"; do
  node="$(echo "$raw_node" | tr -d '[:space:]')"
  [ -z "$node" ] && continue
  node_file="/slurm-config/${node}.conf"
  echo "Waiting for node description at ${node_file}"
  until [ -s "$node_file" ]; do
    sleep 1
  done
  node_files+=("$node_file")
done

nodes_tmp="$(mktemp)"
for node_file in "${node_files[@]}"; do
  cat "$node_file" >> "$nodes_tmp"
  printf '\n' >> "$nodes_tmp"
done
mv "$nodes_tmp" /slurm-config/nodes.conf
chown slurm:slurm /slurm-config/nodes.conf
chmod 0644 /slurm-config/nodes.conf

# start slurm controller
/usr/sbin/slurmctld -D -f /etc/slurm-llnl/slurm.conf &

tail -f /dev/null
