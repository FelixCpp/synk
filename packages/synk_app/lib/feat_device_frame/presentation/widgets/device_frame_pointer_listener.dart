import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _pinchBaseSpread = 0.1;

class const DeviceFramePointerListener({
  super.key,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<DeviceFramePointerListener> createState() =>
      _DeviceFramePointerListenerState();
}

class _DeviceFramePointerListenerState
    extends State<DeviceFramePointerListener> {
  var _pinchSpread = _pinchBaseSpread;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        void sendPointer(DevicePointerEventType type, Offset position) {
          final point = _normalize(position, size);
          if (point == null) return;

          BlocProvider.of<DeviceFrameBloc>(context).add(
            .onPointerEvent(type, point.x, point.y),
          );
        }

        void sendPinch(
          DevicePointerEventType type,
          Offset position, {
          double? scale,
        }) {
          final center = _normalize(position, size);
          if (center == null) return;

          if (scale != null) {
            _pinchSpread = _pinchBaseSpread * scale;
          }

          BlocProvider.of<DeviceFrameBloc>(context).add(
            .onPinchEvent(type, center.x, center.y, _pinchSpread),
          );
        }

        return Listener(
          onPointerDown: (event) {
            if (event.buttons == kPrimaryButton) {
              sendPointer(.down, event.localPosition);
            }
          },
          onPointerMove: (event) => sendPointer(.move, event.localPosition),
          onPointerUp: (event) => sendPointer(.up, event.localPosition),
          onPointerCancel: (event) => sendPointer(.up, event.localPosition),
          onPointerPanZoomStart: (event) =>
              sendPinch(.down, event.localPosition, scale: 1.0),
          onPointerPanZoomUpdate: (event) =>
              sendPinch(.move, event.localPosition, scale: event.scale),
          onPointerPanZoomEnd: (event) => sendPinch(.up, event.localPosition),
          child: widget.child,
        );
      },
    );
  }
}

({double x, double y})? _normalize(Offset position, Size size) {
  if (size.width == 0 || size.height == 0) {
    return null;
  }

  return (
    x: (position.dx / size.width).clamp(0.0, 1.0),
    y: (position.dy / size.height).clamp(0.0, 1.0),
  );
}
