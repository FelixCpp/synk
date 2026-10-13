import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_navigation.dart';
import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_controls.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_drop_detector.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_drop_feedback.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_pointer_listener.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_surface.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_frame_tool_bar.dart';
import 'package:synk/feat_device_frame/presentation/widgets/device_screen_mirror.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DeviceFrame({
  super.key,
  required final DeviceId deviceId,
  required final String modelName,
  required final NativeTextureId textureId,
  required final DeviceScreenSize screenSize,
  required final bool supportsInteraction,
  required final Set<DeviceNavigation> navigations,
  required final bool supportsFileTransfer,
  required final bool supportsAudio,
  required final bool isMaximized,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
  final VoidCallback? onEscape,
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

  late final focusNode = FocusNode(debugLabel: '${widget.deviceId}');

  @override
  void dispose() {
    _screenshotFlashController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FrameLayout(
      deviceId: widget.deviceId,
      screenSize: widget.screenSize,
      isMaximized: widget.isMaximized,
      child: _DeviceFrameBlocProvider(
        deviceId: widget.deviceId,
        builder: (context, state) => _FrameDropTarget(
          enabled: widget.supportsFileTransfer,
          builder: (context, isDragHovered) => _FocusableFrame(
            focusNode: focusNode,
            autofocus: widget.isMaximized,
            onFocusChanged: () => setState(() {}),
            onEscape: widget.onEscape,
            child: _FrameSurface(
              hasFocus: focusNode.hasFocus,
              isDragHovered: isDragHovered,
              isProcessingDroppedFiles: state.isProcessingDroppedFiles,
              child: Column(
                children: [
                  _ToolBar(
                    deviceId: widget.deviceId,
                    modelName: widget.modelName,
                    isMaximized: widget.isMaximized,
                    isRecording: state.isRecording,
                    isAudioMuted: state.isAudioMuted,
                    supportsInteraction: widget.supportsInteraction,
                    supportsFileTransfer: widget.supportsFileTransfer,
                    supportsAudio: widget.supportsAudio,
                    onCaptureScreenshot: () => _captureScreenshot(context),
                    onToggleRecording: () => _toggleRecording(context),
                    onToggleAudioMute: () => _toggleAudioMute(context),
                    onToggleMaximize: widget.onToggleMaximize,
                    onInstallApk: () => _installApk(context),
                    onShareFile: () => _shareFile(context),
                    onStandby: () {
                      BlocProvider.of<DeviceFrameBloc>(context).add(
                        const .onPowerButtonPressed(),
                      );
                    },
                    onClose: widget.onClose,
                  ),
                  Expanded(
                    child: _ScreenMirror(
                      textureId: widget.textureId,
                      modelName: widget.modelName,
                      hasFocus: focusNode.hasFocus,
                      flash: _screenshotFlash,
                    ),
                  ),
                  if (widget.navigations.isNotEmpty)
                    _ControlsBar(
                      onBackPressed: _navigationCallback(context, .back),
                      onHomePressed: _navigationCallback(context, .home),
                      onAppSwitchPressed: _navigationCallback(
                        context,
                        .appSwitch,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback? _navigationCallback(
    BuildContext context,
    DeviceNavigation navigation,
  ) {
    if (!widget.navigations.contains(navigation)) {
      return null;
    }

    return () {
      BlocProvider.of<DeviceFrameBloc>(context).add(.onNavigate(navigation));
    };
  }

  void _captureScreenshot(BuildContext context) {
    _screenshotFlashController.forward(from: 0);
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onCaptureScreenshot());
  }

  void _toggleRecording(BuildContext context) {
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onToggleRecording());
  }

  void _toggleAudioMute(BuildContext context) {
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onToggleAudioMute());
  }

  void _installApk(BuildContext context) {
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onInstallApk());
  }

  void _shareFile(BuildContext context) {
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onShareFile());
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
    const chromeHeight = SynkTheme.deviceFrameChromeHeight;

    final mirrorSize = _fitToAspectRatio(
      deviceAspectRatioOf(screenSize),
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
  required final VoidCallback onFocusChanged,
  required final VoidCallback? onEscape,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: (_) => onFocusChanged(),
      onKeyEvent: (node, event) => _handleKeyEvent(context, event),
      child: GestureDetector(
        onTapDown: (details) => focusNode.requestFocus(),
        onTap: () {}, // Consume tap to prevent focus loss when releasing
        behavior: .translucent,
        child: child,
      ),
    );
  }

  KeyEventResult _handleKeyEvent(BuildContext context, KeyEvent event) {
    final escape = onEscape;
    if (escape != null && event.logicalKey == LogicalKeyboardKey.escape) {
      if (event is KeyDownEvent) escape();
      return .handled;
    }

    BlocProvider.of<DeviceFrameBloc>(context).add(.onKeyEvent(event));
    return .handled;
  }
}

class const _FrameSurface({
  required final bool hasFocus,
  required final bool isDragHovered,
  required final bool isProcessingDroppedFiles,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DeviceFrameSurface(
      hasFocus: hasFocus,
      child: DeviceFrameDropFeedback(
        isDragHovered: isDragHovered,
        isProcessing: isProcessingDroppedFiles,
        child: child,
      ),
    );
  }
}

class const _ToolBar({
  required final DeviceId deviceId,
  required final String modelName,
  required final bool isMaximized,
  required final bool isRecording,
  required final bool isAudioMuted,
  required final bool supportsInteraction,
  required final bool supportsFileTransfer,
  required final bool supportsAudio,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleRecording,
  required final VoidCallback onToggleAudioMute,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onInstallApk,
  required final VoidCallback onShareFile,
  required final VoidCallback onStandby,
  required final VoidCallback onClose,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SynkTheme.deviceFrameToolBarHeight,
      child: DeviceFrameToolBar(
        deviceId: deviceId,
        modelName: modelName,
        isMaximized: isMaximized,
        isRecording: isRecording,
        isAudioMuted: isAudioMuted,
        supportsInteraction: supportsInteraction,
        supportsFileTransfer: supportsFileTransfer,
        supportsAudio: supportsAudio,
        onCaptureScreenshot: onCaptureScreenshot,
        onToggleRecording: onToggleRecording,
        onToggleAudioMute: onToggleAudioMute,
        onToggleMaximize: onToggleMaximize,
        onInstallApk: onInstallApk,
        onShareFile: onShareFile,
        onClose: onClose,
        onStandby: onStandby,
      ),
    );
  }
}

class const _ScreenMirror({
  required final NativeTextureId textureId,
  required final String modelName,
  required final bool hasFocus,
  required final Animation<double> flash,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DeviceFramePointerListener(
      child: DeviceScreenMirror(
        textureId: textureId,
        modelName: modelName,
        hasFocus: hasFocus,
        flash: flash,
      ),
    );
  }
}

class const _ControlsBar({
  final VoidCallback? onBackPressed,
  final VoidCallback? onHomePressed,
  final VoidCallback? onAppSwitchPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SynkTheme.deviceFrameControlsBarHeight,
      child: Padding(
        padding: SynkTheme.deviceFrameControlsBarPadding,
        child: DeviceFrameControls(
          onBackPressed: onBackPressed,
          onHomePressed: onHomePressed,
          onAppLibraryPressed: onAppSwitchPressed,
        ),
      ),
    );
  }
}

class const _DeviceFrameBlocProvider({
  required final DeviceId deviceId,
  required final BlocWidgetBuilder<DeviceFrameState> builder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceFrameBloc>(
      create: (context) => DeviceFrameBloc(
        deviceId: deviceId,
        repository: DeviceFrameRepository(
          repository: RepositoryProvider.of(context),
        ),
        notifications: RepositoryProvider.of(context),
      ),
      child: BlocBuilder<DeviceFrameBloc, DeviceFrameState>(
        builder: builder,
      ),
    );
  }
}

String _heroTagOf(DeviceId deviceId) => 'device-frame-$deviceId';

double deviceAspectRatioOf(DeviceScreenSize screenSize) {
  return screenSize.width / screenSize.height;
}

Size deviceFrameSizeFor(DeviceScreenSize screenSize) {
  return SynkTheme.deviceFrameSizeFor(deviceAspectRatioOf(screenSize));
}
