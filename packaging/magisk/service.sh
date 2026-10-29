#!/system/bin/sh
set -u

BASE=/data/adb/nexus
CONF="$BASE/nexus.conf"
LOG="$BASE/nexus.log"
SSH=/system/bin/ssh

log() {
    /system/bin/log -t nexus "$*" 2>/dev/null || echo "nexus: $*" >> "$LOG"
}

[ -r "$CONF" ] || { log "configuration missing"; exit 0; }
[ -x "$SSH" ] || { log "Android ssh binary missing"; exit 0; }

# The config is sourced only after a strict allow-list check. Values are
# restricted to characters needed by hostnames, ports, and absolute paths.
/system/bin/grep -qvE '^(REMOTE_HOST|REMOTE_PORT|SSH_USER|SSH_KEY|SSH_KNOWN_HOSTS|REMOTE_BIND_HOST|REMOTE_BIND_PORT|LOCAL_HOST|LOCAL_PORT|RECONNECT_DELAY)="[A-Za-z0-9._:/-]+"$' "$CONF" && {
    log "invalid configuration syntax"
    exit 1
} || :

# shellcheck disable=SC1090
. "$CONF"

: "${REMOTE_HOST:?missing REMOTE_HOST}"
: "${REMOTE_PORT:?missing REMOTE_PORT}"
: "${SSH_USER:?missing SSH_USER}"
: "${SSH_KEY:?missing SSH_KEY}"
: "${SSH_KNOWN_HOSTS:?missing SSH_KNOWN_HOSTS}"
: "${REMOTE_BIND_HOST:?missing REMOTE_BIND_HOST}"
: "${REMOTE_BIND_PORT:?missing REMOTE_BIND_PORT}"
: "${LOCAL_HOST:?missing LOCAL_HOST}"
: "${LOCAL_PORT:?missing LOCAL_PORT}"

umask 077
mkdir -p "$BASE"
while :; do
    "$SSH" -N -T \
        -o BatchMode=yes \
        -o ExitOnForwardFailure=yes \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -o ConnectTimeout=15 \
        -o StrictHostKeyChecking=yes \
        -i "$SSH_KEY" \
        -o "UserKnownHostsFile=$SSH_KNOWN_HOSTS" \
        -R "$REMOTE_BIND_HOST:$REMOTE_BIND_PORT:$LOCAL_HOST:$LOCAL_PORT" \
        -p "$REMOTE_PORT" "$SSH_USER@$REMOTE_HOST" >> "$LOG" 2>&1
    log "tunnel exited; retrying"
    /system/bin/sleep "${RECONNECT_DELAY:-5}"
done
