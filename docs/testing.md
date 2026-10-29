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

`scripts/android-readonly-audit.sh` is intended to be copied to
`/data/local/tmp` and run manually; it only reads Android properties, files,
modules, device nodes, and interfaces. The Magisk package under
`packaging/magisk/` is not hardware-tested.

The GitHub Actions workflow runs the same host tests on every push and pull
request. No hardware-dependent test runs in CI.
