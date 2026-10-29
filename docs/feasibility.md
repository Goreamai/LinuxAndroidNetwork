# Feasibility report

## Decision

The initial implementation uses **option B**: a small ARMHF Linux userspace
with the tablet's compatible downstream kernel and boot chain. This is more
honest and safer than calling an Android chroot a replacement OS, while
avoiding an unbounded mainline port.

The kernel source audit found:

* The device tree identifies the target as Samsung Galaxy Tab A 7.0 LTE,
  model SM-T285, codename `gtexslte`, chipset “Spreadtrum sc9830 (SCX35L)” and
  an SC8830 Cortex-A7 quad core at 1.5 GHz.
* The published kernel is Linux **3.10.65** and provides
  `arch/arm/configs/gtexslte_defconfig`.
* The Android device tree includes `dt.img`, `fstab.sc8830`, and a
  `mkbootimg` recipe using a 2048-byte page size, base 0, `zImage`, `dt.img`,
  and `seandroid.img`.
* The build guide explicitly distinguishes `gtexslte`/SM-T285 from the
  Wi-Fi-only `gtexswifi`/SM-T280 and documents a downstream kernel rebuild.

Sources:

* [Device tree](https://github.com/jedld/device_samsung_gtexslte)
* [Kernel source](https://github.com/jedld/kernel_samsung_gtexslte)
* [Kernel defconfig](https://github.com/jedld/kernel_samsung_gtexslte/blob/master/arch/arm/configs/gtexslte_defconfig)
* [Build guide](https://github.com/lineage-gtexslte/build_guide)
* [Recovery device tree](https://github.com/SHRP-Devices/device_samsung_gtexslte)
* [postmarketOS device index](https://wiki.postmarketos.org/wiki/Devices)
* [Spreadtrum vendor source](https://github.com/jedld/vendor_sprd_9830)

## What is not established yet

No evidence currently proves that a mainline kernel boots this exact LTE
variant, that the vendor Wi-Fi driver can be used outside Android, or that a
Linux root filesystem has been booted on this tablet. The Android source tree
also contains proprietary firmware and vendor services; their redistribution
and licensing must be audited before packaging.

The downstream kernel defconfig is old and does not by itself prove support for
WireGuard, modern nftables, hardware watchdogs, suspend/resume, or a usable
Linux userspace. The first target should therefore be a wired/ADB-assisted
bring-up and read-only diagnostics, followed by Wi-Fi and power validation.

The physical audit now confirms the exact partition names and locations:
`KERNEL` is `mmcblk0p20`, `RECOVERY` is `mmcblk0p21`, `SYSTEM` is
`mmcblk0p25`, and `userdata` is `mmcblk0p27`. It also confirms the vendor
`sprdwl` module and SC2331 Wi-Fi command path. Wi-Fi was observed working in
Android, but no `wlan0` interface was present in the captured state, so Linux
userspace Wi-Fi integration remains unproven. See
[hardware-audit.md](hardware-audit.md).

## Architecture comparison

| Option | Assessment |
|---|---|
| postmarketOS/mainline | Best long-term direction, but exact LTE support and Wi-Fi are not established |
| Minimal Linux + downstream kernel | Selected; reuses the known device kernel while keeping a real Linux userspace |
| Stripped Android image | Fallback only if the downstream kernel cannot boot a non-Android rootfs |
| Android chroot | Development bridge only; not an appliance OS |

## Gates before any image is called bootable

1. Read-only ADB inventory confirms model, board, kernel, partitions, mounts,
   firmware, and interface names.
2. The exact kernel and DTB provenance are recorded with checksums.
3. A recovery backup and a tested recovery path exist.
4. A boot image is built without flashing and inspected with an image parser.
5. The user explicitly approves a reversible boot experiment.
