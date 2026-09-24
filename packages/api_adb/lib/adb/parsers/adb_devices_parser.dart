import 'package:api_adb/api_adb.dart';

List<AdbDeviceDto> parseAdbDeviceDtos(String output) {
  return [];
  // return LineSplitter.split(output)
  //     .map((line) => _parseLine(line))
  //     .whereType<AdbDeviceDto>()
  //     .toList();
}
//
// AdbDeviceDto? _parseLine(String line) {
//   final trimmedLine = line.trim();
//
//   if (trimmedLine.isEmpty) return null;
//   if (trimmedLine.startsWith('*')) return null;
//   if (trimmedLine == 'List of devices attached') return null;
//
//   final parts = trimmedLine.split(RegExp(r'\s+'));
//   if (parts.length < 2) return null;
//
//   final serialNumber = parts.elementAt(0);
//   final state = _parseState(parts.elementAt(1));
//   if (state == null) return null;
//
//   final properties = <String, String>{};
//   for (final part in parts.skip(2)) {
//     final separator = part.indexOf(':');
//     if (separator == -1) continue;
//
//     final key = part.substring(0, separator);
//     final value = part.substring(separator + 1);
//     properties[key] = value;
//   }
//
//   return AdbDeviceDto(
//     serialNumber: serialNumber,
//     state: state,
//     product: properties['product'],
//     model: properties['model'],
//     device: properties['device'],
//     transportId: properties['transport_id'],
//   );
// }
//
// AdbDeviceState? _parseState(String state) {
//   return switch (state) {};
// }
