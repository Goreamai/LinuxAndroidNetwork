#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
OUT=${1:-"$ROOT/../../build/nexus-hybrid.zip"}

command -v zip >/dev/null 2>&1 || {
    echo "zip is required to build the package" >&2
    exit 1
}

mkdir -p "$(dirname "$OUT")"
(
    cd "$ROOT"
    zip -q -j "$OUT" module.prop service.sh
)
echo "$OUT"
