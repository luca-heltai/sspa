An Introduction to Scientific Software Tools and Parallel Algorithms (SSPA)
Course Overview

Course Description: This PhD-level course provides a comprehensive introduction to essential tools and practices for High Performance Scientific Computing (HPC). We will cover a broad spectrum of topics, from fundamental software tools to parallel algorithm design. Students will become familiar with basic Unix shell and GNU/Linux usage, including scripting and remote cluster interaction, and learn how batch job schedulers like Slurm manage workloads on HPC systems
hpc-wiki.info
. The course then introduces modern software development practices: using Git for version control (both individual and collaborative workflows), generating code documentation automatically with Doxygen (for C/C++ projects) and Sphinx (for Python or general documentation), and implementing unit and functional testing with Google Test (gtest) for C++
en.wikipedia.org
 and pytest for Python
docs.pytest.org
. We explore containerization using Docker and Apptainer (formerly Singularity) to ensure software portability and reproducibility across environments
apptainer.org
apptainer.org
. The course also covers continuous integration (CI) tools (using GitHub Actions) to automate building, testing, and deployment of scientific software
docs.github.com
. Throughout, we emphasize good practices in scientific software design and development, such as using version control, writing readable and maintainable code, thorough testing, and reproducibility
journals.plos.org
journals.plos.org
. In the final part of the course, we delve into parallel algorithm design and performance analysis. Key concepts like Amdahl’s Law and Gustafson’s Law are discussed to understand theoretical speedup limits and scalability of parallel programs
en.wikipedia.org
en.wikipedia.org
. We define metrics such as speedup and efficiency, and distinguish between strong scaling (fixed-size speedup) and weak scaling (scale-up with problem size)
hpc-wiki.info
hpc-wiki.info
. Real-world examples and hands-on experiments (e.g. parallelizing a computation across multiple cores) are used to illustrate these principles in practice. By the end of the course, students will be equipped to set up a robust, reproducible computational workflow for their research and to analyze the performance of parallel computations.

Acronym & Course Name: For brevity, we refer to the course as SSPA – Scientific Software tools and Parallel Algorithms. The course materials will be hosted in a public Git repository named sspa-2025-2026, following the style of previous course repos (e.g. collaborative-science-2022-2023). All content will be released under open licenses (e.g. Creative Commons for text and MIT for code) to facilitate reuse and improvement by the community, aligning with the spirit of collaborative science
github.com
.

Learning Outcomes

By the end of SSPA, students will be able to:

Use the Unix Shell & HPC Environment: Comfortably navigate and operate in a Linux command-line environment. Write basic Bash scripts and use shell tools to automate tasks. Understand HPC cluster architectures and use job schedulers (Slurm) to submit and manage batch jobs
hpc-wiki.info
hpc-wiki.info
. This includes writing Slurm job scripts and interpreting queue information (via commands like squeue, scancel, etc.).

Employ Version Control (Git): Maintain code history with Git for both solo and collaborative projects. Create and manage repositories, branches, and merges; resolve conflicts; and follow collaborative workflows using platforms like GitHub. Students will appreciate version control as an essential tool for reproducible research
journals.plos.org
. They will also practice using issue trackers and pull requests for project management and code review (optional, time permitting).

Generate Documentation: Use Doxygen and Sphinx to produce high-quality documentation for code. For C/C++ code, annotate source with Doxygen comments and generate HTML/PDF API docs automatically
doxygen.nl
. For Python or project-wide docs, write content in reStructuredText or Markdown and use Sphinx to build a documentation website (e.g. on ReadTheDocs)
en.wikipedia.org
. Students will learn to document not just APIs but also usage examples and theoretical background, improving the reusability of their software.

Implement Testing: Develop a habit of writing tests to validate code correctness. In C++, use Google Test (gtest) to write unit tests for functions/classes
en.wikipedia.org
. In Python, use pytest to write small, readable tests and possibly parametric or integration tests
docs.pytest.org
. Understand the difference between unit tests (testing one component in isolation), functional tests (testing features end-to-end), and integration tests. Students will be able to run test suites and interpret results, and know how to use continuous integration to run tests automatically on each commit.

Use Containers for Reproducibility: Create and use Docker containers to encapsulate software environments (specific Linux distro, libraries, dependencies) ensuring that code runs the same everywhere. Understand Docker basics (writing a Dockerfile, building images, running containers) and best practices (managing images, using Docker Hub). Learn about Apptainer (Singularity) for HPC: how it allows unprivileged users to run containerized workloads on HPC clusters
apptainer.org
, and how to convert or use Docker containers in an Apptainer context. Students will appreciate containers as a means to achieve portable and reproducible computational experiments
apptainer.org
.

Continuous Integration (CI): Set up automated workflows with GitHub Actions (or similar CI systems) to build and test their code on each commit or pull request
docs.github.com
. Students will write a basic CI configuration (YAML) that installs necessary dependencies (including using their Docker image if applicable) and runs the test suite and linter. They will also see examples of CI pipelines generating documentation or building Docker images. The goal is for students to integrate testing and deployment automation into their projects to catch issues early and enforce reproducibility standards.

Parallel Computing Basics: Grasp fundamental concepts of parallel algorithms and performance metrics. Students will be able to define speedup = T<sub>serial</sub>/T<sub>parallel</sub> and efficiency = speedup/ N (for N processors)
hpc-wiki.info
. They will apply Amdahl’s Law, which states that the maximum speedup is limited by the fraction of the computation that is serial (even with infinite processors, speedup is capped by the non-parallelizable portion)
en.wikipedia.org
. They will also understand Gustafson’s Law, which argues that by increasing problem size with more processors, one can maintain efficiency – effectively the parallel portion can grow with N, allowing nearly linear speedup for large-scale problems
en.wikipedia.org
. Concepts of strong scaling (fixed problem size) versus weak scaling (growing problem size with N) will be clear, including how to design experiments to test each
hpc-wiki.info
hpc-wiki.info
. Students will learn to assess parallel performance data (timing results) and compute speedup, efficiency, etc., identifying factors like communication overhead or I/O that cause deviations from ideal scaling.

Practical Parallel Skills: Through examples, students will get exposure to parallel programming models at a high level. We will not focus on one language, but examples in C++ (possibly using OpenMP or MPI) and in Python (using multiprocessing or simple parallel patterns) will be given. Students will run and modify simple parallel code – for instance, a program computing π via Monte Carlo simulation, first in serial and then in parallel – and will measure the runtime on 1, 2, 4, ... cores to see the effect. They will gain intuition on communication overhead, load balancing, and why more cores don’t always mean proportionally less runtime (linking back to Amdahl’s law). Real-world scenarios (like parallelizing a data analysis or simulation) will illustrate key points.

In summary, SSPA aims to give students a hands-on toolkit for scientific computing: from setting up a reliable development workflow with modern tools, to packaging and sharing their code, to running computations on HPC resources and understanding their performance. This holistic approach prepares students to conduct computational research in a sustainable, collaborative, and scalable manner
github.com
github.com
.

Course Format and Schedule

Duration & Schedule: The course consists of 30 hours of instruction, delivered as two sessions per week over roughly 5 weeks (10 sessions total, each 3 hours including breaks). Each session is designed as an interactive hands-on lecture – roughly half dedicated to concept exposition (with slides and live demos) and half to practical exercises or lab work. Students will actively use the tools during the sessions (e.g. practicing Git commands in a sandbox repo, writing and running a test, launching a container, etc.). Between weekly sessions, students will complete short assignments to reinforce the material. We also include a couple of short breaks in the schedule (or lighter Q&A sessions) to allow time for absorption and for working on a final mini-project.

Below is an outline of the course modules and sessions:

Week 1: Linux Shell, HPC Environment, and Slurm

Session 1 (3h) – Bash and Linux Fundamentals: We begin with a quick but thorough introduction to the Unix shell for those who need it. Topics include basic shell commands (navigation, file management, ssh into remote systems, editing files with nano/vim, etc.), shell scripting (writing a simple bash script, using loops and conditional execution), and environment variables. We emphasize commands useful in HPC contexts (like ssh port forwarding, using tmux or screen for persistent sessions). Hands-on: Students will write a “Hello World” bash script and a slightly more complex script (e.g. automating a simple analysis pipeline with a loop), practicing executing them. We also show how to navigate a typical HPC cluster login node and discuss the filesystem (home vs scratch storage).

Session 2 (3h) – Working on an HPC Cluster & Slurm Job Scheduler: In this session we simulate an HPC cluster environment using Docker (details below) so that every student can practice cluster operations. We cover the concept of batch scheduling – why clusters use job queues, scheduling policies, resource requests, etc. Using Slurm as the example (since it’s widely used), we explain how a job scheduler allocates jobs to nodes
hpc-wiki.info
. Students learn common Slurm commands: sinfo (cluster status), sbatch (submit a batch job script), squeue (check queue status), scancel (cancel jobs), etc. We walk through writing a simple Slurm job script (a Bash script with #SBATCH directives) to execute a sample program. Topics such as requesting resources (CPU cores, memory, GPUs), job arrays, and job dependencies are introduced at a basic level
hpc-wiki.info
hpc-wiki.info
. Hands-on: Students will practice writing and submitting a job script on the provided Slurm simulation. For example, we provide a simple C or Python program that does a CPU-intensive task (like summing numbers or sleeping for N seconds); students write a Slurm script to run it with certain resource specifications. They will submit the job, monitor it in the queue (PD pending vs R running)
hpc-wiki.info
, and retrieve the output. We also demonstrate an interactive job (srun --pty bash) to get a shell on a compute node (if the simulator supports it). By the end of this week, students unfamiliar with HPC systems will have a working knowledge of how to get their code running on a cluster in batch mode.

References: For those new to these concepts, we point to HPC Carpentry lessons and cluster user guides. For example, the Carpentries “Scheduler Fundamentals” lesson provides a beginner-friendly overview of using Slurm
carpentries-incubator.github.io
. We also highlight the importance of module systems on clusters (e.g., module load gcc to load compilers), though in our Dockerized mini-cluster we emulate this in a simplified way. This foundation prepares students for the more software-focused tools in subsequent weeks.

Week 2: Version Control with Git (Basics and Collaboration)

Session 3 (3h) – Git Fundamentals: This session introduces Git as the central tool for managing source code versions. We explain the problems version control solves (tracking changes, undoing mistakes, collaborating without clobbering work – as motivated by the scenario of emailing files document_v2_final.tex back and forth
math.sissa.it
math.sissa.it
). Students learn how to create a repository, record snapshots (commits), and view history. We cover the staging area (add/commit), how to write good commit messages, and simple branching. Hands-on: Students will initiate a Git repo on their local machine (or in the provided environment), make some edits to a sample text or code file, commit changes, and experiment with git diff and git log. We then introduce branching by creating a new branch, making changes, and merging it back (first with a fast-forward merge, then a merge with a conflict to show conflict resolution). This session focuses on single-user or small-team scenarios – using Git to track one’s own work and basic linear development. We illustrate these with a Jupyter Notebook or code example so they see a real use case (e.g., version-controlling a small Python script and improving it in steps).

Session 4 (3h) – Collaborative Git and Workflows: Building on the basics, we simulate a collaborative project workflow. We introduce remote repositories on GitHub: how to create a remote and push your local repo to GitHub, and how to clone an existing repo. Students will form pairs or small groups to practice collaboration: one student’s repository can be the “origin” and others clone it, or we use a classroom example repository. We demonstrate the fork & pull-request model used in open-source: each student forks a common repo, makes a change, and submits a pull request on GitHub. Alternatively, for simplicity, we simulate multiple collaborators on the same project – showing how git pull integrates others’ work. We emphasize frequent commit+push/pull to avoid large divergences. We also discuss branching strategies (feature branches, the main branch protection, etc.) and continuous integration integration (though CI is covered in depth later). Hands-on: In the lab, students collaborate on adding content to a shared repository (for example, each student adds a paragraph to a README or a function to a shared code, practicing resolving the merge conflicts that might occur if they edit the same lines). They use issues to discuss a task and go through the PR review process (approving and merging a teammate’s change). By the end of this week, they have experienced using Git in a team setting, which reinforces why discipline in committing and documenting changes is important. We point them to excellent resources for further self-study: Pro Git by Scott Chacon (available free online)
github.com
, and interactive tutorials like Git Immersion and Learn Git Branching
github.com
. Version control is presented not just as a tool, but as a fundamental good practice for scientific computing (enabling reproducibility and collaboration)
journals.plos.org
.

Week 3: Documentation and Testing

Session 5 (3h) – Automated Code Documentation: In this lecture we tackle documentation – a often neglected but critical aspect of sustainable software. We introduce two complementary tools: Doxygen for C/C++ (and other compiled languages) and Sphinx for Python or general project docs. For Doxygen, students learn how special comment syntax in C++ (e.g., /// or /** ... */ with @brief tags) can generate nicely formatted documentation. We show a simple C++ file with a couple of functions/classes, add Doxygen comments, then run Doxygen to produce HTML pages. The process of configuring Doxygen via a Doxyfile is demonstrated, but we keep it minimal (perhaps using Doxygen’s default configuration for a small project). We highlight how Doxygen parses source code and extracts documentation for functions, parameters, etc., creating an organized reference manual
doxygen.nl
doxygen.nl
. For Sphinx, we pivot to Python: we show how one can write documentation in reStructuredText or Markdown with MyST and use Sphinx to generate a documentation site. We demonstrate Sphinx’s autodoc feature which can pull in docstrings from Python code to create an API reference. The students see the workflow: sphinx-quickstart to create a docs project, writing a couple of pages (perhaps an “Introduction” and an API reference page that uses autodoc to include comments from a sample Python module), and then building the HTML. We mention Read the Docs and how many projects host Sphinx-generated docs there for free. Hands-on: Students are given a small piece of code (either C++ or Python, or one of each) with no documentation. Their task is to add inline comments and docstrings following the Doxygen/Sphinx syntax and then generate documentation. For example, a C++ HelloWorld class with methods, where they add /// comments for each method describing what it does. Or a Python function with some parameters where they write a docstring. They run the documentation tool and inspect the output to see their comments nicely formatted. We also encourage them to write a tutorial or usage example in the docs (to practice writing in Markdown/ReST, not just code comments). By doing this, they learn how documentation can be produced automatically and kept in sync with code – a big improvement over maintaining separate Word documents or manual docs. We tie this into best practices: “Document design and purpose, not just implementation” is a maxim from best-practices guides
journals.plos.org
. In scientific computing, documenting why and how (the scientific context and usage) is as important as documenting API details. Tools like Doxygen and Sphinx help integrate documentation into the development workflow.

Session 6 (3h) – Unit and Functional Testing: This session emphasizes testing as a means to ensure code correctness and reliability. We cover the concept of unit testing (testing individual components in isolation) and contrast with functional testing (testing end-to-end behavior of a program or feature). On the C++ side, we introduce Google Test (gtest) – a popular C++ testing framework that follows xUnit conventions
en.wikipedia.org
. We show a simple example: suppose we have a C++ function int add(int a,int b) in our project, a Google Test would involve writing a test case like EXPECT_EQ(add(2,2), 4). We compile and run the tests (perhaps using CMake if applicable, though we might use a simple Makefile for brevity). Students see the output of gtest (how it reports passed/failed tests). On the Python side, we introduce pytest as a very simple yet powerful framework. We demonstrate how just writing functions named test_... with plain assert statements is enough for pytest to pick them up
docs.pytest.org
. For example, we create test_sample.py with a failing test (like asserting 4==5) to show pytest’s nice failure report
docs.pytest.org
docs.pytest.org
. We cover basic pytest features: grouping tests in classes or modules, using fixtures (at least mentioning them), and how to run specific tests or get a coverage report. Hands-on: Students will write tests for a given piece of code. For instance, we provide a buggy function (in C++ or Python) and ask students to write a couple of tests that would catch the bug. Then they run the tests to see them fail, fix the code, and see tests pass (demonstrating the red-green-refactor cycle). Alternatively, for C++ we might give a small module and a ready test file, so they learn to compile and run it. And for Python, they could write a new test for an existing function (e.g., test that my_sqrt(-1) raises an exception). Through these exercises, they learn how to formulate assertions and understand what constitutes a good test (cover edge cases, typical cases, etc.). We also discuss the role of integration tests – for example, if the project is a simulation code, a functional test might run the entire simulation with a test input and verify the output matches a reference. We won’t write a full integration test given time, but we stress its importance. By the end, students will see testing as an integral part of development, not an afterthought, reinforcing the best practice: “Always test your code”. Indeed, we cite the recommendation from Wilson et al.: use automated testing and “make incremental changes” to avoid breaking things
journals.plos.org
. We align this with CI in the next session, noting that tests can be run automatically on each commit to maintain code health.

Week 4: Containers and Reproducibility; Continuous Integration

Session 7 (3h) – Containerization with Docker & Apptainer: This session focuses on packaging computational environments using containers. We start with the motivation: “It works on my machine” syndrome and the difficulty of installing complex scientific software on different systems. Containers address this by capturing the environment. We introduce Docker – explaining images vs containers: an image is like a recipe (with a Dockerfile to build it), a container is a running instance. We walk through a simple Dockerfile example, perhaps starting from python:3.10-slim and installing a few packages, then copying our application code. We show how to build the image (docker build .) and run it (docker run) to execute the contained app. We might demonstrate running a Jupyter Notebook server or a simple script inside a container. Students learn basic Docker commands (build, run, images, ps, exec). Security concerns and why we can’t usually run Docker on multi-user HPC systems are mentioned. This leads to Apptainer (Singularity): designed for HPC to allow unprivileged container execution
apptainer.org
. We explain that Apptainer uses single-file images (.sif) and can import Docker images
apptainer.org
. We won’t go deep into Apptainer usage due to time, but we describe the typical workflow: use Docker to build an image, then convert to sif or directly build with Apptainer, then run on the cluster with apptainer run. We highlight how Apptainer ensures no root access is needed and integrates with Slurm (jobs can run apptainer exec myimage.sif myprogram). Hands-on: Students will write a basic Dockerfile for a given mini-project – for example, containerize a small Python application that depends on NumPy. They will build and run their container to see that it indeed has the expected environment. If possible, they can also practice using Apptainer to run the same image: e.g. using Apptainer within our Docker-based cluster environment (this may be demonstrated by instructor if setting up Apptainer is complex). We also illustrate how containers improve reproducibility: we could share the image or Dockerfile, and any user (with Docker/Apptainer) can get the same environment and run the code with guaranteed same library versions. This addresses the “it runs today, but will it run in 5 years?” question – by archiving a container, the computational experiment can be reproduced. We mention projects like Docker Hub for sharing images, and best practices like using tags for versioning images. By the end, students have the skill to create a container for their own software, which is highly valuable in HPC where complex dependencies are common.

Session 8 (3h) – Continuous Integration (CI) with GitHub Actions: Now we connect the dots between version control, testing, and containers. We introduce CI/CD concepts – automated processes triggered by code changes. Specifically, we focus on using GitHub Actions (since our course repo is on GitHub) to run tests and other checks on each commit or pull request. We outline a simple CI workflow: on each push, set up a job that installs required dependencies and runs the test suite
docs.github.com
. In our case, we might demonstrate two kinds of jobs: one that runs on a base OS environment (e.g., Ubuntu VM on GitHub runners installing needed packages via apt/pip), and one that uses a Docker container we built earlier (showing how CI can leverage containers). The components of a workflow (YAML file, triggers, jobs, steps) are explained. We show how to use Actions from the marketplace, for example an action to set up Python or to checkout the repo. Hands-on (guided): Students will create a .github/workflows YAML file for a toy repository (perhaps the one they worked on in Week 2 or 3). The workflow will do something simple like echo a message (to ensure it runs), then perhaps run a test script. Since setting up CI live requires pushing to GitHub and observing, this might be partly demo and partly an exercise where students edit a provided CI config. We ensure they see a real example of a passing and failing build: e.g., intentionally break a test and push, then see the red X on GitHub, then fix and see green check. We also discuss adding other checks: building documentation as part of CI (to ensure docs have no errors), using CI to build and push Docker images (time permitting, mention how an Action can build a Docker image and publish it). Another aspect is Continuous Deployment (CD) – we will not actually deploy to production, but we mention that similar pipelines could deploy a web app or, in science, maybe upload results or notifications. Throughout, we reinforce how CI ties back to good practices: it automates the “let the computer do the work” principle
journals.plos.org
 – instead of manually running tests on everyone’s machine, a CI system ensures every change is tested in a clean environment. This helps catch errors early and maintain reproducibility (the CI environment can be seen as a proxy for a colleague’s machine – if it passes CI, your code with all its environment spec is reproducible on a fresh system). By the end of this session, students have a conceptual and practical understanding of setting up basic CI for their projects, closing the loop on the devops toolchain that ensures code quality.

Week 5: Parallel Algorithms and Performance Analysis

Session 9 (3h) – Parallel Computing Concepts & Laws: Now that the students have a solid toolbox for developing and running scientific software, we focus on how to scale that software on parallel systems. We start by defining key metrics in parallel computing: speedup (how many times faster a parallel execution is compared to serial) and efficiency (speedup divided by number of processors, indicating how well resources are used)
hpc-wiki.info
hpc-wiki.info
. We then present Amdahl’s Law: using an example scenario, say a program has a part that can be parallelized and a part that is inherently serial (e.g., reading input or writing results). Amdahl’s law formalizes that the maximum speedup S_max = 1/(s + p/N) (where s is the fraction of work that is serial, p parallel fraction, and N processors)
hpc-wiki.info
. We explain this in words: if 10% of the work is serial, even with infinite processors the best you get is 10x (since that 10% becomes the bottleneck)
en.wikipedia.org
. We illustrate with a plot or examples (50% parallel → at most 2x speedup; 95% parallel → at most ~20x speedup, etc., as per Amdahl’s reasoning
en.wikipedia.org
). This demonstrates the diminishing returns of adding more processors if the problem size is fixed. We then introduce Gustafson’s Law, which offers a more optimistic viewpoint by assuming you scale the problem size with the number of processors. Gustafson argues that one can keep the parallel part busy with more work as N grows, and the overall runtime can remain the same (or a set target), thus the effective speedup can be N (or close to linear) because the serial part doesn’t grow and becomes negligible
hpc-wiki.info
en.wikipedia.org
. We phrase it as: Amdahl is about fixed workload, Gustafson is about fixed runtime (let the problem grow). In practice, both views are useful: for a given code, if we cannot increase its problem size, Amdahl’s limit applies; but in research, we often have bigger problems we’d like to solve if we had more computing power, which is where Gustafson’s perspective fits. We also define strong scaling vs weak scaling clearly: strong scaling = how does time decrease when splitting a fixed problem into N parts (typical speedup experiment)
hpc-wiki.info
; weak scaling = how does time stay constant (or not) when increasing N while proportionally increasing the problem size per N (so work per processor is fixed)
hpc-wiki.info
. We mention that good weak scaling means you can solve larger problems in the same time as you add resources. We connect these concepts to the HPC systems: e.g., a supercomputer run might involve thousands of cores, but if the code has a serious serial bottleneck it won’t use them efficiently. Real-world profiling is touched on – finding the fraction s vs p (tools like gprof, etc., though we don’t go deep into using them here beyond concept). Example: We walk through a simple theoretical example: Suppose a program takes 100 seconds serial. If 95s of that can be perfectly parallelized and 5s is serial, then with 10 processors, parallel part becomes 9.5s (95/10) plus 5s serial = 14.5s total, speedup ~6.9; with 100 processors, 0.95s + 5s = 5.95s, speedup ~16.8, and even with infinite processors, time → 5s (the serial part) so speedup caps at 20. We then suppose instead we scale the problem size such that on 100 processors the parallel part is much larger – Gustafson would say maybe that 5s serial still, but parallel part could be, say, 1000s if run serial, but on 100 processors it becomes 10s, plus 5s serial = 15s total, which compared to the hypothetical single-processor time of 1005s gives speedup ~67 (much larger than Amdahl’s 20, because we increased work). This underscores the point that parallel efficiency often comes from tackling bigger problems. We ensure the students conceptually grasp these laws and can apply them in reasoning about parallel performance.

Session 10 (3h) – Practical Parallel Performance Lab: In the final session, we apply the concepts in a hands-on experiment and wrap up the course. We give the students a simple parallel program and have them measure its performance, analyze results, and relate to theory. For accessibility, we may use Python with the multiprocessing module (since setting up MPI might be complex for absolute beginners, but we could optionally provide an MPI example too). Lab Example: We use the classic π estimation by Monte Carlo. We have a function that tosses points and counts hits in a quarter circle. First, students run a pure Python version with 1 process for, say, 10 million points and measure the time (we can use Python’s time or a small script to measure). Then they run a version that uses multiprocessing.Pool with 4 processes dividing the work (each does 2.5 million points). They measure the time again. We gather results: e.g., maybe 1 process took X seconds, 4 processes might take roughly X/4 + overhead. They calculate the speedup = T1 / T4. We might vary N (process count) and problem size and have them fill a small table of timings. If resources allow, we do the same with a C++ OpenMP version for better performance and compare scaling. The aim is to see real data: does 4 cores give 4x speedup? Perhaps it gives 3.5x (due to overhead), leading to discussion of inefficiencies. We try also a case of not-fixed workload: e.g., with 4 cores we also quadruple the total points (so each core does the same as the single-core case did) – then measure time ~equal or slightly more than single-core baseline, illustrating weak scaling behavior (ideally constant time if perfect). Students plot or at least reason about their data relative to ideal linear speedup. We then encourage them to identify sources of non-ideal speedup: e.g., Python GIL (if threads were used), overhead of spawning processes, or simply that random number generation isn’t perfectly parallel. If MPI is demonstrated, we mention communication costs (but with Monte Carlo there’s almost none, which is why it scales well). We also provide an example of a problem with a larger serial portion – perhaps we artificially add a step that is done only on one process (like collecting results or writing to file) to see how that limits scaling as N grows, connecting to Amdahl’s law (the serial output step becomes the bottleneck with many cores). Wrap-up Discussion: We conclude by reviewing the key takeaways of the entire course. We highlight how all the tools and practices integrate: for instance, developing an HPC simulation code would involve using Git for version control, writing tests to ensure correctness of numerical kernels, using Doxygen/Sphinx to document the code for others (and future self), containerizing the software to run on different clusters or to allow reviewers to reproduce results, and using CI to continuously validate code changes. Then when running at scale, one must analyze performance and possibly go back and optimize algorithms (maybe reducing the serial fraction or using better parallel algorithms) to improve efficiency. We emphasize the good practices that will make them effective computational scientists: e.g., “Write programs for people, not just computers” (clean, readable code)
journals.plos.org
, use version control and issue tracking, don’t repeat yourself (modularize code)
journals.plos.org
, refactor and test incrementally, and share and reproduce: if someone can’t easily run your code and get the same results, the scientific value is diminished. By adopting the tools in SSPA, they will avoid many common pitfalls and be well-prepared to collaborate in larger scientific software projects or HPC teams.

Finally, we provide additional resources for further learning: for parallel computing, references like the LLNL “Introduction to Parallel Computing” tutorial
hpc.llnl.gov
 and the book Introduction to High Performance Computing for Scientists and Engineers (Hager & Wellein) for deeper theoretical coverage; for tools, the official docs of each tool (Git, Docker, etc.) and communities (Stack Overflow, etc.) for troubleshooting. We encourage students to continue practicing these skills in their research and perhaps contribute to open-source scientific software to hone them.

Assignments and Assessment

To reinforce learning, the course includes weekly self-evaluated assignments and a final mini-project:

Weekly Mini-Assignments: After each week, students get a small practical task focused on that week’s topic:

Week 1 Assignment: Write a shell script that automates a simple data processing task (e.g., concatenating multiple data files, or submitting a batch of jobs in a loop). Also, given a Slurm job script template, modify it to request a different number of CPUs and run a test program – then interpret the Slurm output (did it use the CPUs? check runtime difference).

Week 2 Assignment: Use Git to track changes in a short project. We provide a repository with a couple of bugs/incomplete features. Students must branch, fix one issue (e.g., correct a function implementation), commit, then merge to main. They will also practice making a pull request on GitHub (optionally using a partner to review it). The deliverable could be their Git history (we will check that it shows a meaningful sequence of commits, not one big dump).

Week 3 Assignment: Document and test a piece of code. For example, we give a C++ file with undocumented functions and a few logical errors. Students add Doxygen comments to each function (ensuring the generated docs include those descriptions), and write a Google Test case that currently fails due to the bugs. They then fix the code so that the test passes. The student can verify success by generating the HTML docs (which should include their new comments) and running the test runner (all tests green).

Week 4 Assignment: Container and CI exercise. Students write a Dockerfile for a simple application (for instance, a Python script that depends on an external library). They build and run the container to produce a certain output (given by us for verification). They then set up a GitHub Actions workflow (we provide a starter YAML) in their repo that builds the Docker image and runs the script inside it automatically – the build log on GitHub Actions will show the output. This assignment ties together containers and CI: students will know they succeeded if their GitHub Actions workflow completes and perhaps posts the script’s output or a success message.

Week 5 Assignment: Parallel performance analysis. Using the code from the lab (or a provided program), students will run it with different numbers of threads/processes on our Docker-simulated mini-cluster and record the timings. They will then plot or tabulate the speedup and calculate efficiency for each case. They’ll answer a few conceptual questions: e.g., “Given your results, estimate the serial fraction of the program using Amdahl’s law” or “Does your data suggest any communication overhead or inefficiency? Why might the speedup at 8 processors be less than 8?” – requiring them to apply course concepts to explain observed behavior.

Each assignment is designed to be self-evaluable: we provide test scripts or expected outputs so that students can check their work. For instance, for the testing assignment, we might include additional hidden tests – students can run ctest or pytest -q and if all tests pass, they know their solution is correct. For the Git assignment, we might use a CI workflow that checks if the repository has at least X commits and if certain tasks are completed (though manual review may be done in class). This approach leverages the tools themselves (CI, tests, etc.) to give immediate feedback, reinforcing learning by doing. The assignments are not meant to be heavy workloads but rather guided practice to build confidence.

Final Project: In the last week, students are given an integrative project that encompasses multiple aspects of the course. The project could be: “Set up a reproducible scientific computation and analyze its parallel performance.” Concretely, we might ask them to take a simple application (options could include: a small numerical simulation, a data analysis on a sample dataset, or the Monte Carlo pi code) and do the following: put it under version control, containerize it, write documentation and tests for it, and demonstrate it running in parallel with performance metrics. They would create a GitHub repository (or a branch of our course repo) for this project. Specific requirements could be:

Use Git from the start (with a nice commit history).

Write at least one unit test (and make sure it passes).

Containerize the application with a Dockerfile.

Write a short Sphinx or Markdown documentation (at least an overview and instructions to run).

Set up a GitHub Actions CI workflow that runs the test (and perhaps builds the container).

Finally, run the application in the provided HPC environment with 1, 2, 4 processes and record the execution times. Produce a short report (can be in the documentation or a separate markdown file) discussing the speedup and efficiency, and what limits were observed.

This final project will be somewhat open-ended to allow creativity (more advanced students can try additional things like using MPI if they know it, or adding more tests, etc.). It will be evaluated on completeness and adherence to good practices rather than sheer complexity. Essentially, it’s a culmination of SSPA’s philosophy: demonstrate that you can make a piece of scientific software that is well-engineered (with tests, docs, version control), portable (container), and scalable (parallel performance measured).

We encourage students to work in small teams for the project, reflecting real-world collaboration. They will peer-review each other’s work in the last session, practicing code review and critique of documentation and clarity. This also ensures that everyone gets feedback and learns from others’ approaches. The final deliverables (code and brief report) are due a week after the last session to give time for refinement.

There are no formal exams; assessment is based on these practical outputs. Our goal is that by completing assignments and the project, students prove to themselves that they can apply the tools in practice – the self-evaluation aspect is key, as it mirrors the self-driven nature of research programming. The instructor will, of course, be available to check work and give feedback, but the emphasis is on learning by doing and iterating.

Course Materials and Repository Structure

All course content (slides, notes, code examples, etc.) will be made available in a dedicated GitHub repository (proposed name: luca-heltai/sspa-2025-2026). The repository is structured for maintainability and clarity, following a similar layout to collaborative-science-2022-2023. It will be a living repository that students clone and use throughout the course, and that can be updated with improvements in future iterations. Key components of the repo include:

Slides (slides/ directory): Lecture slides for each session will be provided, likely in PDF format (for easy access) and possibly source form (e.g. Markdown/LaTeX or Jupyter Notebook if using RISE/reveal.js). For example, slides/Week1_Shell_HPC.pdf, Week2_Git.pdf, etc. These slides concisely summarize the key concepts and serve as a reference. They contain diagrams (e.g. illustrating Amdahl vs Gustafson speedup curves), commands usage, and best-practice checklists. By keeping slides under version control, we can continuously refine them and even accept pull requests from students who spot errors or have suggestions (a practice encouraged in the previous course
math.sissa.it
).

Lecture Notes and Examples (docs/ or notebooks/): In addition to slides, we will have more extensive notes in text form. We plan to use Jupyter Book (or Sphinx with MyST) to organize these notes into a coherent course book. The repository will have a docs/ folder with markdown notebooks for each topic, enriched with explanatory text, code snippets, and outputs. This will be published (e.g. via GitHub Pages) so students can read it as a website. The notes complement the slides by providing step-by-step tutorials – for instance, a Git tutorial where each command is shown with expected output, a Docker tutorial walking through container build and run, etc. These notes also include the solutions/discussions for the in-class exercises and assignments (some of those can be kept in an exercises/ section until after they attempt them). By using a Jupyter Book approach, we ensure the content is easily maintainable and nicely formatted, with features like search and hyperlinks between topics.

Assignments and Labs (exercises/ directory): All hands-on exercises are documented here. Each weekly assignment has a subfolder or file, e.g. exercises/week1_shell/, containing a README with the task description and any starter code or data needed. We include test files for self-check where applicable. For example, exercises/week3_testing/ might contain a buggy code.cpp and a test_code.cpp using gtest, so students can run and see failing tests. Solutions or tips might be added in a solutions/ branch or after the due date to avoid spoilers. The lab activities done during class (like the Monte Carlo pi code and instructions to run it in parallel) will also be present, so that students (or anyone using the repo) can reproduce those demos. This approach follows the idea used in the collaborative-science course repository, which “contains assignments, workspaces, and other material” for hands-on practice
github.com
.

Docker Environment (docker-images/ directory): A unique feature of this course is the Docker-based HPC simulation. In this folder we maintain the Dockerfiles and configuration needed to spin up the virtual cluster that students use. We will likely have:

docker-images/slurm-controller.Dockerfile – sets up a container with Slurm controller (slurmctld) and maybe a SlurmDBD (if needed) and a few user accounts. It will also install development tools (compiler, MPI library, Python, etc.) so that this container can serve as a compile node too.

docker-images/slurm-worker.Dockerfile – for compute node daemons (slurmd). Possibly the controller image can also act as a worker if we configure it all-in-one, but to emulate multi-node we might use separate images.

docker-images/jupyter.Dockerfile (optional) – an image that has Jupyter Lab and all the teaching materials, which could be used by students locally if they prefer a pre-configured environment with all tools installed (e.g. gtest, doxygen, etc.). This might not be necessary if the controller image covers it.

A docker-compose.yml at the root or in docker-images/ that defines how to network these together: e.g. one instance of controller, two instances of worker, all on an internal network so that Slurm commands and job submissions work. Using Compose, students can bring up the mini-cluster with a single command (docker-compose up) and then ssh into the controller to start using Slurm. We’ll provide setup scripts to initialize Slurm (creating a cgroup config, starting slurmctld and slurmd processes inside containers). This setup draws on existing solutions like the HPCNow Slurm simulator and similar projects, but tailored to our needs
github.com
. The outcome is a portable cluster: anyone with Docker can launch it, which aligns with our portability goal. This environment will also include any libraries needed for the course examples (for instance, OpenMPI or MPICH for parallel runs, if we decide to show MPI, and Python packages for our examples).

With this in place, the entire class can uniformly use a consistent environment, and future instructors (or the same instructor next year) can reuse it without worrying about differences in HPC systems. We document how to use this in docker-images/README.md, with troubleshooting tips (like needing Linux or Docker Desktop, etc.). Having a self-contained HPC setup is somewhat ambitious, but it will greatly enhance the hands-on experience for students who may not have direct access to a real cluster for playing around.

Source Code Examples (code/ directory): Snippets and example programs shown in class will be available here. For instance, the C++ example used for the Doxygen demo, the Python script for the pytest demo, the Monte Carlo π code in both Python and C++, etc. This allows students to easily obtain and tinker with the examples without copying from slides. It also makes the repository a useful reference after the course. Where relevant, we include small CMake or Make build files so students can build the C++ examples themselves. We will ensure these examples are cross-platform (to the extent possible) or at least runnable in the provided Docker environment.

Continuous Integration Config (.github/workflows/): The repository itself will practice what we preach – we set up GitHub Actions CI for the course repo. For example, a workflow will build the Docker images (to ensure the Dockerfiles work) and perhaps even launch a minimal Slurm test (this might be advanced, but we could test that the controller container starts). Another workflow could run pytest on any example tests in the repo, or build the Jupyter Book and deploy it to GitHub Pages (so the course site is always up-to-date). By having CI on the course repo, we demonstrate real usage of CI (and can show students the CI results as a live example). It also helps maintain the repo – e.g., if a dependency update breaks an example, CI will catch it. Students can inspect our workflows as models for their own projects.

Licenses and Credits: We include a LICENSE file and a LICENCE.md. Likely:

LICENSE – an MIT license (or CC0) applying to the example code in the repository, so that students and others can freely use and modify the code without restrictions
github.com
.

LICENCE.md – a Creative Commons CC-BY 4.0 license for the documentation and instructional content (slides, text, images)
github.com
. This means anyone can reuse/adapt the course materials as long as they credit the source. This choice follows the precedent of the 2021-2022 course, which was openly licensed
github.com
. We want the course to join the commons of open educational resources in scientific computing.

An Attribution section in the README or a dedicated file, where we credit resources we used/inspired us (for example, mentioning that we borrowed ideas from Software Carpentry lessons, or used graphics from certain sources, etc.). This acknowledges intellectual contributions and also helps students find those resources for deeper learning
github.com
.

README.md: The repository’s main README will function as a landing page. It will outline the course purpose, how to get started (e.g., “clone this repo and run docker-compose up to launch the environment”), and link to the rendered documentation (Jupyter Book). It will also explain how students can keep their copy updated by pulling changes (as was instructed in the collaborative-science course
math.sissa.it
). The README will encourage contributions via pull requests – for example, if a student finds a typo in the notes or has an improved example, they can contribute back
math.sissa.it
, learning collaboration by doing it.

This organized repository ensures that all materials are in one place under version control, making it easy not only for students to access everything but also for the instructor to maintain and for future instructors or self-learners to benefit. By using open-source practices (CI, issues for feedback, and encouraging PRs), the course repository itself becomes a live example of collaborative scientific software development.

Conclusion

“An Introduction to Scientific Software Tools and Parallel Algorithms (SSPA)” is designed to equip researchers with practical skills to make their computational work more efficient, reproducible, and scalable. It blends tool-oriented training (Linux, Git, Docker, etc.) with computing theory (parallel speedup and performance) to serve the needs of a modern scientific computing practitioner. The course style is very hands-on – students learn by doing, with constant feedback from tests and CI – reflecting the reality that proficiency comes from practice.

By the end, a student will have essentially built a template for their future projects: a repository with proper structure, documentation, testing, CI, and containerization – and the knowledge of how to deploy that on HPC resources and how to assess its performance. This markedly lowers the startup time for their research coding and instills confidence in working on high-performance systems. Moreover, the emphasis on good software practices has a long-term payoff: as the Best Practices for Scientific Computing article states, using tools like version control, testing, and incremental development leads to more reliable and maintainable research code
journals.plos.org
journals.plos.org
, and ultimately to better science. We believe this course will not only teach technical skills but also help foster a culture of reproducibility and collaboration among the next generation of computational scientists.

References and Further Reading: (Resources cited throughout the course materials)

Pro Git book by Scott Chacon and Ben Straub – a comprehensive guide to Git
github.com
.

Git Immersion and Learn Git Branching – interactive tutorials for hands-on Git practice
github.com
.

Official documentation for tools: Bash Guide, GitHub Learning Lab, Docker docs, Apptainer User Guide
hpc.ncsu.edu
, GoogleTest Primer, pytest documentation, Doxygen and Sphinx docs (the Sphinx tutorial and reStructuredText guide)
en.wikipedia.org
.

HPC Carpentry lessons – e.g. HPC Intro, Shell Novice, and HPC Parallelization for Novices (for additional examples on parallel concepts and cluster use)
hpc-carpentry.org
hpc-carpentry.org
.

HPC Wiki (hpc-wiki.info) – a community wiki with concise articles on HPC topics (we drew on it for explanations of scaling, Slurm, etc.)
hpc-wiki.info
hpc-wiki.info
.

Introduction to High-Performance Computing for Scientists and Engineers by Hager & Wellein – textbook covering parallel architectures and programming (for those who want to go deeper into MPI/OpenMP and performance tuning).

Best Practices for Scientific Computing by Wilson et al., PLOS Biology 2014 – an influential paper outlining key practices that this course reinforces (version control, testing, collaboration, etc.)
journals.plos.org
journals.plos.org
.

Good Enough Practices in Scientific Computing by Wilson et al. 2017 – a follow-up focusing on minimal best practices to start with (for students to review as a checklist for their own work).

All these and more will be linked in the course repository for easy access. The course is released under CC-BY (content) and MIT (code) licenses, so participants and other instructors are free to reuse and adapt the materials in their own research and teaching
github.com
. We hope that SSPA will not just be a one-off training but will seed a lasting improvement in how students approach computational research, making their work more sustainable, shareable, and scalable.
