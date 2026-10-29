# Recovery and hardware inspection

Only read-only inspection is authorized during initial development. Do not
unlock, repartition, wipe, flash, change modem firmware, or overwrite TWRP.

With the existing rooted LineageOS installation and ADB authorized, collect:

```sh
adb shell getprop | grep -E 'ro.product.(model|device|board)|ro.boot'
adb shell uname -a
adb shell cat /proc/cmdline
adb shell cat /proc/partitions
adb shell mount
adb shell ls -l /dev/block/platform/*/by-name
adb shell ip link
adb shell lsmod
adb shell dmesg | grep -iE 'wifi|sprd|sc23|firmware|watchdog'
```

Save output privately, review it for identifiers, and record only the
technical facts needed by `docs/feasibility.md`. Any future flash proposal
must include provenance, target partition, checksum, backup, recovery path,
failure modes, and an explicit approval request.

The first audit confirmed that `KERNEL` is `mmcblk0p20` and `RECOVERY` is
`mmcblk0p21`. These names are documentation only; do not write either
partition during development.
