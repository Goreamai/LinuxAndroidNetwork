#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
touch "$TMP/key" "$TMP/known_hosts"
chmod 600 "$TMP/key"
cat > "$TMP/nexus.conf" <<EOF
INTERFACE="lo"
REMOTE_HOST="localhost"
REMOTE_PORT="2222"
SSH_USER="nexus"
SSH_KEY="$TMP/key"
SSH_KNOWN_HOSTS="$TMP/known_hosts"
REMOTE_BIND_HOST="127.0.0.1"
REMOTE_BIND_PORT="25565"
LOCAL_HOST="127.0.0.1"
LOCAL_PORT="25565"
CHECK_INTERVAL="30"
RECONNECT_DELAY="5"
EOF
cat > "$TMP/ssh" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" > "$NEXUS_SSH_ARGS"
exit 0
EOF
chmod 755 "$TMP/ssh"
NEXUS_CONFIG="$TMP/nexus.conf" NEXUS_LIBEXEC="$ROOT/services" \
NEXUS_SSH_ARGS="$TMP/args" PATH="$TMP:$PATH" sh "$ROOT/services/tunnel.sh"
grep -q -- '-R 127.0.0.1:25565:127.0.0.1:25565' "$TMP/args"
grep -q -- 'nexus@localhost' "$TMP/args"
echo "tunnel: ok"
