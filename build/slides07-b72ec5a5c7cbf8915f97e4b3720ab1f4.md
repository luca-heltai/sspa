# Containers: Docker & Apptainer

----

## Why containers

- Reproducible environments: pin OS, libs, tools; ship once, run anywhere.
- Faster onboarding: `docker run ...` instead of bespoke setup steps.
- Isolation: avoid polluting host; run multiple toolchains side-by-side.
- Today: Dockerfile basics, building/running images, Jupyter in a container, Apptainer on HPC.

----

## Online resources

Docker docs: <https://docs.docker.com/>  
Dockerfile reference: <https://docs.docker.com/engine/reference/builder/>  
Apptainer docs: <https://apptainer.org/docs/>  
Singularity Hub conversion: <https://apptainer.org/docs/user/main/docker_and_oci.html>

----

## Docker 101

- Build image: `docker build -t myapp:latest .`
- Run container: `docker run --rm -it myapp:latest bash`
- Mount host dir: `docker run --rm -v "$PWD":/work -w /work myapp:latest cmd`
- Inspect: `docker images`, `docker ps -a`, `docker system df`
- Clean up: `docker rmi`, `docker rm`, `docker system prune`

----

## Dockerfile essentials

```Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "-m", "main"]
```

- `FROM` defines base; prefer slim/minimal images.
- Layer order matters: install deps before copying volatile code to leverage cache.
- Use explicit versions in `requirements.txt`; avoid `latest`.

----

## Layering and caching tips

- Combine `apt-get update` + install in one `RUN`; clean package lists (`rm -rf /var/lib/apt/lists/*`).
- Separate `COPY` for lockfiles/requirements to maximize cache hits.
- `.dockerignore` to exclude large/unneeded files (venvs, build outputs, data dumps).
- Pin entrypoints: `ENTRYPOINT` for command, `CMD` for defaults.

----

## Running tests inside the image

- Bake test deps into the image (`pytest`, `gtest` libs if needed).
- Add a test stage:  

  ```Dockerfile
  FROM base AS test
  RUN pytest -q
  ```

- CI pattern: `docker build --target test .` to fail early.
- For C++: install `build-essential`, `cmake`, `libgtest-dev`, then compile/link tests.

----

## Jupyter in a container

- Expose port and disable token for local dev:  
  `CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''"]`
- Run with mount: `docker run --rm -p 8888:8888 -v "$PWD":/work -w /work myjupyter`.
- Keep images light: avoid storing notebooks outputs; rely on host volume for data.

----

## Docker compose

- Declare services/volumes/ports once instead of long CLI commands.
- Repeatable dev environments for teams; `docker compose up` brings everything up.
- Easier to add dependencies (db/cache) next to Jupyter or apps.
- Version your `compose.yml` in git; document defaults via `environment` and `ports`.

----

## Translating the Jupyter run command

CLI we had:  
`docker run --rm -p 8888:8888 -v "$PWD":/work -w /work myjupyter`

Equivalent `compose.yml` service:  

```yaml
services:
  jupyter:
    image: myjupyter
    ports:
      - "8888:8888"
    working_dir: /work
    volumes:
      - ./:/work
    command:
      - jupyter
      - lab
      - --ip=0.0.0.0
      - --no-browser
      - "--NotebookApp.token=''"
```

Run it: `docker compose up` (add `-d` to detach). Stop with `docker compose down`.

----

## Compose tips

- Pin Compose file version if needed: `version: "3.9"` (optional for v2+).
- Add environment defaults:  
  `environment: ["PYTHONUNBUFFERED=1"]`.
- Use named volumes for persistence:  
  `volumes: { notebooks: {} }` and mount `notebooks:/work`.
- Override command/ports for one-off sessions: `docker compose run --service-ports jupyter bash`.

----

## VS Code + containers

- Keep IDE and runtime consistent: same Python/compilers/libraries as the image.
- Avoid host pollution; newcomers open the repo and get a ready dev environment.
- Works cross-platform; only Docker and VS Code needed locally.

----

## Option 1: Remote - Containers extension

- Install VS Code extension “Dev Containers” (ms-vscode-remote.remote-containers).
- Add `.devcontainer/devcontainer.json` pointing to your Dockerfile or compose service.
- Open folder in container: VS Code rebuilds/starts the container and attaches with the same source tree mounted.
- Configure extensions and settings inside `devcontainer.json` (e.g., Python, C++ tools).

----

## Minimal devcontainer.json (pre-built image)

```json
{
  "name": "VWCE dev",
  "image": "myjupyter:latest",
  "workspaceFolder": "/work",
  "mounts": ["source=${localWorkspaceFolder},target=/work,type=bind"]
}
```

- Swap `image` with your tag; add optional `remoteUser` if the image defines one.

----

## Using docker compose with VS Code

- Point `dockerComposeFile` to `compose.yml` and `service` to the app:  

  ```json
  {
    "dockerComposeFile": "compose.yml",
    "service": "jupyter",
    "workspaceFolder": "/work",
    "shutdownAction": "stopCompose"
  }
  ```

- VS Code will `docker compose up` the service and attach; ports/volumes follow the compose config.
- Great for multi-service stacks (db + app + jupyter) with one “Open in Container” action.

----

## Apptainer (Singularity) for HPC

- User-space containers; no root required on cluster nodes.
- Build locally from Docker/OCI: `apptainer build app.sif docker-daemon://myapp:latest`
- Run on HPC: `apptainer exec app.sif python -m main`; bind paths with `-B /path`.
- Good for reproducibility on systems without Docker daemon.

----

## Security and reproducibility

- Avoid running as root inside containers; create a non-root user (`useradd`, `USER`).
- Verify sources and checksums for downloads; pin package versions.
- Keep images small (multi-stage builds, slim bases) and rebuild regularly to pick up patches.
- Store Dockerfiles in repo; document build/run commands in README/Makefile.

----

## Lab 07 outline

- Containerize the Lecture 6 Python VWCE example: write a Dockerfile from scratch.
- Install Python deps (`pytest`), copy code, and set an entrypoint to run the script.
- Add a test stage/target that runs `pytest` on the included suite.
- Build the image, run the CLI and tests in containers, and (optionally) produce an Apptainer `.sif` from the Docker image for HPC use.
