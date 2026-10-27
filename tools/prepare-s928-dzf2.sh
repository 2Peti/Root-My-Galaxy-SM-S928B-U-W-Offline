#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"
PROFILE="e3q-S928BXXS6DZF2"
PAYLOAD_SHA="a49b378d654c7e637697a701c3c4c5fd02d22b9b30a7069c03e64ec5844af206"
KSUD_SHA="3edb768b549e5c92e9043cebdb0fffdd5b61dec42313571c3157e4078d65991b"
KO_SHA="64b10f49cfd86a702c06b4bea80d3dea4a1a7d5cd4a1f2d1e7d45783a0c53625"
HELPER_SHA="322af305c539df0d0bcd3cccfbb6881035560b74b303e9f3f616d604688242bc"

DO_PREPARE_APP=1
DO_BUILD_APK=0
DO_INSTALL_APK=0
DO_STAGE_ADB=0
DO_PRINT_COMMAND=1
DO_ADB_CHECK=1

usage() {
  cat <<USAGE
Usage: ${0##*/} [options]

S928B-only options:
  --build-apk       Build the debug APK.
  --install-apk     Update user 0 only with adb install --user 0 -r.
  --stage-adb       Stage the S928B payload and ksud on a matching SM-S928B.
  --no-adb-check    Do not inspect a connected device.
  --no-app-assets   Do not refresh app assets from this repository.
  --no-print        Do not print the manual ADB commands.
  -h, --help        Show this help.

The script never launches Root My Galaxy.
USAGE
}

die() { echo "error: $*" >&2; exit 1; }
info() { echo "[*] $*"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }
sha256_file() { sha256sum "$1" | awk '{print $1}'; }
file_size() { stat -c '%s' "$1"; }
assert_file() { test -f "$1" || die "file not found: $1"; }
assert_sha256() {
  local actual
  actual="$(sha256_file "$1")"
  test "$actual" = "$2" || die "$3 sha256 mismatch: got ${actual}, expected $2"
}
adb_prop() { adb shell "$1" 2>/dev/null | tr -d '\r'; }

while [ $# -gt 0 ]; do
  case "$1" in
    --build-apk) DO_BUILD_APK=1 ;;
    --install-apk) DO_INSTALL_APK=1 ;;
    --stage-adb) DO_STAGE_ADB=1 ;;
    --no-adb-check) DO_ADB_CHECK=0 ;;
    --no-app-assets) DO_PREPARE_APP=0 ;;
    --no-print) DO_PRINT_COMMAND=0 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option: $1" ;;
  esac
  shift
done

require_cmd sha256sum
require_cmd python3
PAYLOAD="${REPO_ROOT}/artifacts/${PROFILE}/cve-2026-43499-app.so"
KSUD="${REPO_ROOT}/kernelsu/ksud-${PROFILE}-kdp"
KO="${REPO_ROOT}/kernelsu/android14-6.1_kernelsu-${PROFILE}-kdp.ko"
HELPER="${REPO_ROOT}/app/src/main/jniLibs/arm64-v8a/libcve43499root.so"

info "verifying S928B artifacts"
for path in "$PAYLOAD" "$KSUD" "$KO" "$HELPER"; do assert_file "$path"; done
test "$(file_size "$PAYLOAD")" = 104128 || die "S928B payload size mismatch"
assert_sha256 "$PAYLOAD" "$PAYLOAD_SHA" "S928B payload"
assert_sha256 "$KSUD" "$KSUD_SHA" "S928B ksud"
assert_sha256 "$KO" "$KO_SHA" "S928B kernelsu.ko"
assert_sha256 "$HELPER" "$HELPER_SHA" "root helper"

python3 - "$REPO_ROOT/support/targets-v3.json" <<'PY'
import json, sys
feed = json.load(open(sys.argv[1]))
assert feed['schemaVersion'] == 3
assert len(feed['payloads']) == 1
item = feed['payloads'][0]
assert item['payloadId'] == 'e3q-S928BXXS6DZF2'
assert item['models'] == ['SM-S928B']
print('[+] feed contains only SM-S928B DZF2')
PY

if [ "$DO_PREPARE_APP" -eq 1 ]; then
  info "refreshing S928B app assets"
  install -d "${REPO_ROOT}/app/src/main/assets/${PROFILE}"
  install -m 0644 "$PAYLOAD" "${REPO_ROOT}/app/src/main/assets/${PROFILE}/cve-2026-43499-app.so"
  install -m 0644 "$KSUD" "${REPO_ROOT}/app/src/main/assets/${PROFILE}/ksud-${PROFILE}-kdp"
  install -m 0644 "${REPO_ROOT}/support/targets-v3.json" "${REPO_ROOT}/app/src/main/assets/targets-v3.json"
fi

if [ "$DO_BUILD_APK" -eq 1 ]; then
  require_cmd "$REPO_ROOT/gradlew"
  info "building debug APK"
  (CDPATH= cd -- "$REPO_ROOT" && ./gradlew :app:assembleDebug)
fi

if [ "$DO_INSTALL_APK" -eq 1 ]; then
  require_cmd adb
  APK="${REPO_ROOT}/app/build/outputs/apk/debug/app-debug.apk"
  assert_file "$APK"
  info "installing $APK for Android user 0 only"
  adb install --user 0 -r "$APK"
fi

SELECTED=0
if [ "$DO_ADB_CHECK" -eq 1 ] && { [ "$DO_STAGE_ADB" -eq 1 ] || [ "$DO_PRINT_COMMAND" -eq 1 ]; }; then
  if adb get-state >/dev/null 2>&1; then
    MODEL="$(adb_prop 'getprop ro.product.model')"
    KERNEL="$(adb_prop 'uname -r')"
    info "connected model=${MODEL} kernel=${KERNEL}"
    test "$MODEL" = SM-S928B || die "only SM-S928B is supported"
    test "$KERNEL" = 6.1.145-android14-11-33419968-abS928BXXS6DZF2 || die "kernel release mismatch"
    SELECTED=1
  else
    [ "$DO_STAGE_ADB" -eq 0 ] || die "no ADB device connected"
  fi
fi

if [ "$DO_STAGE_ADB" -eq 1 ]; then
  [ "$SELECTED" -eq 1 ] || die "ADB staging requires a verified SM-S928B DZF2 device"
  require_cmd adb
  STAGE="/data/local/tmp/rmg-s928/${PROFILE}"
  info "staging ${PROFILE} to ${STAGE}"
  adb shell "mkdir -p '${STAGE}'"
  adb push "$PAYLOAD" "${STAGE}/cve-2026-43499-app.so"
  adb push "$KSUD" "${STAGE}/ksud"
  adb push "$HELPER" /data/local/tmp/libcve43499root
  adb push "$KSUD" /data/local/tmp/ksud-s25u-kdp
  adb shell "chmod 755 /data/local/tmp/libcve43499root /data/local/tmp/ksud-s25u-kdp '${STAGE}/ksud'"
fi

if [ "$DO_PRINT_COMMAND" -eq 1 ]; then
  cat <<EOF

Next steps:
  1. Install and start Shizuku.
  2. Open Root My Galaxy and grant Shizuku permission.
  3. Confirm uname -r matches the exact S928B DZF2 release.
  4. If a prior attempt was interrupted, rerun the app; it clears its staged files.
EOF
  [ "$SELECTED" -eq 1 ] && echo "Verified profile: ${PROFILE}"
fi
info "done"
