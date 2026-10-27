# SM-S928B / S928BXXS6DZF2

## Device identity

- Model: `SM-S928B`
- Firmware: `S928BXXS6DZF2`
- Device / product: `e3q` / `e3qxxx`
- Build: `BP4A.251205.006.S928BXXS6DZF2`
- Fingerprint: `samsung/e3qxxx/e3q:16/BP4A.251205.006/S928BXXS6DZF2:user/release-keys`
- Kernel: `6.1.145-android14-11-33419968-abS928BXXS6DZF2`

## Bundled payloads

| Artifact | Size | SHA-256 |
| --- | ---: | --- |
| `artifacts/e3q-S928BXXS6DZF2/cve-2026-43499-app.so` | 104,128 | `a49b378d654c7e637697a701c3c4c5fd02d22b9b30a7069c03e64ec5844af206` |
| `kernelsu/android14-6.1_kernelsu-e3q-S928BXXS6DZF2-kdp.ko` | 412,600 | `64b10f49cfd86a702c06b4bea80d3dea4a1a7d5cd4a1f2d1e7d45783a0c53625` |
| `kernelsu/ksud-e3q-S928BXXS6DZF2-kdp` | 4,772,304 | `3edb768b549e5c92e9043cebdb0fffdd5b61dec42313571c3157e4078d65991b` |

## KernelSU and hiding features

KernelSU v3.2.5 uses the Samsung KDP/RKP/DEFEX patch, JingMatrix's upstream
mount-hide commit [`80a3ab31`](https://github.com/JingMatrix/KernelSU/commit/80a3ab31eb108a5515ecaea0f4799a035b7d1ce1), and the Samsung SELinux Hide kretprobe fallback. The module
uses exact S928B vermagic, Samsung no-patch-text mode, and accepts both the
upstream Manager signer and this app's local Manager signer.

Mount Hide and SELinux Hide initialize enabled. Mount Hide filters proc
mount-table views, not normal files. SELinux Hide filters SELinuxFS
context/access/status results but leaves `/proc/self/attr/current` writes
unchanged. The offline app removes staged temporary files after an install
attempt.

The DDK build and symbol check pass. Exact recovered-ELF audit and hardware
revalidation of this default-enabled module remain pending. Root is per-boot;
a reboot requires another install attempt.

## Credits

The exploit port is based on
[NebuSec's CVE-2026-43499 source](https://github.com/NebuSec/CyberMeowfia/tree/main/IonStack/CVE-2026-43499/exploit).
The original Root My Galaxy app is by
[BuSung-dev](https://github.com/BuSung-dev/Root-My-Galaxy). Mount Hide is by
[JingMatrix](https://github.com/JingMatrix/KernelSU/commit/80a3ab31eb108a5515ecaea0f4799a035b7d1ce1).
