# Parallel Computing Concepts

----

## Lecture 10 goals

- Define **speedup** and **efficiency**
- Contrast **strong** vs **weak** scaling
- Use **Amdahl** and **Gustafson** laws to reason about limits
- Read timing data and diagnose bottlenecks

----

## First: what “parallel” means

- **Parallelism**: doing *multiple computations at the same time* on multiple CPU cores
- **Concurrency**: multiple tasks *in progress*, possibly time-sliced on one core
- A common pattern:
  - split work into **independent tasks**
  - run tasks on **workers** (cores/processes)
  - **combine** partial results (a “reduction”)

----

## Processes vs threads (Python)

- **Threads** share memory, but Python’s **GIL** usually prevents CPU-bound code from running in parallel
- **Processes** have separate memory and can use multiple cores for CPU-bound work
- In this course we use `multiprocessing` (process-based parallelism)

----

## What do we measure?

- **Wall time** (elapsed time): what users care about
- **CPU time**: total compute time across cores
- Always specify:
  - problem size (input/work)
  - hardware (CPU model, cores, memory)
  - software (compiler/interpreter versions, flags)
  - measurement method (single run vs min/mean of many)

----

## Speedup and efficiency

Let $T_1$ be the time on 1 core and $T_p$ on $p$ cores:

$$
S(p) = \frac{T_1}{T_p}
\qquad
E(p) = \frac{S(p)}{p} = \frac{T_1}{p\,T_p}
$$

- Ideal: $S(p)=p$, $E(p)=1$
- In practice: overheads + resource limits reduce $S(p)$

----

## Strong scaling

**Fix the problem size**, increase cores:

- Goal: reduce time-to-solution
- Typical plot: $T_p$, $S(p)$ vs $p$, or $E(p)$ vs $p$
- Pain points show up quickly:
  - synchronization/communication
  - memory bandwidth
  - load imbalance

----

## Weak scaling

**Increase problem size with $p$**, but keep work per core ~ constant:

- Goal: keep time roughly constant while scaling problem size
- Typical plot: $T_p$ vs $p$ for scaled workload
- Weak scaling is often the relevant metric in HPC production runs

----

## Amdahl’s Law (fixed workload)

Let $f$ be the **serial fraction** (cannot be parallelized).

$$
T_p = T_1\left(f + \frac{1-f}{p}\right)
\qquad\Rightarrow\qquad
S_p=\frac{1}{f+\frac{1-f}{p}}
$$

Key consequence:

$$
\lim_{p\to\infty} S_p = \frac{1}{f}
$$

---

## Amdahl example

If $f = 0.05$ (5% serial):

- $S_8 \approx \frac{1}{0.05 + 0.95/8} \approx 5.93$
- $S_{64} \approx \frac{1}{0.05 + 0.95/64} \approx 15.4$
- Upper bound: $S_{\infty}=20$
Interpretation: after some point, more cores buy less.

----

## Gustafson’s Law (scaled workload)

Gustafson’s viewpoint: **scale the problem size** with the number of processors.

Normalize the time on the parallel system:

$$
T_p = 1 = f + (1-f)
$$

Hypothetical serial time (same serial part, parallel part un-split):

$$
T_1 = f + p(1-f)
$$

---

Using $T_1$ as baseline, the scaled speedup is:

$$
S_G(p) = \\frac{T_1}{T_p} = f + p(1-f) = p - f(p-1)
$$

Interpretation: “How much bigger a problem can I solve in the same time as I add processors?”

----

## Estimating the serial fraction from data

Given measured speedup $S(p)=T_1/T_p$, the **Karp–Flatt** metric estimates $f$:

$$
f(p) = \frac{\frac{1}{S(p)} - \frac{1}{p}}{1-\frac{1}{p}}
$$

- If $f(p)$ is ~constant → Amdahl model fits well
- If $f(p)$ grows with $p$ → overheads/limits dominate

----

## Why speedup flattens (common causes)

- **Load imbalance**: some workers finish early and wait
- **Parallel overhead**: task creation, scheduling, communication
- **Synchronization**: locks, barriers, reductions
- **Memory bandwidth**: more cores, same memory channels
- **I/O**: shared filesystem, serialization on output

----

## Designing timing experiments

- Warm up and repeat; report **min/median** over multiple trials
- Control the environment:
  - pin threads/processes when possible
  - avoid background load
  - fix frequency scaling if relevant
- Measure what matters:
  - end-to-end wall time
  - plus breakdowns from profiling (where time is spent)

----

## From numbers to conclusions

When you see:

- $E(p)$ dropping early → overheads or bandwidth limits
- $T_p$ stops improving → serial fraction or contention
- big variance run-to-run → noise, scheduling, or unstable workload

Next action: profile and identify the dominant bottleneck.

----

## Lab 10 code: Monte Carlo π benchmark

Goal: estimate π by random sampling.

- Draw random points $(x,y)$ in the unit square
- Count how many fall inside the quarter circle $(x^2+y^2\le 1)$
- Estimate:

$$
\pi \approx 4 \cdot \frac{\text{inside}}{\text{samples}}
$$

Why it’s a good first parallel example:

- each sample is independent (**embarrassingly parallel**)
- the only “combine step” is summing counts (**reduction**)

----

## How the code is parallelized (high level)

In `codes/lab10/python/bench_pi.py`:

1. Choose number of processes \(p\)
2. Split the total number of samples into \(p\) chunks
3. Each process runs the same function on its chunk (no shared state)
4. Parent sums the partial counts and computes π

This is a classic **map → reduce** workflow.

---

## Serial vs parallel parts (Amdahl in the real world)

Even in a “parallel program”, some work is still serial:

- argument parsing, input validation, printing results
- creating worker processes / starting the pool
- distributing tasks to workers
- combining results (sum/reduction)

Parallel part:

- the loop that generates random points and counts “inside”

If the parallel work is too small, overhead dominates and scaling looks bad.

----

## The worker function: pure computation

Each worker computes a local count and returns it:

```python
def _count_inside_circle(samples: int, seed: int) -> int:
    rng = random.Random(seed)
    inside = 0
    for _ in range(samples):
        x = rng.random()
        y = rng.random()
        if x*x + y*y <= 1.0:
            inside += 1
    return inside
```

- No shared variables
- Deterministic RNG per worker via a seed
- Returns a single integer (easy to combine)

----

## The parallel call: `multiprocessing.Pool`

The parent process creates a pool and runs workers:

```python
with mp.Pool(processes=p) as pool:
    inside_parts = pool.starmap(_count_inside_circle, zip(work, seeds))
inside = sum(inside_parts)
```

What happens conceptually:

- `Pool` starts \(p\) worker processes
- `starmap` sends arguments to workers (serialization / pickling)
- workers run independently and return results
- parent collects results and sums them

----

## Do we need a mutex here?

No.

- A **mutex/lock** is needed when *multiple workers update the same shared data*.
- In this benchmark, workers do **not** share memory:
  - each returns a local count
  - the parent combines results at the end

Rule of thumb: **avoid shared state if you can** (it scales better and is simpler).

----

## When you DO need a mutex (lock)

If multiple workers access shared data and at least one writes:

- incrementing a shared counter
- updating a shared dictionary/list
- writing to the same file

Without a lock you can get **race conditions**:

- lost updates
- corrupted data
- non-deterministic results (sometimes “works”, sometimes not)

----

## Lock example: shared counter (safe but slow)

This is *not a good scaling strategy*, but it illustrates locks:

```python
import multiprocessing as mp

def worker(n, counter, lock):
    for _ in range(n):
        with lock:
            counter.value += 1

if __name__ == "__main__":
    counter = mp.Value("i", 0)
    lock = mp.Lock()
```

- Correct because increments are protected by `lock`
- Often slow because the lock becomes a bottleneck (serializes the updates)

----

## Better than locks: local work + reduction

Instead of incrementing one shared counter:

- each worker counts locally
- return local result
- parent sums at the end

This is exactly what the Monte Carlo π benchmark does.

----

## Multiprocessing patterns you’ll reuse

1. **Data parallelism**: apply the same function to many items (`map`)
2. **Task parallelism**: different tasks/processes coordinated via queues
3. **Pipelines**: producer/consumer stages (often with `Queue`)

We’ll show small examples of each.

----

## Example 1: simplest `Pool.map`

```python
import multiprocessing as mp

def f(x):  # must be top-level for pickling
    return x * x

with mp.Pool(processes=4) as pool:
    ys = pool.map(f, [1, 2, 3, 4, 5])
```

Notes:

- `map` preserves input order
- process startup + serialization cost is real → batch enough work

----

## Example 2: multiple arguments with `starmap`

```python
import multiprocessing as mp

def add(a, b):
    return a + b

items = [(1, 10), (2, 20), (3, 30)]
with mp.Pool(3) as pool:
    out = pool.starmap(add, items)
```

This is the same API used by the Lab 10 π benchmark.

----

## Example 3: `Process` + `Queue` (producer/consumer)

```python
import multiprocessing as mp

def worker(q_in, q_out):
    for x in iter(q_in.get, None):
        q_out.put(x * x)

if __name__ == "__main__":
    q_in, q_out = mp.Queue(), mp.Queue()
    p = mp.Process(target=worker, args=(q_in, q_out))
    p.start()
    for x in [1, 2, 3]:
        q_in.put(x)
    q_in.put(None)  # sentinel: stop
    p.join()
```

Use this when:

- you want a pipeline or streaming workflow
- tasks arrive over time, not as a fixed list

----

## Practical “first parallel run” checklist

- Start with \(p=1\) to validate correctness, then scale up
- Use a workload big enough to amortize overhead
- Avoid shared state; prefer “local work + reduction”
- Expect non-ideal speedups:
  - process startup costs
  - OS scheduling noise
  - memory bandwidth limits

----

## Lab 10 preview

You will:

- collect strong/weak scaling data for a small benchmark
- compute $S(p)$, $E(p)$, and estimate $f$
- compare measurements to Amdahl/Gustafson expectations
- write a short interpretation of the scaling behavior
