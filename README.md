# Street Kings: Rise of the Underworld

**An original offline 2D top-down gangster city game, written in Java for Android.**

Status: **Android source project implemented; platform-neutral and simulated UI tests passing; Android SDK/Gradle APK build and device runtime tests NOT performed in the authoring environment.** This is an ambitious first playable implementation, not a verified commercial-quality production release. Use the QA checklist below after compiling.

## Project layout

```
app/src/main/java/com/streetkings/game/
  GameActivity.java   Android fullscreen entry point and lifecycle
  GameView.java       Canvas renderer, twin sticks, UI, cinematics, tile streaming
  GameModel.java      Game simulation: combat, AI, vehicles, economy, XP, save data
  World.java          Deterministic, connected city district generator/collision
  Missions.java       Twelve story missions, dialogue, rewards, objective types
  Arsenal.java        Eight distinct weapons and weapon-upgrade progression
  AudioFX.java        Original local effects/music playback
app/src/main/assets/sprites/  37 original, generated PNG/JPEG sprite assets
app/src/main/assets/audio/    Nine original, synthesized WAV files
app/src/main/res/mipmap-*/ Five-density launcher icon set
app/src/main/AndroidManifest.xml
app/build.gradle
build.gradle
settings.gradle
build.sh
README.md
tools/generate_assets.py
 tools/generate_icons.py
 tests/run.sh
 tests/compile-android-sources.sh
 tests/HeadlessTests.java
 tests/ProgressionTests.java
 tests/UITests.java
 tests/android-stubs/   Minimal javac-only Android API mocks (never part of app)
```

## Android build prerequisites

- **JDK 17** or later compatible with Gradle 8.9 (JDK 17 or 21 recommended).
- **Gradle 8.9**, installed and accessible using the `gradle` command.
- **Android SDK platform 35** (Android 15), **SDK Build Tools 35.0.0** and platform-tools.
- Network access on the build computer **for the first Gradle sync** to obtain Android Gradle Plugin 8.7.3. The installed game uses no network.
- No Android NDK, C/C++, or third-party runtime libraries required.

The project targets API 35 with `minSdk 21` (Android 5.0). **Android 5.0 through Android 17 (API 37), ARM64 and 32-bit device behavior are unverified without devices/emulators.** API level 37 support may require upgrading AGP and compile SDK in a later release; the current project intentionally uses a known AGP 8.7.3 / Gradle 8.9 / compileSDK35 pairing.

### Building from Android Studio

1. Open this project folder in Android Studio (File > Open).
2. Install **Android 15 / API 35** in Tools > SDK Manager. Also install Build Tools 35.0.0.
3. If Android Studio asks for a Gradle distribution, use version **8.9**. Use JDK 17 or 21 for Gradle.
4. Wait for Gradle project sync. Android Studio may need network access to download the Android Gradle Plugin on first use.
5. Use **Build > Build Bundle(s) / APK(s) > Build APK(s)**.
6. Check `app/build/outputs/apk/debug/app-debug.apk`. Gradle signs debug APKs with a local debug key.

### Building from command line

Install the SDK, and export the SDK environment variable on macOS/Linux, for example:

```sh
export ANDROID_HOME="$HOME/Android/Sdk"   # adjust to the actual SDK location
# Install SDK packages using Android's command-line sdkmanager if necessary:
# sdkmanager 'platforms;android-35' 'build-tools;35.0.0' 'platform-tools'

# Requires Gradle 8.9 already on PATH:
./build.sh
# Equivalent:
gradle --no-daemon :app:assembleDebug
```

The build output, **if compilation succeeds**, is:

```
app/build/outputs/apk/debug/app-debug.apk
```

**An APK has not been produced or verified in the original environment.** Do not rename a ZIP as APK. The project deliberately does not bundle a nonfunctional Gradle wrapper JAR: you must provide a real Gradle 8.9 installation or generate a valid wrapper via `gradle wrapper --gradle-version 8.9` after Gradle has been installed.

### Install on your phone

After successfully building and confirming the APK exists, transfer it to the phone and open it, granting the relevant file manager permission to **Install unknown apps** when prompted. Or use:

```sh
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

No Internet permission, logins, advertisements, cloud services, or real-money payments are used.

## Controls (landscape, no gamepad needed)

| Touch control | Action |
|---|---|
| Left virtual stick | Move in 360 degrees; in cars, steer left/right and throttle forward/back |
| Right virtual stick | Aim in 360 degrees (aim direction persists when released) |
| FIRE | Fire equipped weapon; in a car, brake |
| SPRINT | Run faster while held; in a car, enable a boost |
| DODGE | Short evasive roll with temporary invulnerability |
| RELOAD | Reload the current firearm |
| USE | Interact with shops, mission evidence, cars, enter and exit vehicles |
| SWAP | Cycle through purchased/unlocked weapons |
| MED | Use a first-aid kit from inventory |
| MAP | View the complete city map |
| Pause | Open stats, skills, weapon tuning, story archive, options, and manual save |
| Cutscene PAUSE / SKIP | Pause or skip the cinematic; replay watched scenes in Story Archive |

**First steps:** Choose New Game, watch or skip the prologue, follow the gold mission marker east along the road, defeat the ambushers with the starting pistol, then approach the evidence and tap USE. Visit Iron & Ink for weapons and the Hollow for free healing and saving. The gold arrow on the HUD points toward the next objective. In Settings select **30 FPS / LOW graphics** for budget phones.

## Game systems currently implemented

- Original title screen, multi-frame animated character and boss sprites, 15 procedural environment textures, cars, launcher icons, original synthesised sound effects and low-volume ambient music.
- Deterministic **84 x 84** tile city with **nine districts**; only visible map tiles are drawn, and city generation data is never duplicated into a giant full-map texture during normal play.
- Connected roads, sidewalks, varied roof designs, parks, urban and industrial lots, downtown, rich/poor districts, clinics, police station, weapons, armor and style shops, garages and a safe house. Buildings are generally rooftop obstacles rather than full interiors.
- Hero walk, sprint, aim, fire, melee, dodge, health, armor, stamina, hit feedback, floating damage numbers, critical hits, reload, first-aid, and outfit color choices.
- **Eight weapons:** fists, bat, pistol, shotgun, SMG, assault rifle, heavy pistol and marksman rifle; each has different stats. Seven weapon mod branches change combat numbers; ammo is conserved when switching and persisted in the save.
- **13 upgradeable RPG stats** and **eight unlockable perks** (the last perk boosts speed/fire rate when badly injured); progression, cash, XP, trophies and mission rewards.
- Gang, bruiser, shooter, runner, armored/elite, police and boss enemy AI with simple vision, chase, damage, wall avoidance, range preferences and attacks; wanted level 0–5 that decreases when escaping pursuit.
- **12 story missions**: collection, guard clearing, ally defense, ambush escape, convoy tailing, territory conquest, and four boss battles. Each has briefing, dialogue, XP/money rewards, success progression and failure on death (timed escape/pursuit can time out).
- **Four distinct boss sprites and behaviors:** Enforcer warning/melee charge, Marksman standoff shots, Warlord spawning reinforcements, Kingpin phase changes and multishot bursts.
- Touchscreen sedan, sports car, gang van. Buy, repair and tune vehicles through the garage. Traffic vehicles move around the street grid.
- Fictional cash economy, ammo/weapon purchases, armor and health supplies, clothing, paid garage upgrades, claimed territory income, 12 hidden caches and achievements.
- Cinematic prologue, mission introductions/completions, four boss intros and ending, using **actual moving, multi-frame gameplay sprites** with panning, foreground character movements, transitions, dialogue, spotlight effects, cutscene skip/pause/replay.
- Day/night dimming and optional rain, compass, minimap, city atlas, boss health bar, live objectives, settings and pause menu.
- Local save file (Java Properties) containing hero stats, XP, progress, weapon/vehicle upgrades, ammunition, actors, vehicles, territories, achievements and collectibles, written on pause and at regular intervals.
- Free roam remains available after completing the final story mission.

## Known limitations / next QA work

The game has **not yet undergone an Android build, emulator execution, touchscreen device QA, FPS profiling or APK signing**. There are no measured 30/60 FPS guarantees. Buildings are mostly non-interior tile artwork; NPC dialogue is scripted within cutscenes rather than a general dialogue-tree system. Boss AI is deliberately lightweight, with basic cover awareness rather than full tactical pathfinding. The first version has one local save slot, no general branching quests or voice acting. Some advanced features from the master specification remain future development work. Treat UI and gameplay as an **untested Android implementation**, not a production release.

After building, verify on at least one API 21/24 device or emulator and one current API 37 device/emulator where available: installation, landscape touch coordinates, two-finger aim+fire, all 12 objectives, four boss fights, cutscene skip/replay, shops, save/relaunch, entering/exiting cars, full city map, orientation/lifecycle pause, low-end performance, and no crashes. Adjust the UI or balance if device testing reveals issues.

## QA that CAN run without the Android SDK

```sh
./tests/run.sh                    # Pure Java simulation and mission tests
./tests/compile-android-sources.sh # Static javac compile and no-op Android UI simulation
python3 tests/verify_assets.py    # Assets, manifest, sprite/audio checks
```

The test-only Android API stubs are in `tests/android-stubs/`, completely outside `app/src/main/`. Passing stub compilation **does not prove** real Android compilation or runtime correctness.

## Regenerating original assets

The project includes all generated image/audio assets already. To regenerate, install Pillow (`python -m pip install pillow`) and run:

```sh
python3 tools/generate_assets.py
python3 tools/generate_icons.py
```

The project uses entirely original procedurally drawn sprites and synthesized sound; it does not include proprietary art, characters, commercial audio samples or copyrighted game resources.

### Building online with GitHub Actions (no Android Studio installation needed)

This source ZIP includes `.github/workflows/build-android-apk.yml`, which requests a GitHub-hosted Linux build computer, installs Android SDK Platform 35 and Gradle 8.9, runs gameplay tests, and attempts to assemble a debug-signed APK. **This workflow has not been executed in the authoring environment, so successful cloud compilation is not guaranteed.** It requires a GitHub account and an internet connection; the completed game itself is offline.

1. Create a new repository on GitHub (private is fine).
2. Upload **the extracted project's contents**, preserving directories, including the hidden `.github/workflows/` folder, to the root of the repository. Alternatively, commit and push the extracted folder with Git.
3. In the repository, open **Actions > Build Android APK > Run workflow**. A push to `main` or `master` also triggers the build.
4. Open the resulting run. If it succeeds, download the **StreetKings-debug-APK** build artifact, unzip the downloaded archive, and locate `app-debug.apk`.
5. If the build fails, inspect the **Build debug APK** step's errors; these are real Android build errors that must be fixed before an installable APK exists.

After downloading a successful APK, you can transfer it to the Android phone and install it after granting the file manager permission to install unknown apps, or connect a device and run `adb install -r app-debug.apk`.
