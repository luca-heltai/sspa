# Lecture 1

## Introduction to shells and ssh

---

```bash
ls -alh 
```

--

# Week 1 – Introduction to Shell and SLURM

## 🧮 Welcome to SSPA

### Scientific Software Tools and Parallel Algorithms

PhD Course in High Performance Scientific Computing  
Instructor: Luca Heltai  
Academic Year: 2025–2026

---

## 🧾 What We'll Learn Today

- Bash shell basics
- Linux environment for HPC
- What is a job scheduler?
- SLURM: concepts and commands
- Submitting your first job

---

## 🐚 What is a Shell?

- A program that interprets user commands
- Common shell: `bash` (Bourne Again SHell)
- Provides:
  - File navigation
  - Program execution
  - Scripting for automation

---

## ⚙️ Shell Basics

~~~bash
# Navigate
pwd           # print working directory
cd /tmp       # change directory

# Files
ls -l         # list files
touch file.txt
nano file.txt # edit

# Permissions
chmod +x script.sh

# Environment
echo $HOME
~~~

      </textarea>
    </section>
  </div>
</div>

<noscript>
  <p><strong>Slides preview unavailable:</strong> enable JavaScript to view the interactive deck. The raw markdown is stored in <code>slides/slides01.md</code>.</p>
</noscript>

<script src="../_static/reveal.js/dist/reveal.js"></script>
<script src="../_static/reveal.js/plugin/markdown/markdown.js"></script>
<script src="../_static/reveal.js/plugin/highlight/highlight.js"></script>
<script>
  Reveal.initialize({
    hash: true,
    center: false,
    controls: true,
    progress: true,
    slideNumber: true,
    plugins: [ RevealMarkdown, RevealHighlight ]
  });
</script>

```

# Slide 1 – Title

   Welcome to a **slide deck** inside a Jupyter Book!

# Week 1 – Introduction to Shell and SLURM

## 🧮 Welcome to SSPA

### Scientific Software Tools and Parallel Algorithms

PhD Course in High Performance Scientific Computing  
Instructor: Luca Heltai  
Academic Year: 2025–2026

---

## 🧾 What We'll Learn Today

- Bash shell basics
- Linux environment for HPC
- What is a job scheduler?
- SLURM: concepts and commands
- Submitting your first job

---

## 🐚 What is a Shell?

- A program that interprets user commands
- Common shell: `bash` (Bourne Again SHell)
- Provides:
  - File navigation
  - Program execution
  - Scripting for automation

---

## ⚙️ Shell Basics

~~~bash
# Navigate
pwd           # print working directory
cd /tmp       # change directory

# Files
ls -l         # list files
touch file.txt
nano file.txt # edit

# Permissions
chmod +x script.sh

# Environment
echo $HOME
~~~

      </textarea>
    </section>
  </div>
</div>

<noscript>
  <p><strong>Slides preview unavailable:</strong> enable JavaScript to view the interactive deck. The raw markdown is stored in <code>slides/slides01.md</code>.</p>
</noscript>

<script src="../_static/reveal.js/dist/reveal.js"></script>
<script src="../_static/reveal.js/plugin/markdown/markdown.js"></script>
<script src="../_static/reveal.js/plugin/highlight/highlight.js"></script>
<script>
  Reveal.initialize({
    hash: true,
    center: false,
    controls: true,
    progress: true,
    slideNumber: true,
    plugins: [ RevealMarkdown, RevealHighlight ]
  });
</script>

```
