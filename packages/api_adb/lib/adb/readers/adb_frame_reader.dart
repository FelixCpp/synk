import 'dart:convert';

class AdbFrameReader(final Stream<List<int>> _source) {
  Stream<List<int>> frames() async* {
    final buffer = <int>[];

    await for (final chunk in _source) {
      buffer.addAll(chunk);

      while (true) {
        if (buffer.length < 4) {
          break;
        }

        final lengthString = ascii.decode(buffer.sublist(0, 4));
        final length = int.tryParse(lengthString, radix: 16);
        if (length == null) {
          throw FormatException('Invalid ADB frame length: $lengthString');
        }

        if (buffer.length < 4 + length) {
          break;
        }

        final payload = buffer.sublist(4, 4 + length);
        buffer.removeRange(0, 4 + length);
        yield payload;
      }
    }
  }
}
