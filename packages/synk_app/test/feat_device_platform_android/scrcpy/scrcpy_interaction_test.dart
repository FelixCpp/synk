import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/key_event_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/text_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_interaction.dart';

/// Shift and the period key, as a German Mac reports `:`.
DeviceKeyEvent _colon(DeviceKeyEventType type) {
  return DeviceKeyEvent(
    key: LogicalKeyboardKey.colon,
    physicalKey: PhysicalKeyboardKey.period,
    type: type,
    modifiers: const {DeviceKeyModifier.shiftLeft},
    character: type == .up ? null : ':',
  );
}

DeviceKeyEvent _letterA(DeviceKeyEventType type) {
  return DeviceKeyEvent(
    key: LogicalKeyboardKey.keyA,
    physicalKey: PhysicalKeyboardKey.keyA,
    type: type,
    modifiers: const {},
    character: type == .up ? null : 'a',
  );
}

List<int> _injectTextMessage(String text) {
  final bytes = utf8.encode(text);
  return [
    TextInteractionLayer.scrcpyInjectTextEventId,
    ...[0, 0, 0, bytes.length],
    ...bytes,
  ];
}

void main() {
  late _RecordingSocket socket;
  late ScrcpyInteraction interaction;

  setUp(() {
    socket = _RecordingSocket();
    interaction = ScrcpyInteraction(
      interactionSocket: socket,
      screenSize: BehaviorSubject.seeded(
        const DeviceScreenSize(width: 1080, height: 2400),
      ),
    );
  });

  test('types a German colon as text', () async {
    await interaction.simulateKeyEvent(_colon(.down));

    expect(socket.writes.single, _injectTextMessage(':'));
  });

  test('types an umlaut as text, in UTF-8', () async {
    await interaction.simulateKeyEvent(
      const DeviceKeyEvent(
        key: LogicalKeyboardKey(0xf6),
        physicalKey: PhysicalKeyboardKey.semicolon,
        type: DeviceKeyEventType.down,
        modifiers: {},
        character: 'ö',
      ),
    );

    expect(socket.writes.single, _injectTextMessage('ö'));
  });

  test('does not release a key the device never saw pressed', () async {
    await interaction.simulateKeyEvent(_colon(.down));
    await interaction.simulateKeyEvent(_colon(.up));

    expect(socket.writes, hasLength(1));
  });

  test('keeps a letter a key code, down and up', () async {
    await interaction.simulateKeyEvent(_letterA(.down));
    await interaction.simulateKeyEvent(_letterA(.up));

    expect(
      socket.writes.map((message) => message.first),
      everyElement(KeyEventInteractionLayer.scrcpyInjectKeyEventId),
    );
    expect(socket.writes.map((message) => message[1]), [
      KeyEventInteractionLayer.scrcpyKeyDownEventId,
      KeyEventInteractionLayer.scrcpyKeyUpEventId,
    ]);
  });

  test('sends the release of a key that went out as a key code', () async {
    // A text keystroke on one key must not swallow the release of another.
    await interaction.simulateKeyEvent(_colon(.down));
    await interaction.simulateKeyEvent(_letterA(.down));
    await interaction.simulateKeyEvent(_colon(.up));
    await interaction.simulateKeyEvent(_letterA(.up));

    expect(socket.writes, hasLength(3));
    expect(socket.writes.last[1], KeyEventInteractionLayer.scrcpyKeyUpEventId);
  });
}

class _RecordingSocket implements Socket {
  final writes = <List<int>>[];

  @override
  void add(List<int> data) => writes.add(data);

  @override
  StreamSubscription<Uint8List> listen(
    void Function(Uint8List event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return const Stream<Uint8List>.empty().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
