# Testing

Host tests run without Android tools, network access, or a tablet:

```sh
make test
make stage
```

They cover configuration validation, rejection of injected configuration
syntax, interface/DNS health checks, and the exact reverse-SSH forwarding
arguments. `scripts/inspect-adb.sh` is a hardware-dependent, read-only helper;
its output must not be treated as proof that Linux boots.

The GitHub Actions workflow runs the same host tests on every push and pull
request. No hardware-dependent test runs in CI.
