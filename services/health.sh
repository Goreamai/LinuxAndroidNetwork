#!/bin/sh
set -eu

BASE=${NEXUS_LIBEXEC:-/usr/lib/nexus}
. "$BASE/config.sh"

log() { logger -t nexus "$*" 2>/dev/null || echo "nexus: $*" >&2; }

ip link show "$INTERFACE" >/dev/null 2>&1 || {
    log "interface unavailable: $INTERFACE"
    exit 1
}

ip addr show dev "$INTERFACE" | grep -q 'inet ' || {
    log "interface has no IPv4 address: $INTERFACE"
    exit 1
}

if command -v getent >/dev/null 2>&1; then
    getent hosts "$REMOTE_HOST" >/dev/null 2>&1 || {
        log "DNS resolution failed: $REMOTE_HOST"
        exit 1
    }
fi

log "network healthy: interface=$INTERFACE remote=$REMOTE_HOST"
