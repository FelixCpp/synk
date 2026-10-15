#!/usr/bin/env bash

# Builds the macOS installer disk image. Used by .github/workflows/release.yml
# and runnable locally to preview the installer without cutting a release.

set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
APP_PATH="$REPO_ROOT/packages/synk_app/build/macos/Build/Products/Release/synk.app"
OUTPUT="$REPO_ROOT/packages/synk_app/synk-macos-dev.dmg"
VOLNAME="synk"
run_build=false
open_result=false

usage() {
  cat <<'USAGE'
Usage: package_dmg.sh [options]

  --output PATH   Where to write the .dmg (default: packages/synk_app/synk-macos-dev.dmg)
  --app PATH      The .app to package (default: the Release build output)
  --volname NAME  Volume name (default: synk). Finder caches window geometry per
                  volume name, so a local preview of "synk" can come out at a size
                  you dragged it to earlier. Pass a throwaway name to see what a
                  fresh machine gets.
  --build         Run `flutter build macos --release` first
  --open          Mount the finished image and reveal it in Finder
  -h, --help      Show this help
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --output) OUTPUT="$2"; shift 2 ;;
    --volname) VOLNAME="$2"; shift 2 ;;
    --app) APP_PATH="$2"; shift 2 ;;
    --build) run_build=true; shift ;;
    --open) open_result=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if ! command -v create-dmg >/dev/null 2>&1; then
  echo "create-dmg not found. Install it with: brew install create-dmg" >&2
  exit 1
fi

if [ "$run_build" = true ]; then
  (cd "$REPO_ROOT/packages/synk_app" && flutter build macos --release)
fi

if [ ! -d "$APP_PATH" ]; then
  echo "No app bundle at $APP_PATH. Build it first, or pass --build." >&2
  exit 1
fi

# create-dmg lays out everything it finds in the source folder, and adds the
# /Applications link itself, so the staging dir holds only the app.
STAGING_DIR="$(mktemp -d)/dmg"
mkdir -p "$STAGING_DIR"
cp -R "$APP_PATH" "$STAGING_DIR/"

group() { [ -n "${GITHUB_ACTIONS:-}" ] && echo "::group::$1" || echo "==> $1"; }
endgroup() { [ -n "${GITHUB_ACTIONS:-}" ] && echo "::endgroup::" || true; }
warn() { [ -n "${GITHUB_ACTIONS:-}" ] && echo "::warning::$1" || echo "warning: $1" >&2; }
fail() { [ -n "${GITHUB_ACTIONS:-}" ] && echo "::error::$1" || echo "error: $1" >&2; }

# Positioning the icons runs through Finder via AppleScript, which
# intermittently times out on hosted runners. Retry before giving up.
#
# The icon y values are deliberately ~45pt above where the row should sit:
# Finder stores the positions that much lower than AppleScript asks for.
#
# .VolumeIcon.icns is parked outside the window. It is a dot file, so Finder
# hides it by default anyway, but this keeps it off the app icon for anyone
# browsing with hidden files shown.
for attempt in 1 2 3; do
  rm -f "$OUTPUT"
  group "create-dmg attempt ${attempt}"
  if create-dmg \
    --volname "$VOLNAME" \
    --volicon "$APP_PATH/Contents/Resources/AppIcon.icns" \
    --window-pos 200 120 \
    --window-size 660 400 \
    --icon-size 128 \
    --icon "synk.app" 165 140 \
    --app-drop-link 495 140 \
    --icon ".VolumeIcon.icns" 1100 1100 \
    --hide-extension "synk.app" \
    --no-internet-enable \
    --format ULFO \
    "$OUTPUT" \
    "$STAGING_DIR"
  then
    endgroup
    echo "Wrote $OUTPUT"
    if [ "$open_result" = true ]; then
      open "$OUTPUT"
    fi
    exit 0
  fi
  endgroup
  warn "create-dmg attempt ${attempt} failed."
  sleep 5
done

fail "create-dmg failed after 3 attempts."
exit 1
