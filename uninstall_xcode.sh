#!/bin/bash

# Close Xcode if it is open
killall Xcode 2>/dev/null

# Invalidate xcrun cache and clean builds
xcrun -k
xcodebuild -alltargets clean 2>/dev/null

# Delete LLVM module caches
rm -rf "$(getconf DARWIN_USER_CACHE_DIR)/org.llvm.clang/ModuleCache"
rm -rf "$(getconf DARWIN_USER_CACHE_DIR)/org.llvm.clang.$(whoami)/ModuleCache"

# Delete the main app
rm -rf /Applications/Xcode.app

# Delete user data
rm -rf ~/Library/Caches/com.apple.dt.Xcode
rm -rf ~/Library/Developer
rm -rf ~/Library/MobileDevice
rm -rf ~/Library/Preferences/com.apple.dt.Xcode.plist
rm -rf ~/Library/Preferences/com.apple.dt.xcodebuild.plist

# Delete system files (requires sudo)
sudo rm -rf /Library/Developer/CommandLineTools
sudo rm -rf /Library/Preferences/com.apple.dt.Xcode.plist
sudo rm -rf /System/Library/Receipts/com.apple.pkg.XcodeExtensionSupport.bom
sudo rm -rf /System/Library/Receipts/com.apple.pkg.XcodeExtensionSupport.plist
sudo rm -rf /System/Library/Receipts/com.apple.pkg.XcodeSystemResources.bom
sudo rm -rf /System/Library/Receipts/com.apple.pkg.XcodeSystemResources.plist
sudo rm -rf /private/var/db/receipts/com.apple.pkg.Xcode.bom

echo "✅ Xcode completely removed from the system."
