# NEXUS Android hybrid package

This directory is a **build artifact template only**. It is not installed on
the tablet by this repository and does not authorize a Magisk installation.

The package keeps Android's existing Wi-Fi/WCN stack and starts only the
outbound NEXUS reverse-SSH supervisor after Android networking is available.
Place the device-specific configuration and SSH key under
`/data/adb/nexus/`; never put secrets in Git.

Before any future use, test the scripts manually from `/data/local/tmp`, take
an appropriate recovery backup, verify checksums, and obtain explicit approval.
