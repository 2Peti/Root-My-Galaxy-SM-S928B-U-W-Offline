# Reproduce the SM-S928B port

1. Confirm model `SM-S928B`, firmware `S928BXXS6DZF2`, and the exact kernel
   release in [TARGET.md](TARGET.md).
2. Build the native payload with the repository Makefile and Android NDK.
3. Build KernelSU v3.2.5 with the three patches listed in
   [`kernelsu/README.md`](../kernelsu/README.md).
4. Run DDK `check_symbol`, verify exact vermagic, and rebuild `ksud` with the
   generated module asset.
5. Build the offline APK with `./gradlew :app:assembleDebug`.

Do not commit intermediate `build/`, `app/build/`, or `app/.cxx/` directories.
The final APK is uploaded as a GitHub release asset; the S928B payload files
remain in the payload directories for feed consumers.
