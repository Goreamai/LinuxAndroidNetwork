# Hardware audit: SM-T285

This record is based on read-only ADB output from the user's running rooted
LineageOS installation. It is not a flash or boot test.

| Item | Observed value |
|---|---|
| Model / device | SM-T285 / `gtexslte` |
| Board property | `8830` |
| Hardware revision | `3` |
| RAM | 1536 MiB |
| Running kernel | Linux 3.10.107, ARMv7, SMP/PREEMPT |
| Bootloader | `T285DDU0AQL3` |
| Kernel partition | `mmcblk0p20` (`KERNEL`, 16 MiB) |
| Recovery partition | `mmcblk0p21` (`RECOVERY`, 16 MiB) |
| System partition | `mmcblk0p25` (2 GiB, ext4, read-only while running) |
| Userdata partition | `mmcblk0p27` (about 5 GiB, ext4) |
| Cache partition | `mmcblk0p24` (200 MiB, ext4) |
| EFS partition | `mmcblk0p17` (20 MiB, ext4) |
| Wi-Fi module | `sprdwl` |
| Wi-Fi firmware/log identifier | SC2331 |
| Captured network interfaces | `p2p0` present; no `wlan0` in the captured state |

The Android kernel and vendor stack clearly support Wi-Fi through `sprdwl`,
`wpa_supplicant`, and SC2331 commands: the audit captured scans, association,
RSSI queries, disconnect/reconnect, and a DHCP-style IPv4 notification. This
proves functional Wi-Fi in the current Android stack only. It does not prove
that the vendor module, firmware, Android HAL, or regulatory setup can be
reused by a standalone Linux root filesystem.

The partition map confirms that a future boot-image experiment must preserve
the working `KERNEL`, `RECOVERY`, `SYSTEM`, `EFS`, and `userdata` partitions.
No partition was written during this audit.
