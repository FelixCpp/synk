import 'package:flutter/services.dart';

typedef BonjourService = ({String name, String host, int port});

typedef ResolvedBonjourService = ({int port, Map<String, String> txt});

class BonjourChannel {
  static const _channel = MethodChannel('dev.synk/bonjour');
  static const _browseChannel = EventChannel('dev.synk/bonjour_browse');

  Stream<List<BonjourService>> browse(String type) {
    return _browseChannel.receiveBroadcastStream(type).map((event) {
      return [
        for (final service in event as List)
          if (service case {
            'name': final String name,
            'host': final String host,
            'port': final int port,
          })
            (name: name, host: host, port: port),
      ];
    });
  }

  Future<ResolvedBonjourService?> resolve({
    required String type,
    required String name,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final resolved = await _channel.invokeMapMethod<String, Object?>(
      'resolve',
      {'type': type, 'name': name, 'timeoutMs': timeout.inMilliseconds},
    );

    return switch (resolved) {
      {'port': final int port, 'txt': final Map<Object?, Object?> txt} => (
        port: port,
        txt: txt.map((key, value) => MapEntry('$key', '$value')),
      ),
      _ => null,
    };
  }
}
