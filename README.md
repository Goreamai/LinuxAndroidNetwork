# NEXUS

NEXUS (Network Edge eXecution Utility System) is a minimal, headless networking
appliance project for the Samsung Galaxy Tab A 7.0 LTE **SM-T285
(`gtexslte`)**.

The project does not flash or modify a tablet. It currently produces and tests
an architecture-neutral root filesystem staging tree and configuration for a
32-bit ARM downstream-kernel appliance. Device boot and hardware validation
remain gated on a safe, read-only inspection and an explicitly approved
experiment.

## Status

| Area | State |
|---|---|
| Exact device identification and source audit | Implemented and documented |
| ARMHF userspace layout and service configuration | Implemented and host-tested |
| Network diagnostics and configuration validation | Implemented and host-tested |
| Reverse SSH tunnel supervisor | Implemented; integration-testable with a local relay |
| Device-specific Linux image | Not built: kernel/rootfs integration is hardware-dependent |
| Native Linux boot, Wi-Fi, LTE, and tunnel on SM-T285 | Not hardware-tested |

## Quick start

```sh
make test
make stage
```

`make stage` creates `build/rootfs/`, a reproducible staging tree containing
the appliance services and example configuration. It does not create a flashable
image. See [docs/feasibility.md](docs/feasibility.md) and
[docs/build-guide.md](docs/build-guide.md).

## Design

The default production tunnel is an outbound, persistent reverse SSH TCP
forward from the tablet to a reachable VPS. Minecraft clients connect to the
VPS's ordinary TCP port; the VPS forwards that connection through SSH to the
Windows laptop reachable from the tablet's home Wi-Fi. WireGuard remains an
optional future transport only after kernel support is verified on the exact
device.

Read-only hardware inspection is described in
[docs/recovery-guide.md](docs/recovery-guide.md). No document in this
repository authorizes flashing, repartitioning, wiping, or bootloader changes.
