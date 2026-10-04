#!/usr/bin/env bash

set -euo pipefail

AGENT_DIR=../android_device_agent
LOCAL_PROPERTIES="$AGENT_DIR/local.properties"

sdk_dir=""
if [ -f "$LOCAL_PROPERTIES" ]; then
  sdk_dir=$(grep '^sdk.dir=' "$LOCAL_PROPERTIES" | cut -d'=' -f2-)
fi
sdk_dir=${sdk_dir:-${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}}

if [ -z "$sdk_dir" ]; then
  echo "Android SDK not found. Set sdk.dir in $LOCAL_PROPERTIES or export ANDROID_HOME." >&2
  exit 1
fi

build_tools_version=$(ls "$sdk_dir/build-tools" | sort -V | tail -1)
platform_version=$(ls "$sdk_dir/platforms" | sort -V | tail -1)

echo "Using SDK at $sdk_dir (build-tools $build_tools_version, platform $platform_version)"

echo Generating jar file...
(cd "$AGENT_DIR" && ./gradlew shadowjar)

"$sdk_dir/build-tools/$build_tools_version/d8" \
  --release \
  --lib "$sdk_dir/platforms/$platform_version/android.jar" \
  --output ../synk_app/assets/bundled_files \
  "$AGENT_DIR/build/libs/device_agent-all.jar"
