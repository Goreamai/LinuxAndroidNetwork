#!/bin/sh
set -eu

CONF_ROOT=${NEXUS_CONF_ROOT:-/etc/nexus}
OUT=${1:-nexus-config.tar}

[ -d "$CONF_ROOT" ] || {
    echo "configuration directory missing: $CONF_ROOT" >&2
    exit 1
}

tar -C "$(dirname "$CONF_ROOT")" -cf "$OUT" "$(basename "$CONF_ROOT")"
echo "wrote $OUT"
