#!/usr/bin/env sh
set -eu
if [ -z "${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}" ]; then
  echo 'Install Android SDK platform 35 and set ANDROID_HOME or ANDROID_SDK_ROOT.' >&2; exit 2
fi
if ! command -v gradle >/dev/null 2>&1; then
  echo 'Install Gradle 8.9 and JDK 17+, then run ./build.sh.' >&2; exit 2
fi
gradle --no-daemon :app:assembleDebug
printf 'APK: %s\n' "$(pwd)/app/build/outputs/apk/debug/app-debug.apk"
