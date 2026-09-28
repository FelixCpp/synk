import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_colors.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_action.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_id.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';

typedef DeviceActionCallback = void Function(CanvasDevice);
typedef DeviceTouchCallback = void Function(
  CanvasDevice device,
  ScrcpyTouchId id,
  double touchX,
  double touchY,
);

typedef DeviceKeyCallback = void Function(
  CanvasDevice device,
  ScrcpyKeyAction action,
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

        return Center(
          child: SizedBox(
            width: mirrorSize.width,
            height:
                mirrorSize.height + DeviceViewerTheme.deviceFrameToolBarHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(
                  DeviceViewerTheme.cornerRadius,
                ),
                border: Border.all(
                  color: context.colors.divider,
                  width: DeviceViewerTheme.hairlineThickness,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.shadow,
                    blurRadius: DeviceViewerTheme.cardShadow,
                    offset: DeviceViewerTheme.cardShadowOffset,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  DeviceViewerTheme.cornerRadius -
                      DeviceViewerTheme.hairlineThickness,
                ),
                child: GestureDetector(
                  onTap: () {
                    focusNode.requestFocus();
                  },
                  behavior: .translucent,
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                            focusNode.hasFocus
                                ? BorderSide(
                                    color: MacosColors.systemRedColor,
                                    width: 2,
                                  )
                                : BorderSide.none,
                          ),
                        ),
                        child: SizedBox(
                          height: DeviceViewerTheme.deviceFrameToolBarHeight,
                          child: _ToolBar(
                            canvasDevice: widget.device,
                            onCaptureScreenshot: _handleCaptureScreenshot,
                            onClose: widget.onClose,
                          ),
                        ),
                      ),
                      _ScreenMirror(
                        canvasDevice: widget.device,
                        onTouch: widget.onTouch,
                        onKey: widget.onKey,
                        flash: _screenshotFlash,
                        textureId: widget.mirrorTextureId,
                        focusNode: focusNode,
                      ),
                    ],
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
  required final DeviceKeyCallback onKey,
  required final Animation<double> flash,
  required final int? textureId,
  required final FocusNode focusNode,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _KeyStrokeListener(
        device: canvasDevice,
        onKey: onKey,
        focusNode: focusNode,
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
      ),
    );
  }
}

class const _KeyStrokeListener({
  required final Widget child,
  required final CanvasDevice device,
  required final DeviceKeyCallback onKey,
  required final FocusNode focusNode,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (_, event) {
        print(
          "physicalKey: ${event.physicalKey}, logicalKey: ${event.logicalKey}, character: ${event.character}",
        );

        final keyCode = _convertLogicalKeyToKeyCode(event.logicalKey);
        if (keyCode == null) {
          return .ignored;
        }

        final metaState = _convertMetaState(HardwareKeyboard.instance);

        if (event is KeyDownEvent) {
          onKey(device, .down(keyCode: keyCode, metaState: metaState));
          return .handled;
        }

        if (event is KeyRepeatEvent) {
          onKey(
            device,
            .repeat(
              keyCode: keyCode,
              repeat: 1,
              metaState: metaState,
            ),
          );

          return .handled;
        }

        if (event is KeyUpEvent) {
          onKey(device, .up(keyCode: keyCode, metaState: metaState));
          return .handled;
        }

        return .ignored;
      },
      child: child,
    );
  }
}

final myTooleMap = Map.fromEntries(
  kAndroidToLogicalKey.entries.map(
    (entry) => MapEntry(entry.value, entry.key),
  ),
);

int? _convertLogicalKeyToKeyCode(LogicalKeyboardKey logicalKey) {
  return myTooleMap[logicalKey];
}

abstract final class AndroidMetaState {
  static const none = 0;
  static const shiftOn = 0x00000001;
  static const altOn = 0x00000002;
  static const symOn = 0x00000004;
  static const functionOn = 0x00000008;
  static const altLeftOn = 0x00000010;
  static const altRightOn = 0x00000020;
  static const shiftLeftOn = 0x00000040;
  static const shiftRightOn = 0x00000080;
  static const ctrlOn = 0x00001000;
  static const ctrlLeftOn = 0x00002000;
  static const ctrlRightOn = 0x00004000;
  static const metaOn = 0x00010000;
  static const metaLeftOn = 0x00020000;
  static const metaRightOn = 0x00040000;
  static const capLockOn = 0x00100000;
  static const numLockOn = 0x00200000;
  static const scrollLockOn = 0x00400000;
}

int _convertMetaState(HardwareKeyboard keyboard) {
  var meta = AndroidMetaState.none;

  if (keyboard.isShiftPressed) {
    meta |= AndroidMetaState.shiftOn;
  }

  if (keyboard.isControlPressed) {
    meta |= AndroidMetaState.ctrlOn;
  }

  if (keyboard.isAltPressed) {
    meta |= AndroidMetaState.altOn;
  }

  if (keyboard.isMetaPressed) {
    meta |= AndroidMetaState.metaOn;
  }

  if (keyboard.lockModesEnabled.contains(KeyboardLockMode.capsLock)) {
    meta |= AndroidMetaState.capLockOn;
  }

  if (keyboard.lockModesEnabled.contains(KeyboardLockMode.numLock)) {
    meta |= AndroidMetaState.numLockOn;
  }

  if (keyboard.lockModesEnabled.contains(KeyboardLockMode.scrollLock)) {
    meta |= AndroidMetaState.scrollLockOn;
  }

  return meta;
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

        void handle(ScrcpyTouchId id, Offset touchPosition) {
          if (size.width == 0 || size.height == 0) return;
          final touchX = (touchPosition.dx / size.width).clamp(0.0, 1.0);
          final touchY = (touchPosition.dy / size.height).clamp(0.0, 1.0);
          onTouch(canvasDevice, id, touchX, touchY);
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
