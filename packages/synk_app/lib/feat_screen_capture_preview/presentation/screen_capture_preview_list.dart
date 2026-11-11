import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/domain/screen_capture_preview_feature.dart';
import 'package:synk/feat_screen_capture_preview/presentation/bloc/screen_capture_preview_bloc.dart';
import 'package:synk/feat_screen_capture_preview/presentation/screen_capture_preview_metrics.dart';
import 'package:synk_ui/synk_ui.dart';

class const ScreenCapturePreviewList({
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (context) => ScreenCapturePreviewBloc(
        RepositoryProvider.of<ScreenCapturePreviewFeature>(context),
        RepositoryProvider.of<NotificationFeature>(context),
      ),
      child: BlocBuilder<ScreenCapturePreviewBloc, ScreenCapturePreviewState>(
        builder: (context, state) {
          if (state.captures.isEmpty) {
            return const SizedBox.shrink();
          }

          return _Panel(captures: state.captures);
        },
      ),
    );
  }
}

class const _Panel({
  required final List<ScreenCaptureEvent> captures,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final borderRadius = BorderRadius.circular(SynkUiRadius.card);

    return SizedBox(
      width: ScreenCapturePreviewMetrics.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: colors.lineStrong,
            width: SynkUiSize.hairline,
          ),
          boxShadow: SynkUiElevation.overlayFor(theme.brightness),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: .min,
            children: [
              const _Header(),
              for (final (index, capture) in captures.indexed) ...[
                if (index > 0) const _Separator(),
                _CaptureRow(capture: capture),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class const _Header() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return Container(
      height: ScreenCapturePreviewMetrics.headerHeight,
      padding: const .symmetric(horizontal: SynkUiSpace.s12),
      alignment: .centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colors.line,
            width: SynkUiSize.hairline,
          ),
        ),
      ),
      child: Text(
        'AUFNAHMEN',
        style: theme.typography.secondary.copyWith(
          fontSize: 11.0,
          color: theme.colors.textSecondary,
          fontWeight: .w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class const _Separator() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(
        left: SynkUiSpace.s8 + ScreenCapturePreviewMetrics.posterSlot,
      ),
      child: SizedBox(
        height: SynkUiSize.hairline,
        width: double.infinity,
        child: ColoredBox(color: context.synkUi.colors.line),
      ),
    );
  }
}

class const _CaptureRow({
  required final ScreenCaptureEvent capture,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final bloc = BlocProvider.of<ScreenCapturePreviewBloc>(context);

    final (kindIcon, kindLabel) = capture.map(
      png: (_) => (CupertinoIcons.camera, 'Screenshot'),
      video: (_) => (CupertinoIcons.video_camera, 'Video'),
    );

    return SynkUiInteractive(
      cursor: SystemMouseCursors.click,
      onPressed: () => bloc.add(.onPreviewPressed(capture)),
      builder: (context, states) {
        return AnimatedContainer(
          duration: SynkUiMotion.state,
          curve: SynkUiMotion.standard,
          padding: ScreenCapturePreviewMetrics.rowPadding,
          color: switch (states) {
            _ when states.contains(WidgetState.pressed) => colors.pressOverlay,
            _ when states.contains(WidgetState.hovered) => colors.hoverOverlay,
            _ => const Color(0x00000000),
          },
          child: Row(
            spacing: SynkUiSpace.s8,
            children: [
              _Poster(capture: capture),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      capture.modelName,
                      style: theme.typography.label,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    Row(
                      spacing: SynkUiSpace.s4,
                      children: [
                        Icon(
                          kindIcon,
                          size: SynkUiSize.icon - 3.0,
                          color: colors.textTertiary,
                        ),
                        Text(kindLabel, style: theme.typography.secondary),
                      ],
                    ),
                  ],
                ),
              ),
              _Action(
                tooltip: 'Im Finder zeigen',
                icon: CupertinoIcons.folder,
                onPressed: () => bloc.add(.onRevealPressed(capture)),
              ),
              _Action(
                tooltip: 'In den Papierkorb legen',
                icon: CupertinoIcons.trash,
                onPressed: () => bloc.add(.onTrashPressed(capture)),
              ),
              _Action(
                tooltip: 'Aus der Liste entfernen',
                icon: CupertinoIcons.xmark,
                onPressed: () => bloc.add(.onPreviewDismissed(capture)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class const _Action({
  required final String tooltip,
  required final IconData icon,
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SynkUiTooltip(
      message: tooltip,
      child: SynkUiIconButton(
        icon: icon,
        size: ScreenCapturePreviewMetrics.actionSize,
        iconSize: SynkUiSize.icon - 1.0,
        onPressed: onPressed,
      ),
    );
  }
}

class const _Poster({
  required final ScreenCaptureEvent capture,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return capture.map(
      png: (png) => _PosterFrame(
        bytes: png.bytes,
        screenSize: png.screenSize,
      ),
      video: (video) => _PosterFrame(
        bytes: video.posterBytes,
        screenSize: video.screenSize,
        isVideo: true,
      ),
    );
  }
}

class const _PosterFrame({
  required final Uint8List? bytes,
  required final DeviceScreenSize screenSize,
  final bool isVideo = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;
    final aspectRatio = screenSize.width / screenSize.height;
    const slot = ScreenCapturePreviewMetrics.posterSlot;
    final size = aspectRatio < 1.0
        ? Size(slot * aspectRatio, slot)
        : Size(slot, slot / aspectRatio);
    final borderRadius = BorderRadius.circular(
      ScreenCapturePreviewMetrics.posterRadius,
    );
    final decodeWidth = (size.width * MediaQuery.devicePixelRatioOf(context))
        .round();

    return SizedBox.square(
      dimension: slot,
      child: Center(
        child: Container(
          width: size.width,
          height: size.height,
          foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: colors.line,
              width: SynkUiSize.hairline,
            ),
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
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
                  ColoredBox(color: colors.inset),
                if (isVideo)
                  const Center(
                    child: Icon(
                      CupertinoIcons.play_fill,
                      size: SynkUiSize.icon - 4.0,
                      color: SynkUiScrim.label,
                      shadows: [
                        Shadow(color: Color(0x80000000), blurRadius: 4.0),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
