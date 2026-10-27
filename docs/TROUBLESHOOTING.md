# Troubleshooting — SM-S928B DZF2 / U5DZDP

## Device mismatch

The app requires all three values:

```text
model: SM-S928B
firmware: S928BXXS6DZF2 or S928BXXU5DZDP
kernel: the matching exact release listed in [TARGET.md](TARGET.md)
```

A different model, firmware, or kernel release is unsupported.

## Shizuku preparation stalls

Start Shizuku, grant Root My Galaxy permission, and keep Android child-process
restrictions disabled. The app does not start itself after installation.

## Stale exploit payload

The app removes staged helper, exploit payload, and `ksud` copies after every
install attempt. If cleanup was interrupted, remove only these staging files:

```sh
adb shell rm -f /data/local/tmp/ksu-helper /data/local/tmp/ksu-payload
adb shell rm -f /data/local/tmp/ksud-s25u-kdp /data/local/tmp/ksud-selected /data/local/tmp/.ksud-stage
```

## SELinux or mount findings

Mount Hide filters proc mount-table views; it cannot hide ordinary files.
SELinux Hide is enabled by default in this S928B build, but leaves
`/proc/self/attr/current` writes unchanged. A detector can still recognize
privileged contexts through that interface.
