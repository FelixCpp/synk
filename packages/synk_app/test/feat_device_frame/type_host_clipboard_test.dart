import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/domain/models/empty_host_clipboard_exception.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:use_in_case/use_in_case.dart';

import '../support/device_frame_harness.dart';

void main() {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  test('types what the mac copied on the device', () async {
    final textInput = _RecordingTextInput();
    final harness = DeviceFrameHarness(textInput: textInput);
    addTearDown(harness.dispose);
    harness.host.text = 'Hallo Gerät';

    await harness.device.typeHostClipboard.getOrThrow();

    expect(textInput.typed, ['Hallo Gerät']);
  });

  test('tells the user when there is nothing to type', () async {
    final textInput = _RecordingTextInput();
    final harness = DeviceFrameHarness(textInput: textInput);
    addTearDown(harness.dispose);

    for (final empty in [null, '']) {
      harness.host.text = empty;

      await expectLater(
        harness.device.typeHostClipboard.getOrThrow(),
        throwsA(isA<EmptyHostClipboardException>()),
      );
    }
    expect(textInput.typed, isEmpty);
  });

  test('reports the empty clipboard in the words of the exception', () async {
    final harness = DeviceFrameHarness(textInput: _RecordingTextInput());
    addTearDown(harness.dispose);

    harness.bloc.add(const .onTypeHostClipboard());
    await pumpEventQueue();

    expect(harness.shown, ['Die Zwischenablage enthält keinen Text.']);
  });
}

class _RecordingTextInput implements DeviceTextInput {
  final typed = <String>[];

  @override
  Future<void> typeText(String text) async => typed.add(text);
}
