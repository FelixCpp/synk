import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';

typedef FilesDroppedCallback = void Function(List<String> filepaths);

class const DeviceFrameDropDetector({
  super.key,
  required final FilesDroppedCallback onFilesDropped,
  required final Widget Function(BuildContext context, bool isHovered) builder,
}) extends StatefulWidget {
  @override
  State<DeviceFrameDropDetector> createState() =>
      _DeviceFrameDropDetectorState();
}

class _DeviceFrameDropDetectorState extends State<DeviceFrameDropDetector> {
  var _isHovered = false;

  void _updateHover(bool newState) {
    setState(() => _isHovered = newState);
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => _updateHover(true),
      onDragExited: (_) => _updateHover(false),
      onDragDone: (details) {
        final filepaths = details.files.map((file) => file.path).toList();
        widget.onFilesDropped(filepaths);
      },
      onDragUpdated: (details) {},
      child: widget.builder(context, _isHovered),
    );
  }
}
