#!/bin/sh
set -eu

BASE=${NEXUS_LIBEXEC:-/usr/lib/nexus}
. "$BASE/config.sh"

log() { logger -t nexus "$*" 2>/dev/null || echo "nexus: $*" >&2; }

while :; do
    "$BASE/health.sh" || log "health check failed; retrying tunnel"
    "$BASE/tunnel.sh" || log "tunnel exited; reconnecting in ${RECONNECT_DELAY}s"
    sleep "$RECONNECT_DELAY"
done
