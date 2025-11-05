# Using the terminal

----

## Bash

Default on most Linux systems.

* **Scripts** – standard `.sh`.
* **Features** – readline, globbing, job control, arrays.
* **Extensible** – functions, aliases.

```bash
greet() { echo "Hello, $1!"; }
greet world
```

---

## Zsh

Default on macOS.

* **Completion** – advanced globbing (`**/*.py`).
* **Correction** – auto-fixes typos.
* **Prompts** – themes, colors.
* **Plugins** – oh-my-zsh, prezto.

```zsh
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f $(git_prompt_info)%f '
```

---

## Fish

Friendly Interactive Shell.

* **Syntax** – uses `set`, no `export`.
* **Autosuggest** – live history hints.
* **Errors** – human-readable.
* **Config UI** – `fish_config`.

```fish
set greeting "Hello, fish!"
echo $greeting
```

---

## PowerShell

Cross-platform, object-based.

* **Objects** – pipelines pass data.
* **Cmdlets** – `Get-Process`, `Get-Service`.
* **Language** – loops, try/catch.
* **Integration** – all OSes.

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
```

---

## Summary

| Shell      | Use         | Strength                |
| ---------- | ----------- | ----------------------- |
| Bash       | Scripts     | POSIX, standard         |
| Zsh        | Interactive | Completion, themes      |
| Fish       | Interactive | Autosuggest, simplicity |
| PowerShell | DevOps      | Object pipelines        |

Pick: Bash for scripts, Zsh/Fish for interactivity, PowerShell for cross-platform.

----

# Bash

---

## Basic navigation

```bash
pwd        # show path
ls -la     # list files
mkdir dir  # make dir
cd dir     # change dir
cd ..      # up one
cd -       # previous dir
```

---

## Files

```bash
touch f.txt      # new file
rm f.txt         # delete
rm -r dir        # remove dir
cp a b           # copy
mv a b           # move/rename
```

---

## Permissions

```bash
chmod 644 file.txt
```

`rw- r-- r--`: owner read/write, others read.
Use `man chmod` for more modes.

---

## Searching and reading

```bash
find . -name "*.txt"
grep -nr "hello" .
cat hello.txt
less hello.txt
```

Scroll: Shift + Arrow, search: `Ctrl+R`.

---

# Redirection

```bash
ls -l > out.txt   # write
echo hi >> out.txt  # append
1> stdout  2> stderr  &> both
```

```bash
history | grep "cd"
```

`/dev/null` discards output.

---

# Processes

```bash
ps -A     # all
top -o %MEM
kill -9 PID
```

---

# .bashrc / .zshrc

Run at login. Add aliases or settings.

```bash
alias pg='ping google.com'
```

----

# Lab 01

## Automating slide page generation

Assume you have cloned the course repository

```
git clone git@github.com:luca-heltai/sspa.git
```

Let's explore the structure of the repository:

* <https://github.com/luca-heltai/sspa>

----

## Overview of the course page

* The course materials are in `jupyterbook/lectures/` and `jupyterbook/slides/`
* The software `jupyter-book` (<https://jupyterbook.org/>) builds the course webpage from these (text) sources
* It generates the static HTML page that is then hosted on GitHub Pages (<https://luca-heltai.github.io/sspa/>)

---

## Problem statement

* `jupyterbook` does not natively support slides
* `jupyterbook` renders slides content as a single long html page (take a look at [intro](/slides/slides00/))
* We would like to provide also an embedded (and *interactive* slideshow) in each lecture page

---

## Solution

* `reveal.js` (<https://revealjs.com/>) can render markdown slides as interactive slideshows

**Problem:**

* We need to create a landing page for each slideshow (e.g., `slides01.html`) that `reveal.js` can use to render the slides from the markdown content (e.g., `slides01.md`)

---

## Technical issue

* `jupyterbook` generates its pages in a temporary folder during the build process
* we need to copy the generated `slidesXX.html` there after `jupyterbook` has run
* we want this to be automatic

Look at the `Makefile`, and see how the slides are copied after the book is built:

```bash
make build
make copy
```

----

## Goal of today's lab

* Updates slide landing pages automatically.
* Create slides (`slidesXX.html`) from content (`slidesXX.md`).
* Embed slides in lecture notes (`lectureXX.md`).
* Avoid manual errors
* Allow easy updates to templates, styles, etc.

---

## What

**Inputs**

* Template HTML (from a `reveal.js` example): `codes/lab_01/slides_template.html`
* Footer template (to add at the end of each lecture page): `codes/lab_01/lecture_footer.md`
* Slide sources (the **only** content I want to write): `jupyterbook/slides/slidesXX.md`

---

**Outputs**

* Landing pages: `jupyterbooks/slides/slidesXX.html`
* Footer appended to: `jupyterbooks/lectures/lectureXX.md`

Mapping:

```
slides00.md → slides00.html → referenced in lecture00.md
slides01.md → slides01.html → referenced in lecture01.md
...
```

---

## How

1. Find all `jupyterbook/slides/slides*.md`.
2. Extract `XX`.
3. Create `slides/slidesXX.html` by replacing `slidesXX.md` in the HTML template with the real filename (`sed`).
4. Build footer by replacing `XX` in `lecture_footer.md`.
5. If `lectureXX.md` does not reference `/slides/slidesXX.html`, append the footer.

---
<!-- .slide: data-visibility="hidden" -->
## Script: `codes/lab_01/generate_slides.sh`

```{literalinclude} ../../codes/lab01/generate_slides.sh
:language: bash
```

---

## Run the script

Make sure it is executable:

```bash
chmod +x codes/lab_01/generate_slides.sh
```

Run it:

```bash
./codes/lab_01/generate_slides.sh -v
# or dry-run first:
./codes/lab_01/generate_slides.sh -n -v
```

---

## Breaking it down

* Shell navigation and file ops
* Globbing and pattern matching
* `sed` for templating
* `grep` for checks
* Safe scripting patterns

----

# Project layout

---

## Expected folders

```bash
codes/lab_01/
  ├─ slides_template.html
  ├─ lecture_footer.md
  └─ generate_slides.sh   # we will look at this
jupyterbook/slides/
  ├─ slides00.md
  ├─ slides01.md
  ├─ ...
  ├─ (the script will write slidesXX.html here)
jupyterbooks/lectures/
  ├─ lecture00.md
  ├─ lecture01.md
  └─ ...
```

---

## Creating the templates

```bash
mkdir -p codes/lab_01
```

* `mkdir -p` creates parents as needed.
* Verify:

```bash
ls -la codes/lab_01
```

----

# Templates

---

## HTML template snippet

The file `codes/lab_01/slides_template.html` must include (this is how `reveal.js` loads markdown):

```html
...
<section 
  data-markdown="slidesXX.md" 
  data-separator="\n----\n" 
  data-separator-vertical="\n---\n">
</section>
...
```

* `XX` is a placeholder we will replace.
* `\n` is a newline (in regex).

---

## Footer template

`codes/lab_01/lecture_footer.md`:

````
<iframe src="/slides/slidesXX.html" width="100%" height="800px" style="border: none;"></iframe>

```{admonition} 🎬 View Slides
:class: tip

**[Open slides in full screen](/slides/slidesXX.html)** for the best viewing experience.
```
````

* Again, `XX` is a placeholder.

----

# Scripting strategy

---

## Inputs → Outputs

* Input: each `jupyterbook/slides/slidesXX.md`  
* Output A: `jupyterbook/slides/slidesXX.html` from HTML template by replacing `slidesXX.md`  
* Output B: ensure `jupyterbook/lectures/lectureXX.md` ends with a footer referencing `/slides/slidesXX.html`

---

## Why a script

* Repeatable for any number of slides  
* Avoid manual errors  
* Keep lectures and slides in sync
* Easy to update templates/styles later

----

# Build the script

---

## Create the file

```bash
cd codes/lab_01
touch generate_slides.sh
chmod +x generate_slides.sh
````

* `touch` creates an empty file.
* `chmod +x` makes it executable.

----

## Define defaults

These are **variables**:

```bash
SLIDES_DIR="jupyterbook/slides"
LECTURES_DIR="jupyterbooks/lectures"
TEMPLATES_DIR="codes/lab_01"
OUTPUT_DIR="jupyterbook/slides"
```

* Keep paths configurable.
* We’ll add flags to override.

---

### Variables

* Assign with `=`, no spaces.
* Reference with `$VAR` or `${VAR}`.
* Quote variables: `"$VAR"` to avoid word-splitting.

---

### Operations on variables

```bash
basename "/path/to/slides01.md"    # slides01.md
num="${md_base#slides}"            # remove prefix → 01.md
num="${num%.md}"                   # remove suffix → 01
echo "Number is $num"              # prints "Number is 01"
```

* The `${VAR#prefix}` and `${VAR%suffix}` syntax removes parts.
* Useful for extracting tokens from filenames.
* `echo` prints to stdout and expands variables.

----

## Loop over slide sources

```bash
shopt -s nullglob
for md in "$SLIDES_DIR"/slides*.md; do
  md_base="$(basename "$md")"     # slidesXX.md
  num="${md_base#slides}"         # XX.md
  num="${num%.md}"                # XX
  echo "Found $md_base with number $num"
done
```

* Globbing picks only matching files.
* Parameter expansion extracts the number.

---

### Loops

```bash
shopt -s nullglob         # avoid errors if no matches
for item in list; do
  # commands using $item
done
```

* Iterates over each item in the list.
* Use `shopt -s nullglob` to avoid errors if no matches.

What is a "list"?

---

### 1. Explicit values

```bash
for n in 1 2 3 4 5; do
  echo "Number: $n"
done
```

### 2. Brace expansion

```bash
for n in {01..05}; do
  echo "Slide $n"
done
```

---

### 3. "Globbing" over files

```bash
for f in slides/*.md; do
  echo "Found file: $f"
done
```

### 4. Command substitution

```bash
for user in $(cat users.txt); do
  echo "User: $user"
done
```

---

### 5. Array elements

```bash
arr=(red green blue)
for color in "${arr[@]}"; do
  echo "Color: $color"
done
```

### 6. Slices within arrays

```bash
arr=(one two three four five)
for item in "${arr[@]:1:3}"; do
  echo "Item: $item"
done
```

----

## Generate `slidesXX.html` with `sed`

```bash
sed -e "s/slidesXX\.md/$md_base/g" \
    -e "s/slideXX\.md/$md_base/g" \
    "$TEMPLATES_DIR/slides_template.html" \
    > "$OUTPUT_DIR/slides${num}.html"
```

* `-e` can stack multiple substitutions.
* We guard both `slidesXX.md` and a possible `slideXX.md` typo.
* Always quote variables.

---

### What is `sed`

* `sed` = **stream editor**
* Processes text **line by line**, applying editing commands.
* Useful for **find-and-replace**, **insertion**, **deletion**, or pattern-based edits.

---

* Reads from:

  * standard input (`echo "text" | sed ...`)
  * or files (`sed ... file.txt`)
* By default, prints the modified text to standard output.

---

### Basic syntax

```bash
sed 's/pattern/replacement/' file.txt
```

* `s` = substitute command
* Replaces the **first** match of `pattern` per line.
* Add `g` to replace **all** matches in each line:

```bash
sed 's/foo/bar/g' file.txt
```

* Output goes to the terminal. Use redirection to save it:

```bash
sed 's/foo/bar/g' file.txt > new.txt
```

---

## Common examples

```bash
# Replace all "cat" with "dog" in file
sed 's/cat/dog/g' animals.txt

# Replace only on specific lines (line 1 to 5)
sed '1,5 s/error/warning/g' log.txt

# Delete blank lines
sed '/^$/d' notes.txt

# Show only matching lines (like grep)
sed -n '/TODO/p' script.sh
```

* `/pattern/` limits action to lines that match.

---

### Using variables and escaping

When using variables, wrap the expression in double quotes:

```bash
name="Alice"
sed "s/USER/$name/g" template.txt > output.txt
```

To match special characters, **escape** them:

```bash
sed 's/file\.txt/archive.txt/' list.txt
```

---

* The option `-i` edits files **in place** (careful!):

```bash
sed -i 's/old/new/g' file.txt
```

In macOS (BSD `sed`), avoid `-i` unless you supply a backup suffix:

```bash
sed -i '' 's/foo/bar/g' file.txt   # macOS
sed -i 's/foo/bar/g' file.txt      # Linux
```

*Use `sed` in scripts for reliable, repeatable text transformations.*

----

## Check and append footer

```bash
lecture_md="$LECTURES_DIR/lecture${num}.md"
footer_block="$(sed "s/XX/$num/g" "$TEMPLATES_DIR/lecture_footer.md")"

if grep -Fq "/$OUTPUT_DIR/slides${num}.html" "$lecture_md"; then
  echo "Footer already present in $(basename "$lecture_md")"
else
  printf '\n%s\n' "$footer_block" >> "$lecture_md"
  echo "Appended footer to $(basename "$lecture_md")"
fi
```

* `grep -Fq` does a quiet fixed-string check.
* If not found, append the concrete footer.

----

# Run and verify

---

## First a dry run

```bash
./codes/lab_01/generate_slides.sh -n -v
```

* Confirms which files would be written.

---

## Execute

```bash
./codes/lab_01/generate_slides.sh -v
```

* Check outputs:

```bash
ls jupyterbook/slides/ | grep '^slides[0-9][0-9]\.html$'
```

---

## Spot-check an HTML file

```bash
head -n 40 slides/slides00.html
```

* Confirm it references `slides00.md` in the `data-markdown` attribute.

---

## Spot-check a lecture footer

```bash
tail -n +1 jupyterbooks/lectures/lecture00.md | sed -n '$-40,$p'
```

* Ensure the iframe and the “Open slides in full screen” link show `/slides/slides00.html`.

----

# Key commands explained

---

## Navigation

```bash
pwd      # print working directory
ls -la   # list with details, including hidden files
cd path  # change directory
cd -     # jump back to previous directory
```

---

## Globbing and patterns

```bash
ls jupyterbook/slides/slides*.md
# * matches any string
# ? matches a single char
# [0-9] matches a digit
```

* Use quotes around variables to avoid word-splitting.

---

## `sed` substitutions

```bash
sed 's/OLD/NEW/g' input > output
# Escaping literal dots:
sed 's/slidesXX\.md/slides07.md/g' template.html > out.html
```

* `g` means “replace all occurrences in a line.”

---

## `grep` checks

```bash
grep -Fq "/slides/slides07.html" jupyterbooks/lectures/lecture07.md
# -F fixed string, -q quiet (exit code only)
echo $?  # 0 → found, 1 → not found
```

---

## Appending text safely

```bash
printf '\n%s\n' "$footer_block" >> jupyterbooks/lectures/lecture07.md
```

* `printf` preserves newlines and avoids echo portability issues.

----

# Troubleshooting

---

## Common issues

* Wrong paths: use `-v` and echo variables.
* No matches: verify filenames are `slidesXX.md` with zero-padded numbers.
* macOS `sed`: we used portable syntax, no `-i` in place.
* Permissions: `chmod +x generate_slides.sh`.

---

## Re-run anytime

The script is idempotent for footers. It only appends when the link to the exact `slidesXX.html` is missing.

----

# Recap

---

## What we automated

* HTML landing pages from a template
* Lecture footers that embed and link to the slides
* Safe checks to avoid duplicates

---

## Takeaway

Use Bash to codify repeatable edits:

* glob files → extract tokens
* `sed` for templating
* `grep` to check state
* append only when needed

Ready to integrate into your build process or CI.
