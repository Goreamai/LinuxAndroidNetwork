# Wi-Fi feasibility: `sprdwl` / SC2331

## Verified evidence

The physical audit confirms that the running SM-T285 loads `sprdwl` and emits
SC2331 commands while Android performs scans, association, RSSI queries, and
disconnect/reconnect operations. This is proof of Wi-Fi operation in the
installed Android stack, not proof of standalone Linux operation.

The exact device source tree identifies the Wi-Fi/Bluetooth combination as
`sc2331/marlin` and configures:

* `sprdwl.ko` as the kernel module
* `NL80211` plus the private `lib_driver_cmd_sprdwl` library for both
  `wpa_supplicant` and `hostapd`
* firmware mode parameters under `/data/misc/wifi/fwpath`
* firmware files `sc2331_fdl.bin` and `sc2331_fw.bin`
* calibration/configuration files under `/system/etc` and `/productinfo`
* the Marlin WCN controller and `wcnd` service

The downstream kernel's external Wi-Fi module is not a generic mac80211
driver. Its source calls vendor SDIO/WCN APIs such as `sdio_dev_read`,
`sdio_dev_write`, `set_marlin_wakeup`, `set_marlin_sleep`, and
`get_sdiohal_status`, reads a `sprd-marlin` device-tree node, and uses a GPIO
interrupt. The kernel config enables `CFG80211` but explicitly does not enable
`MAC80211`; this is consistent with a vendor cfg80211 driver rather than a
portable mac80211 implementation.

Sources:

* [Exact gtexslte device README](https://github.com/jedld/device_samsung_gtexslte/blob/cm-14.1/README.md)
* [Exact gtexslte BoardConfig](https://github.com/jedld/device_samsung_gtexslte/blob/cm-14.1/BoardConfig.mk)
* [Exact gtexslte Wi-Fi init rules](https://github.com/jedld/device_samsung_gtexslte/blob/cm-14.1/init.wifi.rc)
* [Exact downstream kernel Wi-Fi module](https://github.com/jedld/kernel_samsung_gtexslte/tree/master/external_module/wifi)
* [Exact kernel build script](https://github.com/jedld/kernel_samsung_gtexslte/blob/master/build_kernel.sh)
* [Spreadtrum SC2331 vendor source](https://github.com/jedld/vendor_sprd_9830/tree/master/modules/wcn/wlan)

## Required interfaces and dependencies

| Layer | Evidence / requirement |
|---|---|
| Kernel | Matching 3.10 downstream kernel, `CFG80211`, vendor SDIO/WCN extensions, `sprdwl.ko`, device-tree `sprd-marlin` node |
| Firmware | `sc2331_fdl.bin`, `sc2331_fw.bin`, plus Marlin connectivity configuration/calibration |
| Android services | `wcnd`, WCN device nodes, properties such as `/dev/cpwcn`, `/dev/stty_wcn`, `/dev/slog_wcn`, and reset/control paths |
| Userspace | Android `wpa_supplicant`/`hostapd` private driver library `lib_driver_cmd_sprdwl`, Android init permissions, vendor toolbox/property behavior |
| Policy and files | Android SELinux labels/permissions, `/system/etc/firmware`, `/productinfo`, `/data/misc/wifi` |

## Assessment

**Standalone Linux with functional Wi-Fi:** not currently demonstrated. Porting
would require preserving or reimplementing the downstream kernel/WCN contract,
packaging proprietary firmware and calibration files, and replacing the
Android-specific controller and private supplicant integration. No public
working postmarketOS/Linux port for this exact LTE device was found in the
audited sources.

**Minimal Android appliance:** technically the lowest-risk route because it
retains the verified Wi-Fi stack, firmware, WCN service, and permissions. It
still inherits Android 7.1.2 and its security limitations, so it must be
minimalized and tunnel-focused rather than described as a new Linux OS.

**Hybrid Android + NEXUS services:** recommended near-term route. Keep Android
and its Wi-Fi control plane, run a small SSH tunnel supervisor and diagnostics
from a reversible root/Magisk package, and use the Linux userspace only for
host testing and future kernel bring-up. This avoids claiming that a chroot is
a replacement OS.

## Unresolved questions

* Whether the exact installed vendor blobs and `sprdwl.ko` ABI match the
  published source revision.
* Whether the Android `ssh` binary and kernel support the required reverse
  forwarding reliably under deep sleep.
* Whether an ARMHF standalone rootfs can load the vendor module while retaining
  all WCN services and device nodes.
* Whether the vendor firmware/calibration files may be redistributed.

## Safe next experiments

1. Read-only inventory of Android binary paths, module vermagic, firmware
   filenames, WCN device nodes, and current interface names.
2. Host-side cross-build of the tunnel supervisor and a Magisk package.
3. Run the supervisor manually from `/data/local/tmp` without persistence or
   partition writes.
4. Measure reconnect behavior and sleep/wake behavior before considering any
   persistent service installation.
