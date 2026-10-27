# Project structure

- `app/`: offline Android app, S928B-only assets, and target matching.
- `artifacts/e3q-S928BXXS6DZF2/`: exploit payload source artifact.
- `src/targets/e3q-S928BXXS6DZF2/`: S928B firmware-specific native config.
- `kernelsu/`: exact-release module, `ksud`, build tools, and patches.
- `support/`: S928B-only manifests for current and legacy clients.
- `docs/`: S928B build, install, and troubleshooting records.

Gradle output under `app/build/` and `app/.cxx/` is temporary and must not be
committed. Release APKs belong on the GitHub Releases page.
