# S928B KernelSU artifacts

Only the SM-S928B DZF2 pair is bundled.

| File | Size | SHA-256 |
| --- | ---: | --- |
| `android14-6.1_kernelsu-e3q-S928BXXS6DZF2-kdp.ko` | 412,600 | `64b10f49cfd86a702c06b4bea80d3dea4a1a7d5cd4a1f2d1e7d45783a0c53625` |
| `ksud-e3q-S928BXXS6DZF2-kdp` | 4,772,304 | `3edb768b549e5c92e9043cebdb0fffdd5b61dec42313571c3157e4078d65991b` |

KernelSU v3.2.5, commit `b0bc817b4e966aa6aa830834eaf6ef765d821d40`, uses the
Samsung KDP/RKP/DEFEX patch, JingMatrix's mount-hide commit
[`80a3ab31`](https://github.com/JingMatrix/KernelSU/commit/80a3ab31eb108a5515ecaea0f4799a035b7d1ce1), and the Samsung SELinux Hide kretprobe fallback.
Both features initialize enabled. SELinux Hide filters SELinuxFS query/status
results; `/proc/self/attr/current` writes are unchanged. Hardware revalidation
of this build remains pending.
