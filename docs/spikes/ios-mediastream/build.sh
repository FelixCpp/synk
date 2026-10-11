#!/bin/sh
# Baut das Spike-CLI gegen genau die Dateien, die auch in der App laufen:
# die Stub-Interfaces und `CoreDeviceMediaStream.swift`/`MediaStreamRtp.swift`
# aus dem Runner. Es gibt also keine zweite Kopie der Logik, und wenn dieses
# CLI Frames dekodiert, trägt derselbe Code auch in der App.
#
# AVConference wird nur dem *Linker* bekannt gemacht: clang darf
# /System/Library/PrivateFrameworks nicht im Header-Suchpfad sehen, weil dort
# ein Network.framework ohne Header liegt, das das SDK-eigene verdeckt.
set -e
cd "$(dirname "$0")"
STUBS=../../../packages/synk_app/macos/PrivateFrameworkStubs
RUNNER=../../../packages/synk_app/macos/Runner

swiftc -parse-as-library -target arm64-apple-macos27.0 \
  -I "$STUBS" \
  -Xcc -fmodule-map-file="$STUBS/AVConferenceStubs/module.modulemap" \
  -F /Library/Developer/PrivateFrameworks \
  -framework CoreDevice \
  -Xlinker -F -Xlinker /System/Library/PrivateFrameworks \
  -Xlinker -weak_framework -Xlinker AVConference \
  main.swift "$RUNNER/CoreDeviceMediaStream.swift" "$RUNNER/MediaStreamRtp.swift" \
  -o mspoc
