import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

typedef DeviceActionCallback = void Function(CanvasDevice);

class DeviceFrame extends StatefulWidget {
  const DeviceFrame({
    super.key,
    required this.device,
    required this.onCaptureScreenshot,
  });

  final CanvasDevice device;
  final DeviceActionCallback onCaptureScreenshot;

  @override
  State<DeviceFrame> createState() => _DeviceFrameState();
}

class _DeviceFrameState extends State<DeviceFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _screenshotFlashController =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
  late final Animation<double> _screenshotFlash =
      TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
      ]).animate(
        CurvedAnimation(
          parent: _screenshotFlashController,
          curve: Curves.easeOut,
        ),
      );

  void _handleCaptureScreenshot(CanvasDevice canvasDevice) {
    _screenshotFlashController.forward(from: 0);
    widget.onCaptureScreenshot(canvasDevice);
  }

  @override
  void dispose() {
    _screenshotFlashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ToolBar(
          canvasDevice: widget.device,
          onCaptureScreenshot: _handleCaptureScreenshot,
        ),
        _ScreenMirror(canvasDevice: widget.device, flash: _screenshotFlash),
      ],
    );
  }
}

class const _ToolBar({
  required final CanvasDevice canvasDevice,
  required final DeviceActionCallback onCaptureScreenshot,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MacosDynamicColor.resolve(
          MacosColors.controlBackgroundColor,
          context,
        ),
        borderRadius: .only(
          topLeft: .circular(DeviceViewerTheme.cornerRadius),
          topRight: .circular(DeviceViewerTheme.cornerRadius),
        ),
        border: .all(color: MacosTheme.of(context).dividerColor, width: 2.0),
      ),
      child: Padding(
        padding: DeviceViewerTheme.cardPadding,
        child: Row(
          spacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
          children: [
            Expanded(
              child: Text(
                canvasDevice.device.info.model ?? canvasDevice.device.id,
                style: context.typo.headline,
                overflow: .ellipsis,
              ),
            ),
            Row(
              children: [
                MacosIconButton(
                  onPressed: () {},
                  icon: MacosIcon(CupertinoIcons.video_camera),
                ),
                MacosIconButton(
                  onPressed: () {
                    onCaptureScreenshot(canvasDevice);
                  },
                  icon: MacosIcon(CupertinoIcons.camera),
                ),
                MacosIconButton(
                  onPressed: () {},
                  icon: MacosIcon(CupertinoIcons.ellipsis_vertical),
                ),
                MacosIconButton(
                  onPressed: () {},
                  icon: MacosIcon(CupertinoIcons.clear),
                ),
              ],
            ),
            // Text("Buttons..."),
          ],
        ),
      ),
    );
  }
}

class const _ScreenMirror({
  required final CanvasDevice canvasDevice,
  required final Animation<double> flash,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const BorderRadius radius = .only(
      bottomLeft: .circular(DeviceViewerTheme.cornerRadius),
      bottomRight: .circular(DeviceViewerTheme.cornerRadius),
    );
    return Expanded(
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: .expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: MacosColors.black),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Center(
                    child: MacosIcon(
                      CupertinoIcons.device_phone_portrait,
                      size: 42.0,
                    ),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              child: FadeTransition(
                opacity: flash,
                child: const ColoredBox(color: MacosColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
