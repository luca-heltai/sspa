#!/usr/bin/env bash
#
# Generate HTML landing pages from Markdown slides,
# then ensure each lecture file ends with the correct footer block.
#
# Usage:
#   ./generate_slides.sh [--slides-dir PATH] [--lectures-dir PATH] [--templates-dir PATH] [--output-dir PATH] [-n] [-v]
#
# Defaults match the instructor’s layout.

set -euo pipefail

# Defaults (adjustable via flags)
SLIDES_DIR="jupyterbook/slides"
LECTURES_DIR="jupyterbook/lectures"
TEMPLATES_DIR="codes/lab01"
OUTPUT_DIR="jupyterbook/slides"
BASE_URL=""
DRY_RUN=0
VERBOSE=0

log() { printf '%s\n' "$*" >&2; }
vlog() { [ "$VERBOSE" -eq 1 ] && log "$@"; }

# Parse flags
while [ $# -gt 0 ]; do
  case "$1" in
    --slides-dir)     SLIDES_DIR="$2"; shift 2;;
    --lectures-dir)   LECTURES_DIR="$2"; shift 2;;
    --templates-dir)  TEMPLATES_DIR="$2"; shift 2;;
    --output-dir)     OUTPUT_DIR="$2"; shift 2;;
    --base-url)       BASE_URL="$2"; shift 2;;
    -n|--dry-run)     DRY_RUN=1; shift;;
    -v|--verbose)     VERBOSE=1; shift;;
    -h|--help)
      sed -n '1,30p' "$0" | sed 's/^# \{0,1\}//'
      exit 0;;
    *) log "Unknown option: $1"; exit 2;;
  esac
done

HTML_TEMPLATE="$TEMPLATES_DIR/slides_template.html"
FOOTER_TEMPLATE="$TEMPLATES_DIR/lecture_footer.md"

# Checks
[ -f "$HTML_TEMPLATE" ]   || { log "Missing template: $HTML_TEMPLATE"; exit 1; }
[ -f "$FOOTER_TEMPLATE" ] || { log "Missing template: $FOOTER_TEMPLATE"; exit 1; }
[ -d "$SLIDES_DIR" ]      || { log "Missing slides dir: $SLIDES_DIR"; exit 1; }
mkdir -p "$OUTPUT_DIR"

# Create HTML from template for each slidesXX.md
shopt -s nullglob
slides=( "$SLIDES_DIR"/slides*.md )
if [ ${#slides[@]} -eq 0 ]; then
  log "No slide sources found in $SLIDES_DIR (expected files like slides00.md)."
  exit 0
fi

for md in "${slides[@]}"; do
  md_base="$(basename "$md")"                 # slidesXX.md
  num="${md_base#slides}"                     # XX.md
  num="${num%.md}"                            # XX
  html_out="$OUTPUT_DIR/slides${num}.html"    # slides/slidesXX.html
  lecture_md="$LECTURES_DIR/lecture${num}.md" # jupyterbooks/lectures/lectureXX.md

  vlog "Processing $md_base -> $html_out; lecture file: $(basename "$lecture_md")"

  # 1) Generate HTML landing page from template, replacing placeholder
  # Replace both 'slidesXX.md' and 'BASEURL' placeholders.
  if [ "$DRY_RUN" -eq 0 ]; then
    sed -e "s/slidesXX\.md/$md_base/g" \
        -e "s|BASEURL|$BASE_URL|g" \
        "$HTML_TEMPLATE" > "$html_out"
  fi
  vlog "Wrote $html_out"

  # 2) Ensure lecture footer exists and is up to date
  if [ ! -f "$lecture_md" ]; then
    log "Lecture file not found, skipping footer: $lecture_md"
    continue
  fi

  # Build the concrete footer block by substituting XX with the numeric token.
  # This covers both iframe and link occurrences.
  # Use 'printf %s' to preserve newlines exactly.
  footer_block="$(sed -e "s/XX/$num/g" -e "s|BASEURL|$BASE_URL|g" "$FOOTER_TEMPLATE")"

  # Check if the lecture already references the correct HTML slide URL.
  # If it does, we assume the footer is present.
  if grep -Fq "slides${num}.html" "$lecture_md"; then
    vlog "Footer already present in $(basename "$lecture_md")"
    # Remove any existing footer block to replace it with the updated one.
    sed -e '/<!-- FOOTER START -->/,/<!-- FOOTER END -->/d' "$lecture_md" > "${lecture_md}.tmp"
    mv "${lecture_md}.tmp" "$lecture_md"
    vlog "Removed old footer in $(basename "$lecture_md")"
  fi

  vlog "Appending footer to $(basename "$lecture_md")"
  if [ "$DRY_RUN" -eq 0 ]; then
    # Ensure the file ends with a newline, then append a blank line and the footer.
    # Also insert a horizontal separator if the file already has content.
    if [ -s "$lecture_md" ]; then
      sed '${/^$/d;}' "$lecture_md" > "${lecture_md}.tmp"   # remove last blank line if present
      mv "${lecture_md}.tmp" "$lecture_md"
      printf '\n' >> "$lecture_md"
    fi
    printf '%s\n' "$footer_block" >> "$lecture_md"
  fi
done

log "Done."
