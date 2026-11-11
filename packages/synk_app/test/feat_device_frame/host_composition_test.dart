import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/presentation/host_keystroke.dart';

KeyEvent _down(
  LogicalKeyboardKey key, {
  PhysicalKeyboardKey physicalKey = PhysicalKeyboardKey.equal,
  String? character,
}) {
  return KeyDownEvent(
    physicalKey: physicalKey,
    logicalKey: key,
    character: character,
    timeStamp: Duration.zero,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final keyboard = HardwareKeyboard.instance;

  group('a keystroke that starts a composition', () {
    test('is a dead key, which types nothing on its own', () {
      expect(
        _down(const LogicalKeyboardKey(0xb4)).startsComposition(keyboard),
        isTrue,
      );
    });

    test('is a dead key the mac had to mint a key for', () {
      const minted = LogicalKeyboardKey(
        LogicalKeyboardKey.macosPlane | 0x18,
      );

      expect(_down(minted).startsComposition(keyboard), isTrue);
    });

    test('is not a key that types a character', () {
      expect(
        _down(
          LogicalKeyboardKey.keyE,
          physicalKey: PhysicalKeyboardKey.keyE,
          character: 'e',
        ).startsComposition(keyboard),
        isFalse,
      );
    });

    test('is not a key that never types anything', () {
      for (final key in [
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.enter,
        LogicalKeyboardKey.backspace,
        LogicalKeyboardKey.shiftLeft,
      ]) {
        expect(_down(key).startsComposition(keyboard), isFalse);
      }
    });

    test('is not the release of a dead key', () {
      final release = KeyUpEvent(
        physicalKey: PhysicalKeyboardKey.equal,
        logicalKey: const LogicalKeyboardKey(0xb4),
        timeStamp: Duration.zero,
      );

      expect(release.startsComposition(keyboard), isFalse);
    });
  });
}
