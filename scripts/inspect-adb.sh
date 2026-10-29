#!/bin/sh
set -eu

command -v adb >/dev/null 2>&1 || {
    echo "adb is required on the host" >&2
    exit 1
}

echo "== model and boot properties =="
adb shell getprop | grep -E 'ro.product.(model|device|board)|ro.boot' || :
echo "== kernel and command line =="
adb shell uname -a
adb shell cat /proc/cmdline
echo "== partitions and mounts =="
adb shell cat /proc/partitions
adb shell mount
echo "== named block devices =="
adb shell 'ls -l /dev/block/platform/*/by-name 2>/dev/null || true'
echo "== network and modules =="
adb shell ip link
adb shell 'lsmod 2>/dev/null || true'
echo "== relevant kernel messages =="
adb shell 'dmesg 2>/dev/null | grep -iE "wifi|sprd|sc23|firmware|watchdog" || true'
