import 'package:flutter/services.dart';

final _usageByLogicalKey = <LogicalKeyboardKey, int>{
  LogicalKeyboardKey.enter: 0x28,
  LogicalKeyboardKey.escape: 0x29,
  LogicalKeyboardKey.backspace: 0x2a,
  LogicalKeyboardKey.tab: 0x2b,
  LogicalKeyboardKey.space: 0x2c,
  LogicalKeyboardKey.minus: 0x2d,
  LogicalKeyboardKey.equal: 0x2e,
  LogicalKeyboardKey.bracketLeft: 0x2f,
  LogicalKeyboardKey.bracketRight: 0x30,
  LogicalKeyboardKey.backslash: 0x31,
  LogicalKeyboardKey.semicolon: 0x33,
  LogicalKeyboardKey.quote: 0x34,
  LogicalKeyboardKey.backquote: 0x35,
  LogicalKeyboardKey.comma: 0x36,
  LogicalKeyboardKey.period: 0x37,
  LogicalKeyboardKey.slash: 0x38,
  LogicalKeyboardKey.capsLock: 0x39,
  LogicalKeyboardKey.delete: 0x4c,
  LogicalKeyboardKey.home: 0x4a,
  LogicalKeyboardKey.end: 0x4d,
  LogicalKeyboardKey.pageUp: 0x4b,
  LogicalKeyboardKey.pageDown: 0x4e,
  LogicalKeyboardKey.arrowRight: 0x4f,
  LogicalKeyboardKey.arrowLeft: 0x50,
  LogicalKeyboardKey.arrowDown: 0x51,
  LogicalKeyboardKey.arrowUp: 0x52,
  LogicalKeyboardKey.controlLeft: 0xe0,
  LogicalKeyboardKey.shiftLeft: 0xe1,
  LogicalKeyboardKey.altLeft: 0xe2,
  LogicalKeyboardKey.metaLeft: 0xe3,
  LogicalKeyboardKey.controlRight: 0xe4,
  LogicalKeyboardKey.shiftRight: 0xe5,
  LogicalKeyboardKey.altRight: 0xe6,
  LogicalKeyboardKey.metaRight: 0xe7,
};

const _usageA = 0x04;
const _usage1 = 0x1e;
const _usage0 = 0x27;

int? iosKeyUsageOf(LogicalKeyboardKey key) {
  if (_usageByLogicalKey[key] case final usage?) {
    return usage;
  }

  final label = key.keyLabel;
  if (label.length != 1) {
    return null;
  }

  final code = label.toLowerCase().codeUnitAt(0);
  if (code >= 0x61 && code <= 0x7a) {
    return _usageA + (code - 0x61);
  }
  if (code >= 0x31 && code <= 0x39) {
    return _usage1 + (code - 0x31);
  }
  if (code == 0x30) {
    return _usage0;
  }

  return null;
}
