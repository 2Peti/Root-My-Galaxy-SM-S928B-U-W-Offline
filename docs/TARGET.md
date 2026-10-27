# Supported target: SM-S928B

| Field | Value |
| --- | --- |
| Model | `SM-S928B` |
| Firmware | `S928BXXS6DZF2` or `S928BXXU5DZDP` |
| Device | `e3q` |
| Product | `e3qxxx` (DZF2) or `e3qxeea` (U5DZDP) |
| Build display | `BP4A.251205.006.S928BXXS6DZF2` or `BP4A.251205.006.S928BXXU5DZDP` |
| Fingerprint | DZF2: `samsung/e3qxxx/e3q:16/BP4A.251205.006/S928BXXS6DZF2:user/release-keys`; U5DZDP: `samsung/e3qxeea/e3q:16/BP4A.251205.006/S928BXXU5DZDP:user/release-keys` |
| Kernel release | `6.1.145-android14-11-33419968-abS928BXXS6DZF2` or `6.1.145-android14-11-33419968-abS928BXXU5DZDP` |
| Payload profile | `e3q-S928BXXS6DZF2` |

The app rejects models, firmware tokens, and kernel releases outside these two
tested S928B profiles. The payload is per-boot; rebooting removes the loaded
KernelSU module.
