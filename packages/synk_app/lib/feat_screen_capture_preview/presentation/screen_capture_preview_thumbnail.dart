import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk/feat_screen_capture_preview/presentation/screen_capture_preview_metrics.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/data/repositories/screen_capture_preview_repository_impl.dart';
import 'package:synk/feat_screen_capture_preview/presentation/bloc/screen_capture_preview_bloc.dart';
import 'package:synk_ui/synk_ui.dart';

class const ScreenCapturePreviewThumbnail({
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (context) => ScreenCapturePreviewBloc(
        ScreenCapturePreviewRepositoryImpl(
          RepositoryProvider.of(context),
          RepositoryProvider.of(context),
        ),
        RepositoryProvider.of(context),
      ),
      child: BlocBuilder<ScreenCapturePreviewBloc, ScreenCapturePreviewState>(
        builder: (context, state) {
          return _Stack(captures: state.captures);
        },
      ),
    );
  }
}

class const _Stack({
  required final List<ScreenCaptureEvent> captures,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (captures.isEmpty) {
      return const SizedBox.shrink();
    }

    final behind = captures.skip(1).toList().reversed;

    return Stack(
      alignment: .bottomRight,
      clipBehavior: .none,
      children: [
        for (final (index, capture) in behind.indexed)
          IgnorePointer(
            child: _Layered(
              depth: behind.length - index,
              child: _Card(capture: capture),
            ),
          ),
        _TopCard(capture: captures.first),
      ],
    );
  }
}

class const _Layered({
  required final int depth,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: ScreenCapturePreviewMetrics.stackOffset * depth.toDouble(),
      child: Transform.scale(
        scale: 1.0 - ScreenCapturePreviewMetrics.stackScaleStep * depth,
        child: Opacity(opacity: 0.75, child: child),
      ),
    );
  }
}

class const _TopCard({
  required final ScreenCaptureEvent capture,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;
    final bloc = BlocProvider.of<ScreenCapturePreviewBloc>(context);

    return SynkUiTooltip(
      message: 'Aufnahme öffnen',
      child: SynkUiInteractive(
        cursor: SystemMouseCursors.click,
        onPressed: () => bloc.add(.onPreviewPressed(capture)),
        builder: (context, states) {
          final hovered = states.contains(WidgetState.hovered);

          return Stack(
            clipBehavior: .none,
            children: [
              AnimatedContainer(
                duration: SynkUiMotion.state,
                curve: SynkUiMotion.standard,
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SynkUiRadius.card),
                  border: Border.all(
                    color: switch (states) {
                      _ when states.contains(WidgetState.focused) =>
                        colors.accent,
                      _ when hovered => colors.lineStrong,
                      _ => colors.line,
                    },
                    width: SynkUiSize.hairline,
                  ),
                  color: switch (states) {
                    _ when states.contains(WidgetState.pressed) =>
                      colors.pressOverlay,
                    _ when hovered => colors.hoverOverlay,
                    _ => const Color(0x00000000),
                  },
                ),
                child: _Card(capture: capture),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: AnimatedOpacity(
                  duration: SynkUiMotion.reveal,
                  opacity: hovered ? 1.0 : 0.0,
                  child: _DismissButton(
                    onPressed: () => bloc.add(.onPreviewDismissed(capture)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class const _DismissButton({
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return SynkUiInteractive(
      cursor: SystemMouseCursors.click,
      onPressed: onPressed,
      builder: (context, states) {
        return Container(
          width: ScreenCapturePreviewMetrics.dismissSlot,
          height: ScreenCapturePreviewMetrics.dismissSlot,
          alignment: .center,
          decoration: BoxDecoration(
            shape: .circle,
            color: states.contains(WidgetState.hovered)
                ? colors.raised
                : SynkUiScrim.surface,
          ),
          child: Icon(
            CupertinoIcons.xmark,
            size: SynkUiSize.icon - 4.0,
            color: colors.text,
          ),
        );
      },
    );
  }
}

class const _Card({
  required final ScreenCaptureEvent capture,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return capture.map(
      png: (png) {
        return _Poster(
          bytes: png.bytes,
          screenSize: png.screenSize,
          modelName: png.modelName,
        );
      },
      video: (video) {
        return _Poster(
          bytes: video.posterBytes,
          screenSize: video.screenSize,
          modelName: video.modelName,
          isVideo: true,
        );
      },
    );
  }
}

class const _Poster({
  required final Uint8List? bytes,
  required final DeviceScreenSize screenSize,
  required final String modelName,
  final bool isVideo = false,
}) extends StatelessWidget {
  double get aspectRatio {
    return screenSize.width / screenSize.height;
  }

  @override
  Widget build(BuildContext context) {
    final size = ScreenCapturePreviewMetrics.sizeFor(aspectRatio);

    final decodeWidth = (size.width * MediaQuery.devicePixelRatioOf(context))
        .round();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SynkUiRadius.card),
        boxShadow: SynkUiElevation.overlay,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SynkUiRadius.card),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            fit: .expand,
            children: [
              if (bytes case final bytes?)
                Image.memory(
                  bytes,
                  fit: .cover,
                  gaplessPlayback: true,
                  cacheWidth: decodeWidth,
                )
              else
                const _MissingPoster(),
              if (isVideo) const Center(child: _PlayBadge()),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: _DeviceLabel(modelName: modelName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _PlayBadge() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenCapturePreviewMetrics.playSlot,
      height: ScreenCapturePreviewMetrics.playSlot,
      alignment: .center,
      decoration: const BoxDecoration(
        shape: .circle,
        color: SynkUiScrim.surface,
      ),
      child: const Padding(
        padding: EdgeInsets.only(left: 2.0),
        child: Icon(
          CupertinoIcons.play_fill,
          size: SynkUiSize.icon,
          color: SynkUiScrim.label,
        ),
      ),
    );
  }
}

class const _MissingPoster() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return ColoredBox(
      color: colors.inset,
      child: Center(
        child: Icon(
          CupertinoIcons.video_camera,
          size: SynkUiSize.icon * 2,
          color: colors.textTertiary,
        ),
      ),
    );
  }
}

class const _DeviceLabel({
  required final String modelName,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SynkUiScrim.surface,
      ),
      child: Padding(
        padding: SynkUiScrim.insets,
        child: Text(
          modelName,
          maxLines: 1,
          overflow: .ellipsis,
          textAlign: .center,
          style: context.synkUi.typography.secondary.copyWith(
            color: SynkUiScrim.label,
          ),
        ),
      ),
    );
  }
}
