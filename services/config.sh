#!/bin/sh
set -eu

CONF=${NEXUS_CONFIG:-/etc/nexus/nexus.conf}

die() {
    echo "nexus: $*" >&2
    exit 1
}

[ -r "$CONF" ] || die "configuration not readable: $CONF"

awk -F= '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    NF != 2 || $1 !~ /^[A-Z][A-Z0-9_]*$/ || $2 !~ /^"[^"]*"$/ { exit 1 }
    $1 !~ /^(INTERFACE|HOSTNAME|DNS_NAME|REMOTE_HOST|REMOTE_PORT|SSH_USER|SSH_KEY|SSH_KNOWN_HOSTS|REMOTE_BIND_HOST|REMOTE_BIND_PORT|LOCAL_HOST|LOCAL_PORT|CHECK_INTERVAL|RECONNECT_DELAY)$/ { exit 1 }
' "$CONF" || die "invalid configuration syntax or key"

# shellcheck disable=SC1090
. "$CONF"

require_var() {
    eval "value=\${$1-}"
    [ -n "$value" ] || die "missing configuration: $1"
}

for name in INTERFACE REMOTE_HOST REMOTE_PORT SSH_USER SSH_KEY SSH_KNOWN_HOSTS \
    REMOTE_BIND_HOST REMOTE_BIND_PORT LOCAL_HOST LOCAL_PORT CHECK_INTERVAL RECONNECT_DELAY
do
    require_var "$name"
done

case "$REMOTE_HOST$SSH_USER$LOCAL_HOST$REMOTE_BIND_HOST" in
    *[!A-Za-z0-9._:-]*) die "unsafe hostname or user value" ;;
esac

case "$REMOTE_PORT$REMOTE_BIND_PORT$LOCAL_PORT$CHECK_INTERVAL$RECONNECT_DELAY" in
    ''|*[!0-9]*) die "ports and intervals must be decimal integers" ;;
esac

case "$SSH_KEY$SSH_KNOWN_HOSTS" in
    *[!A-Za-z0-9_./:-]*) die "unsafe key path" ;;
esac

validate_config() {
    [ "$REMOTE_PORT" -ge 1 ] && [ "$REMOTE_PORT" -le 65535 ] || die "invalid REMOTE_PORT"
    [ "$REMOTE_BIND_PORT" -ge 1 ] && [ "$REMOTE_BIND_PORT" -le 65535 ] || die "invalid REMOTE_BIND_PORT"
    [ "$LOCAL_PORT" -ge 1 ] && [ "$LOCAL_PORT" -le 65535 ] || die "invalid LOCAL_PORT"
    [ "$CHECK_INTERVAL" -ge 1 ] || die "CHECK_INTERVAL must be positive"
    [ "$RECONNECT_DELAY" -ge 1 ] || die "RECONNECT_DELAY must be positive"
}

validate_config
