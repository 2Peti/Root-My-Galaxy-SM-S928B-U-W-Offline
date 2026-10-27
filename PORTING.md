# S928B-only porting notes

This checkout publishes only `SM-S928B` firmware `S928BXXS6DZF2`.

Start with [docs/TARGET.md](docs/TARGET.md), build the native payload with the
S928B target, then follow the KernelSU patch and DDK instructions in
[`kernelsu/README.md`](kernelsu/README.md). Keep generated build directories
out of commits. Update both support manifests and artifact hashes in the same
commit as any replacement payload.

Credit upstream sources as listed in [CREDITS.md](CREDITS.md).
