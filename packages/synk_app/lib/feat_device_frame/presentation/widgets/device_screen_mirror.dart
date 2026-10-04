import 'package:synk/design/build_context.dart';
import 'package:synk/design/theme/synk_colors.dart';
import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_native_texture/native_texture.dart';
import 'package:flutter/cupertino.dart';
import 'package:synk_ui/synk_ui.dart';

class const DeviceScreenMirror({
  super.key,
  required final NativeTextureId? textureId,
  required final String modelName,
  required final bool hasFocus,
  required final Animation<double> flash,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        switch (textureId) {
          final id? => ColoredBox(
            color: SynkColors.mirrorBackground,
            child: Texture(textureId: id),
          ),
          null => _ConnectingState(modelName: modelName),
        },
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Padding(
            padding: SynkTheme.statusOverlayPadding,
            child: _StatusOverlay(hasFocus: hasFocus),
          ),
        ),
        IgnorePointer(
          child: FadeTransition(
            opacity: flash,
            child: const ColoredBox(
              color: SynkColors.screenshotFlash,
            ),
          ),
        ),
      ],
    );
  }
}

class const _StatusOverlay({required final bool hasFocus})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisSize: .min,
        spacing: SynkTheme.horizontalComponentSpacingSmall,
        children: [
          _KeyboardTargetBadge(hasFocus: hasFocus),
        ],
      ),
    );
  }
}

class const _KeyboardTargetBadge({required final bool hasFocus})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: SynkTheme.focusTransitionDuration,
      curve: Curves.easeOut,
      opacity: hasFocus ? 1.0 : 0.0,
      child: _StatusBadge(
        child: Icon(
          CupertinoIcons.keyboard,
          size: SynkTheme.statusOverlayIconSize,
          color: context.benchTheme.colors.accent,
        ),
      ),
    );
  }
}

class const _StatusBadge({required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SynkColors.statusOverlayBackground,
        borderRadius: BorderRadius.circular(
          SynkTheme.statusOverlayRadius,
        ),
      ),
      child: Padding(
        padding: SynkTheme.statusOverlayInsets,
        child: child,
      ),
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
            colors: SynkColors.mirrorBackdrop,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: .min,
            spacing: SynkTheme.verticalComponentSpacingLarge * 2,
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
                    color: SynkColors.mirrorLabel,
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
          color: SynkColors.mirrorOutline,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(color: SynkColors.mirrorGlow, blurRadius: 24.0),
        ],
      ),
      child: const Center(child: BenchSpinner(size: 18.0)),
    );
  }
}
