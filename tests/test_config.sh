#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cp "$ROOT/configs/nexus.conf.example" "$TMP/nexus.conf"
NEXUS_CONFIG="$TMP/nexus.conf" NEXUS_LIBEXEC="$ROOT/services" \
    sh -c '. "$NEXUS_LIBEXEC/config.sh"; [ "$REMOTE_BIND_PORT" = 25565 ]'
sed 's/REMOTE_PORT="22"/REMOTE_PORT="bad"/' "$TMP/nexus.conf" > "$TMP/bad.conf"
if NEXUS_CONFIG="$TMP/bad.conf" NEXUS_LIBEXEC="$ROOT/services" \
    sh -c '. "$NEXUS_LIBEXEC/config.sh"' 2>/dev/null; then
    echo "invalid port accepted" >&2
    exit 1
fi
printf '%s\n' 'REMOTE_PORT="22"; touch /tmp/nexus-config-injection' >> "$TMP/nexus.conf"
if NEXUS_CONFIG="$TMP/nexus.conf" NEXUS_LIBEXEC="$ROOT/services" \
    sh -c '. "$NEXUS_LIBEXEC/config.sh"' 2>/dev/null; then
    echo "invalid syntax accepted" >&2
    exit 1
fi
echo "config: ok"
