#!/usr/bin/env bash
set -euo pipefail

LAB_ROOT=$(cd "$(dirname "$0")" && pwd)
BIN_DIR="${WORK:-$LAB_ROOT}/bin"
mkdir -p "$BIN_DIR"

TARGET="$BIN_DIR/vec_add"

g++ -O3 -march=native -std=c++17 "$LAB_ROOT/vec_add.cpp" -o "$TARGET"

echo "Built $TARGET"

if [[ "${1:-}" == "run" ]]; then
  "$TARGET" --size 1000000
fi
