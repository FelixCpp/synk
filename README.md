# synk

A modern, native-feeling **Vysor alternative** for macOS, written in Flutter/Dart. `synk` mirrors Android
and iOS devices connected over USB (or Wi-Fi for Android), lets you interact with them from your desktop,
and gets out of your way otherwise.

![Platform](https://img.shields.io/badge/platform-macOS-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Screenshots

> 📸 Screenshots are coming soon. See [`docs/screenshots`](docs/screenshots) — contributions welcome!

## Features

- **Screen mirroring** for multiple devices at once, arranged in a responsive device grid
- **Mouse & keyboard input forwarding** straight into the mirrored device
- **Screenshots** of the mirrored screen, saved straight to disk
- **Screen recording** of the mirrored stream
- **Audio forwarding** from the device to your Mac (muted by default, toggle in the toolbar)
- **Wireless pairing** for Android over Wi-Fi (`adb pair` / `adb connect`), no cable required after setup
- **Clipboard sync** between Mac and device
- **File & APK transfer** via drag & drop, including one-click APK installs
- **Hardware buttons** in the toolbar: Back, Home, Recent Apps, Power, Volume
- **Window management**: maximize a single device to full-screen focus, live connection status per device
- **Light & dark theme**, following macOS appearance

## Android vs. iOS

Android support is implemented via a small server pushed to the device over ADB (based on
[scrcpy](https://github.com/Genymobile/scrcpy)'s approach), which grants raw H264 streaming, input
injection and clipboard access. Apple does not allow running an equivalent helper binary with elevated
privileges on iOS without a jailbreak, so iOS support is intentionally **view-only** for now:

| Feature                | Android             | iOS                         |
| ----------------------- | :------------------: | :--------------------------: |
| Device discovery        | ✅ via ADB           | ✅ via `usbmuxd`            |
| Screen mirroring        | ✅                   | ✅ (via `AVFoundation`/`CoreMediaIO`) |
| Screenshot               | ✅                   | ✅                           |
| Screen recording         | ✅                   | ✅                           |
| Mouse / keyboard input   | ✅                   | ❌ (no public API)           |
| Clipboard sync           | ✅                   | ❌                           |
| File / APK transfer      | ✅                   | ❌                           |
| Hardware buttons         | ✅                   | ❌                           |
| Wireless connection      | ✅ (Wi-Fi pairing)   | ❌ (USB only)                |
| Audio forwarding         | ✅                   | ❌                           |

Interaction on iOS (touch/key injection, clipboard, file transfer) would require a signed, provisioned
companion app driven via `WebDriverAgent`/XCTest — a separate, much larger project. See
[`docs/ROADMAP.md`](docs/ROADMAP.md) for the full reasoning and prioritization.

## Requirements

- macOS 13 or later (Apple Silicon & Intel both supported via a universal binary)
- [ADB](https://developer.android.com/tools/adb) available on your `$PATH` for Android devices
  (ships bundled with the app; a system install is only needed for advanced debugging)
- USB debugging enabled on the Android device, or Developer Mode + pairing for iOS devices

## Installation

### Option 1: Download the prebuilt app (recommended)

1. Grab the latest `synk-macos.dmg` from the [Releases page](https://github.com/FelixCpp/synk/releases).
2. Open the DMG and drag **synk.app** into `/Applications`.
3. The app is **not notarized/signed with an Apple Developer ID** yet, so macOS Gatekeeper will block the
   first launch. To open it anyway:
   - Right-click (or Control-click) `synk.app` → **Open** → confirm **Open** in the dialog, **or**
   - Run `xattr -dr com.apple.quarantine /Applications/synk.app` in Terminal once after installing.

New DMG builds are produced automatically by CI for every tagged release (see
[`.github/workflows/release.yml`](.github/workflows/release.yml)).

### Option 2: Build from source

```bash
git clone https://github.com/FelixCpp/synk.git
cd synk/packages/synk_app
flutter pub get
flutter run -d macos      # debug run
# or
flutter build macos --release
open build/macos/Build/Products/Release/synk.app
```

Requires the Flutter SDK (`^3.47.5`) and Xcode with macOS build tools installed.

## Repository layout

This is a Flutter monorepo managed via local path dependencies:

| Package                          | Purpose                                                        |
| --------------------------------- | --------------------------------------------------------------- |
| `packages/synk_app`               | The main macOS application (UI, features, platform channels)  |
| `packages/synk_ui`                 | Shared design system / widget library                         |
| `packages/api_adb`                 | Dart wrapper around the Android Debug Bridge protocol          |
| `packages/device_agent`            | Shared device-agent abstractions                               |
| `packages/android_device_agent`    | Android-specific device agent implementation                  |
| `packages/app_logger`              | Lightweight logging utility shared across packages             |
| `packages/scripts`                 | Maintenance/build scripts                                      |

## Development

```bash
cd packages/synk_app
flutter pub get
flutter test          # unit/widget tests
flutter analyze        # static analysis
```

See [`docs/ROADMAP.md`](docs/ROADMAP.md) for in-progress planning notes (in German) covering remaining
Vysor feature parity gaps, the iOS strategy, and a visual/shader concept backlog.

## License

[MIT](LICENSE)
