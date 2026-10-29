#!/bin/sh
set -eu

ARCHIVE=${1:-}
DEST=${NEXUS_CONF_ROOT:-/etc/nexus}

[ -n "$ARCHIVE" ] || {
    echo "usage: $0 ARCHIVE" >&2
    exit 2
}
[ -r "$ARCHIVE" ] || {
    echo "archive not readable: $ARCHIVE" >&2
    exit 1
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

tar -tf "$ARCHIVE" | awk '
    $0 !~ /^nexus(\/|$)/ || $0 ~ /(^|\/)\.\.(\/|$)/ { exit 1 }
' || {
    echo "archive contains unsafe paths" >&2
    exit 1
}
tar -C "$TMP" -xf "$ARCHIVE"
[ -f "$TMP/nexus/nexus.conf" ] || {
    echo "archive lacks nexus.conf" >&2
    exit 1
}
NEXUS_CONFIG="$TMP/nexus/nexus.conf" NEXUS_LIBEXEC="${NEXUS_LIBEXEC:-/usr/lib/nexus}" \
    sh -c '. "$NEXUS_LIBEXEC/config.sh"'

mkdir -p "$DEST"
cp -R "$TMP/nexus/." "$DEST/"
chmod 0600 "$DEST"/ssh/* 2>/dev/null || :
echo "restored $DEST"
