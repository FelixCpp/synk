import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:device_viewer/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:device_viewer/feat_device_frame/presentation/widgets/device_frame_drop_detector.dart';
import 'package:device_viewer/feat_device_frame/presentation/widgets/device_frame_drop_feedback.dart';
import 'package:device_viewer/feat_device_frame/presentation/widgets/device_frame_hover_detector.dart';
import 'package:device_viewer/feat_device_frame/presentation/widgets/device_frame_pointer_listener.dart';
import 'package:device_viewer/feat_device_frame/presentation/widgets/device_frame_surface.dart';
import 'package:device_viewer/feat_device_frame/presentation/widgets/device_frame_tool_bar.dart';
import 'package:device_viewer/feat_device_frame/presentation/widgets/device_screen_mirror.dart';
import 'package:device_viewer/feat_native_texture/native_texture.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DeviceFrame({
  super.key,
  required final DeviceId deviceId,
  required final String modelName,
  required final bool isLive,
  required final NativeTextureId? textureId,
  required final DeviceScreenSize? screenSize,
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

  void _handleCaptureScreenshot(BuildContext context) {
    _screenshotFlashController.forward(from: 0);
    BlocProvider.of<DeviceFrameBloc>(context).add(const .onCaptureScreenshot());
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
          _aspectRatioOf(widget.screenSize),
          Size(
            constraints.maxWidth,
            constraints.maxHeight - DeviceViewerTheme.deviceFrameToolBarHeight,
          ),
        );

        final hasFocus = focusNode.hasFocus;

        return Center(
          child: Hero(
            tag: _heroTagOf(widget.deviceId),
            placeholderBuilder: widget.isMaximized
                ? null
                : (context, heroSize, child) => child,
            child: SizedBox(
              width: mirrorSize.width,
              height:
                  mirrorSize.height +
                  DeviceViewerTheme.deviceFrameToolBarHeight,
              child: BlocProvider(
                create: (context) => DeviceFrameBloc(
                  deviceId: widget.deviceId,
                  repository: DeviceFrameRepositoryImpl(
                    repository: RepositoryProvider.of(context),
                  ),
                  notifications: RepositoryProvider.of(context),
                ),
                child: Builder(
                  builder: (context) {
                    final isProcessingDroppedFiles = context
                        .watch<DeviceFrameBloc>()
                        .state
                        .isProcessingDroppedFiles;

                    return DeviceFrameHoverDetector(
                      builder: (context, isHovered) => DeviceFrameDropDetector(
                        onFilesDropped: (filepaths) {
                          BlocProvider.of<DeviceFrameBloc>(context)
                              .add(.onFilesDropped(filepaths));
                        },
                        builder: (context, isDragHovered) => Focus(
                          focusNode: focusNode,
                          autofocus: widget.isMaximized,
                          onFocusChange: (_) => setState(() {}),
                          onKeyEvent: (focusNode, keyEvent) {
                            return _handleKeyEvent(
                              context,
                              focusNode,
                              keyEvent,
                            );
                          },
                          child: Listener(
                            onPointerDown: (_) => focusNode.requestFocus(),
                            behavior: .translucent,
                            child: DeviceFrameSurface(
                              hasFocus: hasFocus,
                              child: DeviceFrameDropFeedback(
                                isDragHovered: isDragHovered,
                                isProcessing: isProcessingDroppedFiles,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: DeviceViewerTheme
                                          .deviceFrameToolBarHeight,
                                      child: DeviceFrameToolBar(
                                        deviceId: widget.deviceId,
                                        modelName: widget.modelName,
                                        isLive: widget.isLive,
                                        isMaximized: widget.isMaximized,
                                        areActionsVisible:
                                            isHovered || widget.isMaximized,
                                        onCaptureScreenshot: () =>
                                            _handleCaptureScreenshot(context),
                                        onToggleMaximize:
                                            widget.onToggleMaximize,
                                        onClose: widget.onClose,
                                      ),
                                    ),
                                    Expanded(
                                      child: DeviceFramePointerListener(
                                        child: DeviceScreenMirror(
                                          textureId: widget.textureId,
                                          modelName: widget.modelName,
                                          hasFocus: hasFocus,
                                          flash: _screenshotFlash,
                                        ),
                                      ),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  KeyEventResult _handleKeyEvent(
    BuildContext context,
    FocusNode node,
    KeyEvent event,
  ) {
    final onEscape = widget.onEscape;
    if (onEscape != null && event.logicalKey == LogicalKeyboardKey.escape) {
      if (event is KeyDownEvent) onEscape();
      return .handled;
    }

    BlocProvider.of<DeviceFrameBloc>(context).add(.onKeyEvent(event));
    return .handled;
  }
}

String _heroTagOf(DeviceId deviceId) => 'device-frame-$deviceId';

double _aspectRatioOf(DeviceScreenSize? screenSize) {
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
