import 'dart:math' as math;

import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

typedef SynkUiPopoverBuilder = Widget Function(
  BuildContext context,
  MenuController controller,
);

const _caretSize = 10.0;
const _caretInset = 12.0;

class const SynkUiPopover({
  super.key,
  required final SynkUiPopoverBuilder builder,
  required final SynkUiPopoverBuilder triggerBuilder,
  final double width = 340.0,
}) extends StatefulWidget {
  @override
  State<SynkUiPopover> createState() => _SynkUiPopoverState();
}

class _SynkUiPopoverState extends State<SynkUiPopover> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: _controller,
      overlayBuilder: (context, info) {
        final maxLeft = math.max(
          SynkUiSpace.s8,
          info.overlaySize.width - widget.width - SynkUiSpace.s8,
        );
        final left = (info.anchorRect.right - widget.width).clamp(
          SynkUiSpace.s8,
          maxLeft,
        );

        final caretRight =
            (left + widget.width - info.anchorRect.center.dx - _caretSize / 2)
                .clamp(_caretInset, widget.width - _caretInset - _caretSize);

        return Positioned(
          left: left,
          top: info.anchorRect.bottom + SynkUiSpace.s6,
          child: TapRegion(
            groupId: info.tapRegionGroupId,
            onTapOutside: (_) => _controller.close(),
            child: _Panel(
              width: widget.width,
              caretRight: caretRight,
              child: Builder(
                builder: (context) => widget.builder(context, _controller),
              ),
            ),
          ),
        );
      },
      builder: (context, controller, child) =>
          widget.triggerBuilder(context, controller),
    );
  }
}

class const _Panel({
  required final double width,
  required final double caretRight,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(SynkUiRadius.card),
              border: Border.all(
                color: colors.lineStrong,
                width: SynkUiSize.hairline,
              ),
              boxShadow: SynkUiElevation.overlay,
            ),
            child: child,
          ),
          Positioned(
            top: -(_caretSize - 4.0),
            right: caretRight,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: _caretSize,
                height: _caretSize,
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    left: BorderSide(
                      color: colors.lineStrong,
                      width: SynkUiSize.hairline,
                    ),
                    top: BorderSide(
                      color: colors.lineStrong,
                      width: SynkUiSize.hairline,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
