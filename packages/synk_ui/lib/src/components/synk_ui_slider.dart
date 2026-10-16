import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class const SynkUiSlider({
  super.key,
  required final double value,
  required final ValueChanged<double>? onChanged,
}) extends StatefulWidget {
  @override
  State<SynkUiSlider> createState() => _SynkUiSliderState();
}

class _SynkUiSliderState extends State<SynkUiSlider> {
  static const _keyboardStep = 0.1;

  var _isHovered = false;
  var _isFocused = false;

  void _changeTo(double value) {
    widget.onChanged?.call(value.clamp(0.0, 1.0));
  }

  void _changeAt(Offset localPosition, double width) {
    if (width <= SynkUiSize.sliderKnob) return;

    final usable = width - SynkUiSize.sliderKnob;
    _changeTo((localPosition.dx - SynkUiSize.sliderKnob / 2) / usable);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;
    final enabled = widget.onChanged != null;
    final value = widget.value.clamp(0.0, 1.0);

    return FocusableActionDetector(
      enabled: enabled,
      mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onShowHoverHighlight: (value) => setState(() => _isHovered = value),
      onShowFocusHighlight: (value) => setState(() => _isFocused = value),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _StepIntent(-1),
        SingleActivator(LogicalKeyboardKey.arrowRight): _StepIntent(1),
      },
      actions: {
        _StepIntent: CallbackAction<_StepIntent>(
          onInvoke: (intent) =>
              _changeTo(value + intent.direction * _keyboardStep),
        ),
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final knobLeft = (width - SynkUiSize.sliderKnob) * value;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled
                ? (details) => _changeAt(details.localPosition, width)
                : null,
            onHorizontalDragUpdate: enabled
                ? (details) => _changeAt(details.localPosition, width)
                : null,
            child: Opacity(
              opacity: enabled ? 1.0 : 0.45,
              child: SizedBox(
                width: width,
                height: SynkUiSize.sliderKnob,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    _Track(color: colors.lineStrong, width: width),
                    _Track(
                      color: colors.accent,
                      width: knobLeft + SynkUiSize.sliderKnob / 2,
                    ),
                    Positioned(
                      left: knobLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFFFFF),
                          border: Border.all(
                            color: _isFocused
                                ? colors.accent
                                : colors.lineStrong,
                            width: _isFocused ? 2.0 : SynkUiSize.hairline,
                          ),
                          boxShadow: _isHovered
                              ? const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 4.0,
                                  ),
                                ]
                              : const [],
                        ),
                        child: const SizedBox.square(
                          dimension: SynkUiSize.sliderKnob,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class const _StepIntent(final int direction) extends Intent {}

class const _Track({required final Color color, required final double width})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: SynkUiSize.sliderTrack,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(SynkUiSize.sliderTrack / 2),
      ),
    );
  }
}
