# Architecture

## Runtime

The appliance consists of BusyBox/POSIX-compatible service scripts, a
declarative `/etc/nexus/nexus.conf`, and a small set of external tools:
`ip`, `udhcpc`, `nslookup` or `getent`, `ssh`, and `logger`. The scripts are
intentionally shell-based so they can run on ARMv7 without a language runtime.

At boot:

1. Validate configuration.
2. Bring up the configured interface and DHCP.
3. Check DNS and the remote endpoint.
4. Start and supervise the reverse SSH tunnel.

The service exits on invalid configuration rather than silently starting with
unsafe defaults. Secrets are referenced by file path and never placed in the
example configuration.

## Tunnel

The default path is:

```text
Minecraft client -> VPS:public_port
  -> sshd reverse forwarding
  -> tablet/home LAN -> Windows laptop:local_port
```

The VPS must explicitly permit the forwarding account and bind the reverse
listener. The tablet makes only an outbound connection, which fits CGNAT.
WireGuard is not selected by default because it is a routed VPN, not a public
TCP relay by itself, and the audited downstream defconfig does not establish
an available WireGuard implementation.

## Security

Use a dedicated non-root tunnel account, a pinned host key, a private key with
mode 0600, `ExitOnForwardFailure`, and a restricted remote `authorized_keys`
entry. The management plane is SSH-first; no unauthenticated web service is
included.
