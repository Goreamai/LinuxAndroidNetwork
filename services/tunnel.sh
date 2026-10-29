#!/bin/sh
set -eu

BASE=${NEXUS_LIBEXEC:-/usr/lib/nexus}
. "$BASE/config.sh"

log() { logger -t nexus "$*" 2>/dev/null || echo "nexus: $*" >&2; }

[ -r "$SSH_KEY" ] || { log "SSH key missing: $SSH_KEY"; exit 1; }
[ -r "$SSH_KNOWN_HOSTS" ] || { log "known_hosts missing: $SSH_KNOWN_HOSTS"; exit 1; }

umask 077
exec ssh \
    -N \
    -T \
    -o BatchMode=yes \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=3 \
    -o ConnectTimeout=15 \
    -o StrictHostKeyChecking=yes \
    -i "$SSH_KEY" \
    -o "UserKnownHostsFile=$SSH_KNOWN_HOSTS" \
    -R "$REMOTE_BIND_HOST:$REMOTE_BIND_PORT:$LOCAL_HOST:$LOCAL_PORT" \
    -p "$REMOTE_PORT" \
    "$SSH_USER@$REMOTE_HOST"
