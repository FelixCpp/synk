import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_screen_size.freezed.dart';

@freezed
sealed class DeviceScreenSize with _$DeviceScreenSize {
  const factory DeviceScreenSize({
    required int width,
    required int height,
  }) = _DeviceScreenSize;
}

extension DeviceScreenSizeAspectRatio on DeviceScreenSize {
  /// Width over height, the way layout code wants it.
  double get aspectRatio => width / height;
}
