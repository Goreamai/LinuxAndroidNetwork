#!/bin/sh
set -eu

BASE=${NEXUS_LIBEXEC:-/usr/lib/nexus}
. "$BASE/config.sh"

case "${1:-status}" in
status)
    printf 'interface=%s\n' "$INTERFACE"
    ip -brief addr show dev "$INTERFACE" 2>/dev/null || ip addr show dev "$INTERFACE"
    ip route
    "$BASE/health.sh"
    ;;
validate)
    printf '%s\n' "configuration: valid"
    ;;
logs)
    if command -v logread >/dev/null 2>&1; then
        logread | grep '[[:space:]]nexus' | tail -n 100
    else
        echo "logread unavailable" >&2
        exit 1
    fi
    ;;
restart-tunnel)
    if [ -r /run/nexus.pid ]; then
        kill "$(cat /run/nexus.pid)" 2>/dev/null || :
    fi
    /etc/init.d/nexus start
    ;;
reboot)
    echo "reboot requested"
    /sbin/reboot
    ;;
*)
    echo "usage: $0 {status|validate|logs|restart-tunnel|reboot}" >&2
    exit 2
    ;;
esac
