import 'dart:math' as math;

import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:flutter/widgets.dart';

class const SynkUiSpinner({
  final double size = 18.0,
  final Color? color,
}) extends StatefulWidget {
  @override
  State<SynkUiSpinner> createState() => _SynkUiSpinnerState();
}

class _SynkUiSpinnerState extends State<SynkUiSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.synkUi.colors.textSecondary;

    return SizedBox.square(
      dimension: widget.size,
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(painter: _ArcPainter(color: color)),
      ),
    );
  }
}

class const _ArcPainter({required final Color color}) extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width / 9.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Offset(stroke / 2, stroke / 2) &
          Size(size.width - stroke, size.height - stroke),
      -math.pi / 2,
      math.pi * 1.45,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => oldDelegate.color != color;
}
