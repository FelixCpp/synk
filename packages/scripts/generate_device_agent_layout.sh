#!/usr/bin/env sh

set -euo pipefail

echo Generating classes...
protoc \
  --proto_path=../device_agent \
  --dart_out=../device_viewer_app/lib/feat_device_agent/generated/ \
  --java_out=lite:../android_device_agent/src/main/java/ \
  ../device_agent/device_agent.proto
echo Done generating!
