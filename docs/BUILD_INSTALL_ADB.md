# Build, install, and ADB — S928B only

## Build

```sh
./gradlew :app:assembleDebug
```

The output is `app/build/outputs/apk/debug/app-debug.apk`. It is a temporary
build output. The published APK is attached to the GitHub Release.

Package identity: `io.github.fusiondrive.RMGs928offline`.

## Install for one Android user

```sh
adb install --user 0 -r app/build/outputs/apk/debug/app-debug.apk
```

This command updates user 0 only. It does not start the app.

## Verify the connected device

```sh
adb shell 'getprop ro.product.model; getprop ro.build.display.id; uname -r'
```

Expected model, firmware, and kernel are listed in [TARGET.md](TARGET.md).
Use Shizuku for the install flow. The app removes staged temporary files when
each attempt ends.
