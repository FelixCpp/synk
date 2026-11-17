import 'package:flutter/services.dart';

class BonjourChannel {
  static const _channel = MethodChannel('dev.synk/bonjour');

  Future<int?> resolvePort({
    required String type,
    required String name,
    Duration timeout = const Duration(seconds: 5),
  }) {
    return _channel.invokeMethod<int>('resolvePort', {
      'type': type,
      'name': name,
      'timeoutMs': timeout.inMilliseconds,
    });
  }
}
