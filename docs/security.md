# Security

* Do not commit private keys, passwords, tokens, or proprietary firmware.
* Use SSH public-key authentication and a dedicated tunnel account.
* Pin the VPS host key with `SSH_KNOWN_HOSTS`.
* Keep private keys mode 0600 and outside source-controlled configuration.
* Restrict reverse forwarding on the VPS and use `ExitOnForwardFailure`.
* Bind management services to a private interface or management VPN.
* Rotate logs and avoid printing command arguments containing secrets.
* Verify source revisions and SHA-256 checksums for releases.
