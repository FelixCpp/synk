import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

/// A single white frame, flashed when a screenshot is taken.
const _screenshotFlash = Color(0xFFFFFFFF);

class const DeviceScreenMirror({
  super.key,
  required final NativeTextureId textureId,
  required final String modelName,
  required final Animation<double> flash,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        ColoredBox(
          color: SynkUiScrim.below,
          child: Texture(textureId: textureId),
        ),
        IgnorePointer(
          child: FadeTransition(
            opacity: flash,
            child: const ColoredBox(color: _screenshotFlash),
          ),
        ),
      ],
    );
  }
}
