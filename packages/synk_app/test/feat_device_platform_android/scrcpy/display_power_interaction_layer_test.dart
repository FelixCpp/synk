import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/display_power_interaction_layer.dart';

void main() {
  late _RecordingSocket socket;
  late DisplayPowerInteractionLayer layer;

  setUp(() {
    socket = _RecordingSocket();
    layer = DisplayPowerInteractionLayer(socket);
  });

  group('DisplayPowerInteractionLayer', () {
    test('turns the display off with the scrcpy SET_DISPLAY_POWER message', () {
      layer.setDisplayPower(on: false);

      expect(socket.writes.single, [
        DisplayPowerInteractionLayer.scrcpySetDisplayPowerEventId,
        0,
      ]);
    });

    test('turns the display back on', () {
      layer.setDisplayPower(on: true);

      expect(socket.writes.single, [
        DisplayPowerInteractionLayer.scrcpySetDisplayPowerEventId,
        1,
      ]);
    });

    test('writes nothing beyond the two byte message', () {
      layer.setDisplayPower(on: false);

      expect(socket.writes, hasLength(1));
      expect(socket.writes.single, hasLength(2));
    });
  });
}

class _RecordingSocket implements Socket {
  final writes = <List<int>>[];

  @override
  void add(List<int> data) => writes.add(data);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
