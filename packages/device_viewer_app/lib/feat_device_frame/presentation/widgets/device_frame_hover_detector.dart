import 'package:flutter/cupertino.dart';

class const DeviceFrameHoverDetector({
  super.key,
  required final Widget Function(BuildContext context, bool isHovered) builder,
}) extends StatefulWidget {
  @override
  State<DeviceFrameHoverDetector> createState() =>
      _DeviceFrameHoverDetectorState();
}

class _DeviceFrameHoverDetectorState extends State<DeviceFrameHoverDetector> {
  var _isHovered = false;

  void _updateHover(bool newState) {
    if (_isHovered != newState) {
      setState(() => _isHovered = newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _updateHover(true),
      onExit: (_) => _updateHover(false),
      child: widget.builder(context, _isHovered),
    );
  }
}
