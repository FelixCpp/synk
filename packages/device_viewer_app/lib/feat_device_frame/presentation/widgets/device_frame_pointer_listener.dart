import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:device_viewer/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DeviceFramePointerListener({
  super.key,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        void handle(ScrcpyPointerEventType type, Offset pointerPosition) {
          if (size.width == 0 || size.height == 0) return;
          final pointerX = (pointerPosition.dx / size.width).clamp(0.0, 1.0);
          final pointerY = (pointerPosition.dy / size.height).clamp(0.0, 1.0);

          BlocProvider.of<DeviceFrameBloc>(context).add(
            .onPointerEvent(type, pointerX, pointerY),
          );
        }

        return Listener(
          onPointerDown: (event) {
            if (event.buttons == kPrimaryButton) {
              handle(.down, event.localPosition);
            }
          },
          onPointerMove: (event) => handle(.move, event.localPosition),
          onPointerUp: (event) => handle(.up, event.localPosition),
          onPointerCancel: (event) => handle(.up, event.localPosition),
          child: child,
        );
      },
    );
  }
}
