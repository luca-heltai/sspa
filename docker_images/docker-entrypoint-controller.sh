#!/bin/bash
set -e

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
  cat > /etc/slurm-llnl/slurm.conf <<'EOF'
ControlMachine=controller
MpiDefault=none
ProctrackType=proctrack/pgid
ReturnToService=2
SlurmUser=slurm
StateSaveLocation=/var/spool/slurm
SlurmdSpoolDir=/var/spool/slurm
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmdPidFile=/var/run/slurmd.pid
SlurmctldPort=6817
SlurmdPort=6818
AuthType=auth/munge
SchedulerType=sched/backfill
SelectType=select/cons_res
SelectTypeParameters=CR_Core

NodeName=worker[1-2] CPUs=2 State=UNKNOWN
PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
EOF
fi

# start slurm controller
/usr/sbin/slurmctld -D -f /etc/slurm-llnl/slurm.conf &

tail -f /dev/null
