#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cat > "$TMP/nexus.conf" <<'EOF'
INTERFACE="lo"
REMOTE_HOST="localhost"
REMOTE_PORT="22"
SSH_USER="nexus"
SSH_KEY="/tmp/key"
SSH_KNOWN_HOSTS="/tmp/known_hosts"
REMOTE_BIND_HOST="127.0.0.1"
REMOTE_BIND_PORT="25565"
LOCAL_HOST="127.0.0.1"
LOCAL_PORT="25565"
CHECK_INTERVAL="30"
RECONNECT_DELAY="5"
EOF
NEXUS_CONFIG="$TMP/nexus.conf" NEXUS_LIBEXEC="$ROOT/services" \
    sh "$ROOT/services/health.sh"
echo "health: ok"
