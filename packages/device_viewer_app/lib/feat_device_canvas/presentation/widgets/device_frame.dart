import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_colors.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_action.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:macos_ui/macos_ui.dart';

typedef DeviceActionCallback = void Function(CanvasDevice);
typedef DeviceTouchCallback = void Function(
  CanvasDevice device,
  ScrcpyPointerEventType id,
  double normalizedPointerX,
  double normalizedPointerY,
);

typedef DeviceKeyCallback = void Function(
  CanvasDevice device,
  KeyEvent event,
);

class const DeviceFrame({
  super.key,
  required final CanvasDevice device,
  required final DeviceActionCallback onCaptureScreenshot,
  required final DeviceActionCallback onClose,
  required final DeviceTouchCallback onTouch,
  required final DeviceKeyCallback onKey,
  required final int? mirrorTextureId,
}) extends StatefulWidget {
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

  late final focusNode = FocusNode(debugLabel: '${widget.device.device.id}');

  void _handleCaptureScreenshot(CanvasDevice canvasDevice) {
    _screenshotFlashController.forward(from: 0);
    widget.onCaptureScreenshot(canvasDevice);
  }

  @override
  void dispose() {
    _screenshotFlashController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mirrorSize = _fitToAspectRatio(
          _aspectRatioOf(widget.device),
          Size(
            constraints.maxWidth,
            constraints.maxHeight - DeviceViewerTheme.deviceFrameToolBarHeight,
          ),
        );

        final hasFocus = focusNode.hasFocus;

        return Center(
          child: SizedBox(
            width: mirrorSize.width,
            height:
                mirrorSize.height + DeviceViewerTheme.deviceFrameToolBarHeight,
            child: Focus(
              focusNode: focusNode,
              onFocusChange: (_) => setState(() {}),
              onKeyEvent: (_, event) {
                widget.onKey(widget.device, event);
                return .handled;
              },
              child: Listener(
                onPointerDown: (_) => focusNode.requestFocus(),
                behavior: .translucent,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: hasFocus ? 1.0 : 0.0),
                  duration: DeviceViewerTheme.focusTransitionDuration,
                  curve: Curves.easeOut,
                  builder: (context, focus, child) => DecoratedBox(
                    decoration: _frameDecoration(context, focus),
                    child: child,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      DeviceViewerTheme.cornerRadius -
                          DeviceViewerTheme.hairlineThickness,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: DeviceViewerTheme.deviceFrameToolBarHeight,
                          child: _ToolBar(
                            canvasDevice: widget.device,
                            hasFocus: hasFocus,
                            onCaptureScreenshot: _handleCaptureScreenshot,
                            onClose: widget.onClose,
                          ),
                        ),
                        _ScreenMirror(
                          canvasDevice: widget.device,
                          onTouch: widget.onTouch,
                          flash: _screenshotFlash,
                          textureId: widget.mirrorTextureId,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

BoxDecoration _frameDecoration(BuildContext context, double focus) {
  final colors = context.colors;

  return BoxDecoration(
    color: colors.card,
    borderRadius: BorderRadius.circular(DeviceViewerTheme.cornerRadius),
    border: Border.all(
      color: Color.lerp(colors.divider, colors.focusRing, focus)!,
      width: DeviceViewerTheme.hairlineThickness,
    ),
    boxShadow: [
      BoxShadow(
        color: colors.shadow,
        blurRadius: DeviceViewerTheme.cardShadow,
        offset: DeviceViewerTheme.cardShadowOffset,
      ),
      BoxShadow(
        color: Color.lerp(const Color(0x00000000), colors.focusGlow, focus)!,
        blurRadius: DeviceViewerTheme.focusRingBlur,
        spreadRadius: DeviceViewerTheme.focusRingThickness * focus,
      ),
    ],
  );
}

double _aspectRatioOf(CanvasDevice device) {
  final screenSize = device.when(
    android: (device, isConnected, textureId, screenSize) => screenSize,
    connecting: (device) => null,
  );

  if (screenSize == null || screenSize.width <= 0 || screenSize.height <= 0) {
    return DeviceViewerTheme.deviceFrameReferenceAspectRatio;
  }

  return screenSize.width / screenSize.height;
}

Size _fitToAspectRatio(double aspectRatio, Size available) {
  if (available.width <= 0 || available.height <= 0) return Size.zero;

  final heightAtFullWidth = available.width / aspectRatio;

  return heightAtFullWidth <= available.height
      ? Size(available.width, heightAtFullWidth)
      : Size(available.height * aspectRatio, available.height);
}

class const _ToolBar({
  required final CanvasDevice canvasDevice,
  required final bool hasFocus,
  required final DeviceActionCallback onCaptureScreenshot,
  required final DeviceActionCallback onClose,
}) extends StatelessWidget {
  bool get _isLive => canvasDevice.when(
    android: (device, isConnected, textureId, screenSize) => isConnected,
    connecting: (device) => false,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.card,
        border: .symmetric(
          horizontal: BorderSide(
            color: context.colors.divider,
            width: DeviceViewerTheme.hairlineThickness,
          ),
        ),
      ),
      child: Padding(
        padding: DeviceViewerTheme.deviceFrameToolBarPadding,
        child: Row(
          spacing: DeviceViewerTheme.horizontalComponentSpacingSmall,
          children: [
            _StatusDot(isLive: _isLive),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  Text(
                    canvasDevice.device.modelName,
                    style: context.typo.headline,
                    overflow: .ellipsis,
                  ),
                  Text(
                    canvasDevice.device.id,
                    style: context.typo.caption1.copyWith(
                      color: context.colors.secondaryLabel,
                    ),
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            MacosIconTheme(
              data: MacosIconThemeData(
                color: context.colors.label,
                size: 18.0,
              ),
              child: Row(
                children: [
                  _KeyboardTargetBadge(hasFocus: hasFocus),
                  // TODO(Felix): wire up recording the mirrored stream to a file.
                  MacosTooltip(
                    message: 'Aufnahme starten',
                    child: MacosIconButton(
                      onPressed: () {},
                      icon: MacosIcon(CupertinoIcons.video_camera),
                    ),
                  ),
                  MacosTooltip(
                    message: 'Screenshot aufnehmen',
                    child: MacosIconButton(
                      onPressed: () {
                        onCaptureScreenshot(canvasDevice);
                      },
                      icon: MacosIcon(CupertinoIcons.camera),
                    ),
                  ),
                  MacosTooltip(
                    message: 'Weitere Aktionen',
                    child: MacosIconButton(
                      onPressed: () {},
                      icon: MacosIcon(CupertinoIcons.ellipsis_vertical),
                    ),
                  ),
                  MacosTooltip(
                    message: 'Spiegelung beenden',
                    child: MacosIconButton(
                      onPressed: () {
                        onClose(canvasDevice);
                      },
                      icon: MacosIcon(CupertinoIcons.clear),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _StatusDot({required final bool isLive}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = isLive
        ? context.colors.deviceConnected
        : context.colors.deviceDisconnected;

    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: .circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color.withAlpha(90), blurRadius: 6.0),
          ],
        ),
        child: const SizedBox.square(dimension: 7.0),
      ),
    );
  }
}

class const _ScreenMirror({
  required final CanvasDevice canvasDevice,
  required final DeviceTouchCallback onTouch,
  required final Animation<double> flash,
  required final int? textureId,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _TouchListener(
        textureId: textureId,
        canvasDevice: canvasDevice,
        flash: flash,
        onTouch: onTouch,
        child: Stack(
          fit: .expand,
          children: [
            switch (textureId) {
              final id? => ColoredBox(
                color: DeviceViewerColors.mirrorBackground,
                child: Texture(textureId: id),
              ),
              null => _ConnectingState(
                modelName: canvasDevice.device.modelName,
              ),
            },
            IgnorePointer(
              child: FadeTransition(
                opacity: flash,
                child: const ColoredBox(
                  color: DeviceViewerColors.screenshotFlash,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _KeyboardTargetBadge({required final bool hasFocus})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosTooltip(
      message: 'Tastatureingaben gehen an dieses Gerät',
      child: SizedBox.square(
        dimension: DeviceViewerTheme.deviceFrameToolBarIconSlot,
        child: AnimatedOpacity(
          duration: DeviceViewerTheme.focusTransitionDuration,
          curve: Curves.easeOut,
          opacity: hasFocus ? 1.0 : 0.0,
          child: Center(
            child: MacosIcon(
              CupertinoIcons.keyboard,
              color: context.colors.focusRing,
            ),
          ),
        ),
      ),
    );
  }
}

class const _TouchListener({
  required final int? textureId,
  required final CanvasDevice canvasDevice,
  required final Animation<double> flash,
  required final DeviceTouchCallback onTouch,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        void handle(ScrcpyPointerEventType type, Offset touchPosition) {
          if (size.width == 0 || size.height == 0) return;
          final touchX = (touchPosition.dx / size.width).clamp(0.0, 1.0);
          final touchY = (touchPosition.dy / size.height).clamp(0.0, 1.0);
          onTouch(canvasDevice, type, touchX, touchY);
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

class const _ConnectingState({required final String modelName})
    extends StatefulWidget {
  @override
  State<_ConnectingState> createState() => _ConnectingStateState();
}

class _ConnectingStateState extends State<_ConnectingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  late final Animation<double> _pulse =
      Tween(
        begin: 0.55,
        end: 1.0,
      ).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
      );

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(brightness: .dark),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: DeviceViewerColors.mirrorBackdrop,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: .min,
            spacing: DeviceViewerTheme.verticalComponentSpacingLarge * 2,
            children: [
              FadeTransition(
                opacity: _pulse,
                child: const _DeviceOutline(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Verbinde mit ${widget.modelName}',
                  textAlign: .center,
                  overflow: .ellipsis,
                  style: context.typo.caption1.copyWith(
                    color: DeviceViewerColors.mirrorLabel,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _DeviceOutline() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.0,
      height: 116.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: DeviceViewerColors.mirrorOutline,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(color: DeviceViewerColors.mirrorGlow, blurRadius: 24.0),
        ],
      ),
      child: const Center(child: ProgressCircle(radius: 9.0)),
    );
  }
}
