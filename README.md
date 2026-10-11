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
- **Wireless mirroring**: Wi-Fi pairing for Android (`adb pair` / `adb connect`), and for iOS over
  Xcode's device tunnel — no cable required after setup
- **Clipboard sync** between Mac and device
- **File & APK transfer** via drag & drop, including one-click APK installs
- **Hardware buttons** in the toolbar: Back, Home, Recent Apps, Power, Volume
- **Window management**: maximize a single device to full-screen focus, live connection status per device
- **Light & dark theme**, following macOS appearance

## Android vs. iOS

Android support is implemented via a small server pushed to the device over ADB (based on
[scrcpy](https://github.com/Genymobile/scrcpy)'s approach), which grants raw H264 streaming, input
injection and clipboard access. Apple does not allow running an equivalent helper binary with elevated
privileges on iOS without a jailbreak, so the iOS side is assembled from what macOS itself offers —
which by now covers mirroring, screenshots, clipboard and touch, but not file transfer or app install:

| Feature                | Android             | iOS                         |
| ----------------------- | :------------------: | :--------------------------: |
| Device discovery        | ✅ via ADB           | ✅ via `usbmuxd`            |
| Screen mirroring        | ✅                   | ✅ (via `CoreDevice`, `AVFoundation` fallback) |
| Screenshot               | ✅                   | ✅                           |
| Screen recording         | ✅                   | ✅                           |
| Mouse input / gestures   | ✅                   | ✅ (via `CoreDevice` HID)    |
| Keyboard input           | ✅                   | ❌ (not yet, see below)      |
| Clipboard sync           | ✅                   | ✅ (text, via `devicectl`)   |
| File / APK transfer      | ✅                   | ❌ (no user-visible target) |
| Hardware buttons         | ✅                   | ❌ (not yet, see below)      |
| Wireless connection      | ✅ (Wi-Fi pairing)   | ✅ (via `CoreDevice` tunnel) |
| Audio forwarding         | ✅                   | ✅ (system audio, AAC-ELD)   |

Mirroring an iOS device has two paths. The preferred one asks the device to send its own screen and
system audio as RTP over Xcode's `CoreDevice` tunnel — the same mechanism Xcode's Device Hub uses. That
carries sound, and because the tunnel also runs over Wi-Fi it does not need the cable. Where it is
unavailable, synk falls back to capturing the device as a camera through `AVFoundation`/`CoreMediaIO`,
which reaches any trusted device but needs USB and is silent.

Most remaining iOS gaps are roadmap items rather than platform walls. Screenshots and clipboard sync go
through Xcode's `devicectl`, the former at the device's native resolution, the latter on the same ⌘C/⌘V
shortcuts as Android (text only for now). Touch and gestures go over the same private `CoreDevice` HID
channel that Xcode's own Device Hub uses — no companion app on the device, no entitlement on the Mac:
tap, drag, the navigation bar below the frame (which iOS gets as edge swipes), and pinch-to-zoom from a
trackpad. Keyboard input, the hardware buttons and the scroll wheel sit on that same channel and are
simply not wired up yet.

Two things are genuinely out of reach. File transfer: `devicectl` can only reach an app's own container
or a scratch area no one can see on the device, so there is no iOS counterpart to dropping a file and
finding it on the phone. And app install, which needs a properly signed and provisioned IPA.

iOS interaction needs Xcode installed, plus a paired device with Developer Mode enabled — mirroring
alone works without either, and a device that only mirrors stays view-only in the UI instead of
swallowing your clicks.
See [`docs/ROADMAP.md`](docs/ROADMAP.md) for the evidence, the open questions and the prioritization.

## Requirements

- macOS 14 or later (Apple Silicon & Intel both supported via a universal binary)
- [ADB](https://developer.android.com/tools/adb) available on your `$PATH` for Android devices
  (ships bundled with the app; a system install is only needed for advanced debugging)
- USB debugging enabled on the Android device, or Developer Mode + pairing for iOS devices
- Xcode installed for everything on iOS beyond basic mirroring: screenshots and clipboard go through its
  `devicectl`, touch, keyboard and standby through its private CoreDevice framework, and so do wireless
  mirroring and audio. Verified against Xcode 27. All of that additionally needs Apple Silicon, because
  those frameworks ship arm64-only; without them iOS mirroring falls back to USB-only and silent
- No particular iOS version — synk installs nothing on the phone. Verified on iOS 26.6.2 and 27.0.1,
  where the capabilities the device offers are identical

## Installation

### Option 1: Download the prebuilt app (recommended)

1. Grab the latest `synk-macos.dmg` from the [Releases page](https://github.com/FelixCpp/synk/releases).
2. Open the DMG and drag **synk.app** into `/Applications`.
3. The app is **not notarized/signed with an Apple Developer ID** yet, so macOS Gatekeeper will block the
   first launch. To open it anyway:
   - Right-click (or Control-click) `synk.app` → **Open** → confirm **Open** in the dialog, **or**
   - Run `xattr -dr com.apple.quarantine /Applications/synk.app` in Terminal once after installing.

New releases are built on demand via the [`Release macOS App`](.github/workflows/release.yml) GitHub
Actions workflow: trigger it manually from the **Actions** tab with a version number (e.g. `1.2.3`), and
it bumps `pubspec.yaml`, builds the app, creates the `v1.2.3` tag, and publishes the GitHub Release with
the `.dmg` attached — no local tagging needed.

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
