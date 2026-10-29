# Build guide

## Host prerequisites

The host build only requires POSIX `sh`, `make`, and standard Unix utilities.
The eventual device image additionally needs an ARMHF cross-toolchain,
BusyBox, the exact downstream kernel source, and a boot-image tool matching
Samsung's format. Those inputs are deliberately not downloaded implicitly.

```sh
make test
make stage
find build/rootfs -type f -print
```

The resulting tree is a packaging input, not a flashable image. A future image
builder must record the kernel commit, defconfig, DTB/DTBO inputs, rootfs
source revisions, and SHA-256 checksums.

The Android hybrid package can be assembled without a device:

```sh
make magisk-package
sha256sum build/nexus-hybrid.zip
```

The archive contains no configuration, key, firmware, boot image, or
proprietary blob. It is not hardware-tested and must not be installed without
the safety and approval process in `docs/recovery-guide.md`.

The read-only device inventory helper is:

```sh
scripts/inspect-adb.sh > gtexslte-adb-inventory.txt
sha256sum gtexslte-adb-inventory.txt
```

It does not issue a write, reboot, bootloader, or flash command.

## Cross-build boundary

The service scripts do not compile native code. Copying them into an ARMHF
rootfs is safe once the target provides the named utilities. The first
device-specific integration should use a serial/ADB-enabled development image
and a separate test partition or recovery workflow; it must not overwrite the
working LineageOS installation.
