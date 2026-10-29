# Networking

## Configuration

Copy `configs/nexus.conf.example` to `/etc/nexus/nexus.conf` and set values
appropriate for the home LAN and relay. The parser accepts shell-style
`KEY=VALUE` assignments but rejects unknown keys and unsafe values.

## Relay requirements

The VPS needs an SSH account restricted to TCP forwarding, a public listener
port, and an `sshd_config` policy that permits the requested reverse forward.
The VPS firewall should expose only the Minecraft port and the management VPN
or SSH port. The Windows laptop must accept the local connection from the
tablet's LAN address.

Reverse SSH adds relay and encryption overhead; it does not promise lower
latency. Measure client-to-server latency and throughput before and after the
deployment, including the VPS region and failure-reconnect time.
