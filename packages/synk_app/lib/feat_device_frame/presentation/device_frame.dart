import 'package:synk/app_shortcuts.dart';
import 'package:synk/feat_device_frame/domain/device_frame_factory.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';
import 'package:synk/feat_device_frame/presentation/device_text_input_client.dart';
import 'package:synk/feat_device_frame/presentation/host_keystroke.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_controls.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_drop_detector.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_drop_feedback.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_pointer_listener.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_surface.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_tool_bar.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_screen_mirror.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DeviceFrame({
  super.key,
  required final DeviceConnection connection,
  required final bool isMaximized,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
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

  late final focusNode = FocusNode(
    debugLabel: '${widget.connection.device.id}',
  );

  @override
  void dispose() {
    _screenshotFlashController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connection = widget.connection;

    return _FrameLayout(
      deviceId: connection.device.id,
      screenSize: connection.screenSize,
      isMaximized: widget.isMaximized,
      child: _DeviceFrameBlocProvider(
        key: ObjectKey(connection.session),
        connection: connection,
        builder: (context, state) => _FrameDropTarget(
          enabled: connection.supportsFileTransfer,
          builder: (context, isDragHovered) => _FocusableFrame(
            focusNode: focusNode,
            autofocus: widget.isMaximized,
            acceptsText: connection.supportsTextInput,
            child: _FocusAware(
              focusNode: focusNode,
              builder: (hasFocus, child) => DeviceFrameSurface(
                hasFocus: hasFocus,
                child: child,
              ),
              child: DeviceFrameDropFeedback(
                isDragHovered: isDragHovered,
                isProcessing: state.isTransferringFiles,
                child: Column(
                  children: [
                    DeviceFrameToolBar(
                      connection: connection,
                      isMaximized: widget.isMaximized,
                      isRecording: state.isRecording,
                      isAudioMuted: state.isAudioMuted,
                      audioVolume: state.audioVolume,
                      onCaptureScreenshot: () => _captureScreenshot(context),
                      onToggleMaximize: widget.onToggleMaximize,
                      onClose: widget.onClose,
                    ),
                    Expanded(
                      child: DeviceFramePointerListener(
                        child: DeviceScreenMirror(
                          textureId: connection.textureId,
                          modelName: connection.device.modelName,
                          flash: _screenshotFlash,
                        ),
                      ),
                    ),
                    if (connection.navigations.isNotEmpty)
                      DeviceFrameControls(
                        navigations: connection.navigations,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _captureScreenshot(BuildContext context) {
    _screenshotFlashController.forward(from: 0);
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onCaptureScreenshot());
  }
}

/// Rebuilds only what cares about the focus, and leaves [child] untouched.
class const _FocusAware({
  required final FocusNode focusNode,
  required final Widget Function(bool hasFocus, Widget child) builder,
  final Widget child = const SizedBox.shrink(),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, child) => builder(focusNode.hasFocus, child!),
      child: child,
    );
  }
}

class const _FrameLayout({
  required final DeviceId deviceId,
  required final DeviceScreenSize screenSize,
  required final bool isMaximized,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: Hero(
          tag: _heroTagOf(deviceId),
          placeholderBuilder: isMaximized
              ? null
              : (context, heroSize, child) => child,
          child: SizedBox.fromSize(
            size: _frameSizeFor(constraints, screenSize),
            child: child,
          ),
        ),
      ),
    );
  }

  Size _frameSizeFor(BoxConstraints constraints, DeviceScreenSize screenSize) {
    const chromeHeight = DeviceFrameMetrics.chromeHeight;

    final mirrorSize = _fitToAspectRatio(
      screenSize.aspectRatio,
      Size(constraints.maxWidth, constraints.maxHeight - chromeHeight),
    );

    return Size(mirrorSize.width, mirrorSize.height + chromeHeight);
  }

  Size _fitToAspectRatio(double aspectRatio, Size available) {
    if (available.width <= 0 || available.height <= 0) return Size.zero;

    final heightAtFullWidth = available.width / aspectRatio;

    return heightAtFullWidth <= available.height
        ? Size(available.width, heightAtFullWidth)
        : Size(available.height * aspectRatio, available.height);
  }
}

class const _FrameDropTarget({
  required final bool enabled,
  required final Widget Function(BuildContext context, bool isDragHovered)
  builder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return builder(context, false);
    }

    return DeviceFrameDropDetector(
      onFilesDropped: (filepaths) {
        BlocProvider.of<DeviceFrameBloc>(context)
            .add(.onFilesDropped(filepaths));
      },
      builder: builder,
    );
  }
}

class const _FocusableFrame({
  required final FocusNode focusNode,
  required final bool autofocus,
  required final bool acceptsText,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<_FocusableFrame> createState() => _FocusableFrameState();
}

class _FocusableFrameState extends State<_FocusableFrame> {
  late final AppLifecycleListener _lifecycle;
  late final _textInput = DeviceTextInputClient(
    onTextComposed: (text) => BlocProvider.of<DeviceFrameBloc>(
      context,
    ).add(.onTextComposed(text)),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onInactive: _leaveKeyboard);
  }

  @override
  void dispose() {
    _textInput.detach();
    _lifecycle.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      _textInput.detach();
      _leaveKeyboard();
      return;
    }

    if (!widget.acceptsText) {
      return;
    }

    if (context.findRenderObject() case final RenderBox box when box.hasSize) {
      _textInput.attach(size: box.size, transform: box.getTransformTo(null));
    }
  }

  void _leaveKeyboard() {
    if (!mounted) return;
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onKeyboardLeft());
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = widget.focusNode;

    return Focus(
      focusNode: focusNode,
      autofocus: widget.autofocus,
      onFocusChange: _onFocusChange,
      onKeyEvent: (node, event) => _handleKeyEvent(context, event),
      child: Listener(
        onPointerDown: (event) => focusNode.requestFocus(),
        onPointerPanZoomStart: (event) => focusNode.requestFocus(),
        behavior: .translucent,
        child: GestureDetector(
          onTap: () {},
          behavior: .translucent,
          child: widget.child,
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(BuildContext context, KeyEvent event) {
    if (AppShortcuts.owns(event)) {
      return .ignored;
    }

    if (widget.acceptsText &&
        (_textInput.isComposing ||
            event.startsComposition(HardwareKeyboard.instance))) {
      return .skipRemainingHandlers;
    }

    final keystroke = event.toDeviceKeyEvent(HardwareKeyboard.instance);
    if (keystroke == null) {
      return .ignored;
    }

    BlocProvider.of<DeviceFrameBloc>(context).add(.onKeyEvent(keystroke));
    return .handled;
  }
}

class const _DeviceFrameBlocProvider({
  super.key,
  required final DeviceConnection connection,
  required final BlocWidgetBuilder<DeviceFrameState> builder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceFrameBloc>(
      create: (context) => DeviceFrameBloc(
        device: RepositoryProvider.of<DeviceFrameFactory>(context)
            .forConnection(connection),
        notifications: RepositoryProvider.of<NotificationFeature>(context),
      ),
      child: BlocBuilder<DeviceFrameBloc, DeviceFrameState>(
        builder: builder,
      ),
    );
  }
}

String _heroTagOf(DeviceId deviceId) => 'device-frame-$deviceId';
