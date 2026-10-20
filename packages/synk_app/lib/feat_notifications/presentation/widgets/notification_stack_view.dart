import 'package:synk/feat_notifications/domain/models/notification_entry.dart';
import 'package:synk/feat_notifications/domain/models/notification_stack.dart';
import 'package:synk/feat_notifications/presentation/widgets/notification_card.dart';
import 'package:synk/feat_notifications/presentation/widgets/notification_overflow_row.dart';
import 'package:flutter/widgets.dart';

typedef _Slot = ({NotificationEntry entry, bool isLeaving});

class const NotificationStackView({
  super.key,
  required final NotificationStack stack,
  required final void Function(int id) onDismiss,
  required final VoidCallback onDismissAll,
  required final void Function(bool isPaused) onPausedChanged,
}) extends StatefulWidget {
  @override
  State<NotificationStackView> createState() => _NotificationStackViewState();
}

class _NotificationStackViewState extends State<NotificationStackView> {
  final _slots = <_Slot>[];

  @override
  void initState() {
    super.initState();
    _takeOver(widget.stack);
  }

  @override
  void didUpdateWidget(NotificationStackView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stack != oldWidget.stack) {
      _takeOver(widget.stack);
    }
  }

  void _takeOver(NotificationStack stack) {
    final visible = stack.visible.reversed.toList();
    final shown = {for (final entry in visible) entry.id};

    final departures = <({int? behind, _Slot slot})>[];
    for (var index = 0; index < _slots.length; index++) {
      final slot = _slots[index];

      if (!shown.contains(slot.entry.id)) {
        departures.add((
          behind: index == 0 ? null : _slots[index - 1].entry.id,
          slot: (entry: slot.entry, isLeaving: true),
        ));
      }
    }

    final next = <_Slot>[
      for (final entry in visible) (entry: entry, isLeaving: false),
    ];

    for (final departure in departures) {
      final behind = departure.behind;
      final at = behind == null
          ? 0
          : next.indexWhere((slot) => slot.entry.id == behind) + 1;

      next.insert(at.clamp(0, next.length), departure.slot);
    }

    _slots
      ..clear()
      ..addAll(next);
  }

  void _forget(int id) {
    setState(() => _slots.removeWhere((slot) => slot.entry.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => widget.onPausedChanged(true),
      onExit: (_) => widget.onPausedChanged(false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final slot in _slots)
            NotificationCard(
              key: ValueKey(slot.entry.id),
              entry: slot.entry,
              isLeaving: slot.isLeaving,
              onDismissed: () => widget.onDismiss(slot.entry.id),
              onLeft: () => _forget(slot.entry.id),
            ),
          if (widget.stack.hiddenCount > 0)
            NotificationOverflowRow(
              hiddenCount: widget.stack.hiddenCount,
              onDismissAll: widget.onDismissAll,
            ),
        ],
      ),
    );
  }
}
