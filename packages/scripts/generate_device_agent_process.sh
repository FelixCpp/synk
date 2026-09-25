#!/usr/bin/env sh

set -euo pipefail

echo Generating jar file...
(cd ../android_device_agent && ./gradlew shadowjar)

~/Library/Android/sdk/build-tools/36.0.0/d8 \
  --release \
  --lib ~/Library/Android/sdk/platforms/android-37.0/android.jar \
  --output ../device_viewer_app/assets/bundled_files \
  ../android_device_agent/build/libs/device_agent-all.jar
