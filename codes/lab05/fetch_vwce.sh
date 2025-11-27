#!/usr/bin/env bash
set -euo pipefail

SYMBOL=${SYMBOL:-"VWCE.DE"}
OUT=${OUT:-"vwce_2024.csv"}
RETRIES=${RETRIES:-5}
SLEEP_BASE=${SLEEP_BASE:-3}

# Alternative source (no auth): Stooq daily prices (may lag slightly)
STOOQ_SYMBOL=$(printf "%s" "${SYMBOL}" | tr '[:upper:]' '[:lower:]')
STOOQ_URL="https://stooq.pl/q/d/l/?s=${STOOQ_SYMBOL}&i=d"

echo "Downloading ${SYMBOL} daily data to ${OUT}..."

curl_opts=(
  -fL
  --compressed
  -H "User-Agent: Mozilla/5.0 (compatible; SSPA-lab/1.0)"
)

if [ -n "${COOKIE_FILE}" ]; then
  curl_opts+=(-b "${COOKIE_FILE}")
fi

attempt=1
while :; do
  echo "Attempt ${attempt}: Stooq fallback..."
  if curl "${curl_opts[@]}" "${STOOQ_URL}" -o "${OUT}"; then
    echo "Done via Stooq (note: may have slightly different fields/coverage)."
    # Normalize Stooq's Polish headers to Yahoo-like headers and add Adj Close = Close.
    tmp=$(mktemp)
    mv "${OUT}" "${tmp}"
    awk 'BEGIN{FS=OFS=","}
         NR==1 && $1=="Data" {print "Date,Open,High,Low,Close,Adj Close,Volume"; next}
         {print $1,$2,$3,$4,$5,$5,$6}' "${tmp}" > "${OUT}"
    rm -f "${tmp}"
    exit 0
  fi

  if [ "$attempt" -ge "$RETRIES" ]; then
    echo "Failed after ${RETRIES} attempts. Try again later or adjust SYMBOL." >&2
    echo "As a fallback, use the bundled vwce_2024.csv provided in this repo." >&2
    exit 1
  fi

  sleep_time=$((SLEEP_BASE * attempt))
  echo "Attempt ${attempt} failed (possible rate limit). Sleeping ${sleep_time}s before retry..." >&2
  sleep "${sleep_time}"
  attempt=$((attempt + 1))
done
