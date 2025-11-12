#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

echo "Building slurm controller image..."
docker build -t sspa/slurm-controller -f slurm-controller.Dockerfile .

echo "Building slurm worker image..."
docker build -t sspa/slurm-worker -f slurm-worker.Dockerfile .

echo "Building jupyter image..."
docker build -t sspa/jupyter -f jupyter.Dockerfile .

echo "All images built. Use 'docker compose up -d' to start the mini-cluster."
