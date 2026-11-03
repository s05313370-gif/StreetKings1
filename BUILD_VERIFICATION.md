# Build and QA verification — Street Kings: Rise of the Underworld

Date: 2026-11-03

## Tool environment

| Tool | Status |
|---|---|
| Java JDK (`java`, `javac`) | AVAILABLE (OpenJDK 21) |
| Android Gradle build system (`gradle`) | NOT INSTALLED |
| Android SDK / `ANDROID_HOME` | NOT AVAILABLE |
| `sdkmanager` | NOT INSTALLED |
| Android `aapt2` | NOT INSTALLED |
| `adb` | NOT INSTALLED |
| `apksigner` | NOT INSTALLED |
| Working dependency-repository network resolution | NOT AVAILABLE |

## Actual build attempt

Command: `./build.sh`

Exit code: **2**

Output:

```
Install Android SDK platform 35 and set ANDROID_HOME or ANDROID_SDK_ROOT.
```

**APK successfully compiled: NO.**

**APK artifact delivered: NO.**

**APK runtime or Android device tests: NONE.** No claim of compatibility or FPS on physical devices is made.

This project is configured for `minSdk 21`, `compileSdk 35`, `targetSdk 35`, AGP 8.7.3, and Gradle 8.9. Android 17 corresponds to API level 37 and is a future verification target for this project, not a tested configuration.

## Completed checks

1. `./tests/run.sh` — PASS. Pure Java simulation and mission progression tests, verifying 12 mission types/success transitions, movement collision, cash purchases, XP/stat upgrades, weapon modifications, ammo conservation, vehicle tuning and persistence, territory/perk save/load, endgame free roam, and simulation sanity.
2. `./tests/compile-android-sources.sh` — PASS. All Android Java source files compile via OpenJDK `javac` with explicitly test-only Android API stubs. Simulated touchscreen navigation also passes for menu, prologue, cutscene skip and replay, pause, skills, inventory, manual save, archive, settings, city map, weapons shop, tuning, garage interaction, and ending.
3. `python tests/verify_assets.py` — PASS. Checks expected 16 actor sprite sheets, five vehicles, 15 texture tiles, nine original WAV sound files, five launcher icon densities, the Android manifest, minSDK config and 12 original mission definitions.
4. XML manifest parsing — PASS.
5. PNG/JPEG/WAV decoding/metadata validation — PASS.

**What these tests do not prove:** Real Gradle resource linking or DEX building, real Android asset loading / Canvas rendering, real SoundPool or MediaPlayer behavior, touch-screen scaling on devices, real APK signing/installability, Android version/ABI compatibility, frame rate, thermal behavior, and crash-free long sessions. Those remain device/build QA tasks.

## Exact remaining steps to get the APK

1. Install Android Studio or Android SDK CLI tools, SDK Platform 35, Build Tools 35.0.0, platform-tools, JDK 17/21, and Gradle 8.9.
2. Set `ANDROID_HOME` to the real installed SDK path.
3. From project root, run `./build.sh` with the build computer online for the first Android Gradle Plugin download.
4. Resolve any errors that only appear in the real Android toolchain and rerun the build.
5. Confirm `app/build/outputs/apk/debug/app-debug.apk` exists and use `adb install -r app/build/outputs/apk/debug/app-debug.apk` on a test device.
6. Complete lifecycle, UI, missions, performance and API 21/24/37 device/emulator QA before labeling the game a fully verified Android release.

Official references:
- Android Gradle Plugin 8.7 compatibility: https://developer.android.com/build/releases/agp-8-7-0-release-notes
- Android 17 (API 37): https://developer.android.com/blog/posts/android-17-is-here
