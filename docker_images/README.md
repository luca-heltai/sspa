This folder contains Dockerfiles and helper scripts to build a small Docker-based Slurm mini-cluster and a Jupyter image for the SSPA course.

Usage:

1. Build images locally:

   ./build_images.sh

2. Start the mini-cluster (requires Docker Compose):

   docker compose up -d

3. Connect to the controller:

   docker compose exec controller bash

Notes:

- These images are minimal and designed for teaching/demo purposes only.
- Running a full Slurm installation in containers is non-trivial; these images aim to emulate a basic controller+worker setup for course exercises.
- After cloning this repository, make the helper scripts executable before running the build:

  chmod +x docker-images/*.sh docker-images/docker-entrypoint-*.sh
