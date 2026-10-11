import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/audio_agent.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_canvas/data/repositories/device_canvas_repository_impl.dart';
import 'package:synk/feat_device_connections/domain/models/android_device_info.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('DeviceCanvasRepositoryImpl', () {
    late _FakeConnections connections;
    late DeviceCanvasRepositoryImpl repository;

    setUp(() {
      connections = _FakeConnections();
      repository = DeviceCanvasRepositoryImpl(connections);
    });

    tearDown(() async {
      await connections.dispose();
    });

    test('shows nothing while no device is connected', () async {
      expect(await repository.observeDevices().first, isEmpty);
    });

    test('turns an established connection into a canvas device', () async {
      final device = IosDevice(id: DeviceId('ios-1'), modelName: 'iPhone');
      connections.emitConnections([
        DeviceConnection.ios(
          device: device,
          textureId: const NativeTextureId(7),
          screenSize: const DeviceScreenSize(width: 1179, height: 2556),
          supportsInteraction: true,
          supportsAudio: true,
        ),
      ]);

      final devices = await repository.observeDevices().first;

      expect(devices, hasLength(1));
      expect(devices.single.device, device);
      expect(devices.single.textureId, const NativeTextureId(7));
      expect(
        devices.single.screenSize,
        const DeviceScreenSize(width: 1179, height: 2556),
      );
      expect(devices.single.supportsInteraction, isTrue);
      expect(devices.single.supportsAudio, isTrue);
      expect(devices.single.supportsDeviceActions, isFalse);
    });

    test('lets an Android frame offer device actions', () async {
      connections.emitConnections([
        DeviceConnection.android(
          device: AndroidDevice(
            id: DeviceId('android-1'),
            modelName: 'Pixel',
            state: AndroidDeviceState.device,
            connection: AndroidDeviceConnection.usb,
          ),
          info: const AndroidDeviceInfo(
            model: 'Pixel',
            manufacturer: 'Google',
            androidVersion: '15',
            sdkVersion: 35,
          ),
          textureId: const NativeTextureId(1),
          screenSize: const DeviceScreenSize(width: 1080, height: 2400),
          supportsInteraction: true,
          supportsAudio: true,
        ),
      ]);

      final devices = await repository.observeDevices().first;

      expect(devices.single.supportsDeviceActions, isTrue);
    });
  });
}

class _FakeConnections implements DeviceConnectionsRepository {
  final _connections = BehaviorSubject.seeded(<DeviceConnection>[]);

  void emitConnections(List<DeviceConnection> connections) {
    _connections.add(connections);
  }

  @override
  Future<void> dispose() => _connections.close();

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => _connections;

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Stream.value(const {});
  }

  @override
  Future<void> toggleConnection(PluggedDevice device) async {}

  @override
  bool isConnected(DeviceId id) => false;

  @override
  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id) => null;

  @override
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id) => null;

  @override
  ClipboardAgent? getClipboardAgent(DeviceId id) => null;

  @override
  AudioAgent? getAudioAgent(DeviceId id) => null;

  @override
  InteractionAgent? getInteractionAgent(DeviceId id) => null;
}
