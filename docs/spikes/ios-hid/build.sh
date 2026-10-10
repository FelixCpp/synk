#!/bin/sh
# Baut das Spike-CLI gegen die privaten CoreDevice-Dylibs.
#
# Die Interface-Stubs liegen bewusst nicht hier, sondern dort, wo die App sie
# auch benutzt: `packages/synk_app/macos/PrivateFrameworkStubs`. Damit gibt es
# genau eine Kopie, und dieses CLI ist zugleich die Handprobe für sie.
set -e
cd "$(dirname "$0")"
swiftc -parse-as-library -target arm64-apple-macos27.0 \
  -I ../../../packages/synk_app/macos/PrivateFrameworkStubs \
  -F /Library/Developer/PrivateFrameworks \
  -framework CoreDevice \
  main.swift -o hidpoc
