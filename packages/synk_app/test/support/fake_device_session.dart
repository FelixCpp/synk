import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';

/// A session that can do exactly what it is handed.
class FakeDeviceSession implements DeviceSession {
  FakeDeviceSession({
    this.textureId = const NativeTextureId(1),
    DeviceScreenSize screenSize = const DeviceScreenSize(
      width: 1080,
      height: 2400,
    ),
    this.audio,
    this.clipboard,
    this.screenCapture,
    this.interaction,
    this.interactionUnavailableReason,
    this.fileTransfer,
  }) : screenSizes = BehaviorSubject.seeded(screenSize);

  final BehaviorSubject<DeviceScreenSize> screenSizes;
  var isDisposed = false;

  @override
  final NativeTextureId textureId;

  @override
  final DeviceAudio? audio;

  @override
  final DeviceClipboard? clipboard;

  @override
  final DeviceScreenCapture? screenCapture;

  @override
  final DeviceInteraction? interaction;

  @override
  final InteractionUnavailableReason? interactionUnavailableReason;

  @override
  final DeviceFileTransfer? fileTransfer;

  @override
  DeviceScreenSize get screenSize => screenSizes.value;

  @override
  Stream<DeviceScreenSize> get screenSizeChanges => screenSizes.stream;

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await screenSizes.close();
  }
}

/// Capabilities that exist but do nothing, for tests that only need them to
/// be present.
class FakeInteraction implements DeviceInteraction {
  const FakeInteraction({this.supportedNavigations = const {}});

  @override
  final Set<DeviceNavigation> supportedNavigations;

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class FakeAudio implements DeviceAudio {
  /// What the device refuses to do, so a frame can be caught telling the user
  /// something that did not happen.
  Object? failWith;

  @override
  bool isAudioMuted = true;

  @override
  Future<void> setAudioMuted(bool muted) async {
    if (failWith case final error?) throw error;
    isAudioMuted = muted;
  }

  @override
  double audioVolume = 1.0;

  @override
  Future<void> setAudioVolume(double volume) async {
    if (failWith case final error?) throw error;
    audioVolume = volume;
  }
}

class FakeFileTransfer implements DeviceFileTransfer {
  const FakeFileTransfer();

  @override
  Future<void> installApk(String filepath) async {}

  @override
  Future<void> pushFile(String filepath) async {}
}
