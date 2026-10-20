import 'dart:async';

import 'package:synk/feat_notifications/domain/models/notification_stack.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_notifications/presentation/widgets/notification_stack_view.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';

class const AppNotificationListener({
  super.key,
  required final NotificationFeature notifications,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<AppNotificationListener> createState() =>
      _AppNotificationListenerState();
}

class _AppNotificationListenerState extends State<AppNotificationListener> {
  StreamSubscription<NotificationStack>? _subscription;
  OverlayEntry? _overlayEntry;
  var _stack = NotificationStack.empty;

  @override
  void initState() {
    super.initState();
    _subscription = widget.notifications.observeStack().listen(_onStack);
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _onStack(NotificationStack stack) {
    if (!mounted) {
      return;
    }

    _stack = stack;

    final entry = _overlayEntry;
    if (entry != null) {
      entry.markNeedsBuild();
      return;
    }

    if (stack.entries.isEmpty) {
      return;
    }

    final inserted = OverlayEntry(builder: _buildStack);
    _overlayEntry = inserted;
    Overlay.of(context).insert(inserted);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  Widget _buildStack(BuildContext context) {
    return Positioned(
      top: SynkUiSize.titleStrip + SynkUiSpace.s16,
      right: SynkUiSpace.s16,
      child: SafeArea(
        child: NotificationStackView(
          stack: _stack,
          onDismiss: widget.notifications.dismiss,
          onDismissAll: widget.notifications.dismissAll,
          onPausedChanged: widget.notifications.setPaused,
        ),
      ),
    );
  }
}
