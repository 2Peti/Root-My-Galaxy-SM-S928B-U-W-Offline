# Root My Galaxy Offline — SM-S928B DZF2

This offline app supports only the Samsung Galaxy S24 Ultra
`SM-S928B` on firmware `S928BXXS6DZF2` and kernel
`6.1.145-android14-11-33419968-abS928BXXS6DZF2`.
It rejects other models, firmware, and kernel releases.

The APK bundles the S928B exploit payload and matching KernelSU `ksud`. Root is
per-boot; a reboot requires another install run. Use Shizuku and grant its
permission before starting Root My Galaxy. Keep Android child-process
restrictions disabled for Shizuku.

The app removes its staged helper, exploit payload, and `ksud` copies after
each install attempt. KernelSU Mount Hide filters proc mount-table views; it
does not hide ordinary files. SELinux Hide starts enabled but does not filter
`/proc/self/attr/current` writes.

## Download and build

Download the current APK from the
[GitHub release](https://github.com/fusiondrive/Root-My-Galaxy-SM-S928B-U-W-Offline/releases/latest).
The release page includes its SHA-256 manifest. To build locally:

```sh
./gradlew :app:assembleDebug
```

The APK is a release asset. Do not commit APKs, `app/build/`, or `app/.cxx/`.
The ADB helper installs only for Android user 0 and never starts the app.

## Attribution

This is an offline adaptation of
[Root My Galaxy by BuSung-dev](https://github.com/BuSung-dev/Root-My-Galaxy),
packaged by FusionDrive. The exploit port credits
[NebuSec/CyberMeowfia](https://github.com/NebuSec/CyberMeowfia/tree/main/IonStack/CVE-2026-43499/exploit).
The KernelSU mount-hide feature derives from
[JingMatrix's commit `80a3ab31`](https://github.com/JingMatrix/KernelSU/commit/80a3ab31eb108a5515ecaea0f4799a035b7d1ce1).
See [CREDITS.md](CREDITS.md) and the upstream licenses.

## Documentation

- [S928B target](docs/TARGET.md)
- [Build and install](docs/BUILD_INSTALL_ADB.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Project structure](docs/PROJECT_STRUCTURE.md)
- [Reproduce the S928B port](docs/REPRODUCE_PORT.md)
- [Build record](docs/SM-S928B-S928BXXS6DZF2.md)
