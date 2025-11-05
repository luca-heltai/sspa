# Introduction

### Scientific Software Tools and Parallel Algorithms

PhD in *High Performance Scientific Computing* (**HPSC**)

Luca Heltai  (<luca.heltai@unipi.it>)

Academic Year: 2025–2026

-----

## Why *SSPA*?  

### Lessons learned from 25 years of development of the [`deal.II`](www.dealii.org) library

- **Modern, collaborative, workflows** – Git, CI, containers, docs.
- **Reproducible research** – code that runs everywhere.  
- **Scalable simulations** – get speed‑ups from 1 CPU → 1 k CPUs.  

-----

## 5‑Weeks

| Week | Focus | Key Tools |
|--------|---------|--------------|
| 1 | Unix shell + Slurm | Bash, SSH, Slurm |
| 2 | Version control | Git, GitHub |
| 3 | Documentation & testing | Doxygen, Sphinx, pytest / gtest |
| 4 | Containers & CI | Docker / Apptainer, GitHub Actions |
| 5 | Parallel algorithms | Amdahl/Gustafson, MPI/OpenMP |

-----

## What You’ll Build  

| Outcome | How |
|------------|------|
| **Portable repo** | Git, Dockerfile, CI pipeline |
| **Automated docs** | Sphinx → website |
| **Robust tests** | pytest / gtest + CI |
| **Fast code** | Parallel demo, profiling |

-----

## Hands‑On Labs  

- **Bash scripts** that launch jobs on a mini‑cluster.  
- **Git PRs** – merge‑conflict playground.  
- **Docker build** → run on an HPC node.  
- **Parallel programming crash course** – 1→8 cores for π Monte‑Carlo.

-----

# Preliminary steps

-----

# Tools to install

**Quick start list** – these are the essential tools you’ll need before the labs begin.

---

# Visual Studio Code

- Lightweight, highly extensible IDE  
- Install on Ubuntu: `sudo snap install --classic code`  
- Or download from <https://code.visualstudio.com/>

---

# OpenSSH

- Secure remote login to the cluster (and to Docker containers)  
- Install: `sudo apt install openssh-client openssh-server`

---

# Git

- Version control, branch/PR workflow  
- Install: `sudo apt install git`

---

# Docker

- Build & run containers locally and on the cluster  
- Install: `sudo apt install docker.io`  
- Or follow the official guide: <https://docs.docker.com/engine/install/>

**Tip** – Add your user to the `docker` group so you can run containers without `sudo`:  

```bash

sudo usermod -aG docker $USER

```

and then log‑out / back‑in.

-----

## Set Up a GitHub Account & SSH‑Key Auth  

**No passwords, just key‑based login**

1. **Create a GitHub account** – <https://github.com/join>  

---

2. **Generate a new SSH key** (leave the passphrase empty for painless CI)  

```bash

ssh-keygen -t ed25519 -C "your_email@example.com"
# default: ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

```

---

## Add Your SSH Key to GitHub

1. **Copy your public key**  

  ```bash

  cat ~/.ssh/id_ed25519.pub
  
  ```  

  *Copy the whole output to your clipboard.*

2. **Log in to GitHub**  
  Open <https://github.com> and go to **Settings** → **SSH and GPG keys**.

---

3. **Create a new key**  

- Click **New SSH key**  
- Give it a descriptive title (e.g., *Laptop – 2025*)  
- Paste the key you copied into the **Key** field.

4. **Save**  

- Click **Add SSH key** – you may be asked to re‑enter your GitHub password.

---

5. **Verify**  

  ```bash

  ssh -T git@github.com
  
  ```  

  You should see:  
  > *Hi `your‑username`! You've successfully authenticated, but GitHub does not provide shell access.*

---

6. **Optional – Force SSH for Git**  

```bash

git config --global url."git@github.com:".insteadOf "https://github.com/"

```

-----

## Configure git

   1. **Set your user identity**  

      ```bash
      git config --global user.name "Your Full Name"
      git config --global user.email "you@example.com"
      ```

---

   2. **Choose a default editor** (optional)  

      ```bash
      git config --global core.editor "code --wait"
      ```

---

   3. **Enable color output**  

      ```bash
      git config --global color.ui auto
      ```

---

   4. **Show a friendly status prompt**  

      ```bash
      git config --global status.showUntrackedFiles all
      ```

---

   6. **Verify the config**  

      ```bash
      git config --list --show-origin
      ```

---

   > **Tip:**  
   > • Use `git config --global --edit` to manually tweak the `~/.gitconfig`.  
   > • If you work on multiple accounts, set a local config per repository (`git config user.name …` inside that repo).

   -----
   *With these settings, your Git history will always show the correct author, and the command line will feel a lot friendlier.*

-----

## Next Steps  

1. Clone the course repo: `git clone git@github.com:luca-heltai/sspa.git`  
2. Explore around
