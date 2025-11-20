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
install -d -o slurm -g slurm -m 0755 /slurm-config

if [ ! -f /etc/slurm-llnl/slurm.conf ]; then
  cp /usr/local/etc/slurm.conf.template /etc/slurm-llnl/slurm.conf
  chown slurm:slurm /etc/slurm-llnl/slurm.conf
  chmod 0644 /etc/slurm-llnl/slurm.conf
fi

node_name="$(hostname -s)"
node_conf_tmp="$(mktemp)"
SLURM_NODE_CPUS="${SLURM_NODE_CPUS:-4}"
SLURM_NODE_REAL_MEMORY_MB="${SLURM_NODE_REAL_MEMORY_MB:-4096}"
SLURM_NODE_SOCKETS="${SLURM_NODE_SOCKETS:-1}"
SLURM_NODE_THREADS_PER_CORE="${SLURM_NODE_THREADS_PER_CORE:-1}"
SLURM_NODE_CORES_PER_SOCKET="${SLURM_NODE_CORES_PER_SOCKET:-$SLURM_NODE_CPUS}"
SLURM_NODE_STATE="${SLURM_NODE_STATE:-UNKNOWN}"

cat > "$node_conf_tmp" <<EOF
NodeName=${node_name} CPUs=${SLURM_NODE_CPUS} Sockets=${SLURM_NODE_SOCKETS} CoresPerSocket=${SLURM_NODE_CORES_PER_SOCKET} ThreadsPerCore=${SLURM_NODE_THREADS_PER_CORE} RealMemory=${SLURM_NODE_REAL_MEMORY_MB} State=${SLURM_NODE_STATE}
EOF
mv "$node_conf_tmp" "/slurm-config/${node_name}.conf"
chown slurm:slurm "/slurm-config/${node_name}.conf"
chmod 0644 "/slurm-config/${node_name}.conf"

service ssh start || true
service munge start || true

/usr/sbin/slurmd -D -f /etc/slurm-llnl/slurm.conf &

tail -f /dev/null
