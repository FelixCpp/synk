import 'package:flutter/widgets.dart';

typedef ReflowGridItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

typedef ReflowGridKeyOf<T> = Object Function(T item);

class ReflowGrid<T> extends StatefulWidget {
  const ReflowGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.keyOf,
    required this.crossAxisCount,
    this.childAspectRatio = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInCubic,
    this.scrollController,
    this.padding = EdgeInsets.zero,
  });

  final List<T> items;
  final ReflowGridItemBuilder<T> itemBuilder;
  final ReflowGridKeyOf<T> keyOf;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Duration duration;
  final Curve curve;
  final ScrollController? scrollController;
  final EdgeInsets padding;

  @override
  State<ReflowGrid<T>> createState() => _ReflowGridState<T>();
}

class _ExitingEntry<T> {
  _ExitingEntry({required this.item, required this.slot});

  final T item;
  final int slot;
}

class _ReflowGridState<T> extends State<ReflowGrid<T>> {
  final _exiting = <Object, _ExitingEntry<T>>{};
  var _previousItems = <T>[];

  @override
  void initState() {
    super.initState();
    _previousItems = widget.items;
  }

  @override
  void didUpdateWidget(covariant ReflowGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldKeys = _previousItems.map(widget.keyOf).toSet();
    final newItemsByKey = {
      for (final item in widget.items) widget.keyOf(item): item,
    };

    for (final key in oldKeys) {
      if (!newItemsByKey.containsKey(key) && !_exiting.containsKey(key)) {
        final slot = _previousItems.indexWhere(
          (item) => widget.keyOf(item) == key,
        );
        _exiting[key] = _ExitingEntry(item: _previousItems[slot], slot: slot);
      }
    }

    _exiting.removeWhere((key, _) => newItemsByKey.containsKey(key));
    _previousItems = widget.items;
  }

  void _removeExiting(Object key) {
    if (!mounted) return;
    setState(() => _exiting.remove(key));
  }

  Rect _slotRect(int slot, double cellWidth, double cellHeight) {
    final row = slot ~/ widget.crossAxisCount;
    final col = slot % widget.crossAxisCount;
    return Rect.fromLTWH(
      col * (cellWidth + widget.crossAxisSpacing),
      row * (cellHeight + widget.mainAxisSpacing),
      cellWidth,
      cellHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: widget.padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalSpacing =
              widget.crossAxisSpacing * (widget.crossAxisCount - 1);
          final cellWidth =
              (constraints.maxWidth - totalSpacing) / widget.crossAxisCount;
          final cellHeight = cellWidth / widget.childAspectRatio;

          final children = <Widget>[
            for (var slot = 0; slot < widget.items.length; slot++)
              _buildPresentItem(context, slot, cellWidth, cellHeight),
            for (final entry in _exiting.entries)
              _buildExitingItem(
                context,
                entry.key,
                entry.value,
                cellWidth,
                cellHeight,
              ),
          ];

          final lastSlot = [
            widget.items.length - 1,
            for (final entry in _exiting.values) entry.slot,
          ].reduce((a, b) => a > b ? a : b);

          final rowCount = lastSlot < 0
              ? 0
              : (lastSlot ~/ widget.crossAxisCount) + 1;
          final totalHeight = rowCount == 0
              ? 0.0
              : rowCount * cellHeight + (rowCount - 1) * widget.mainAxisSpacing;

          return SizedBox(
            height: totalHeight,
            child: Stack(children: children),
          );
        },
      ),
    );
  }

  Widget _buildPresentItem(
    BuildContext context,
    int slot,
    double cellWidth,
    double cellHeight,
  ) {
    final item = widget.items[slot];
    final key = widget.keyOf(item);
    final rect = _slotRect(slot, cellWidth, cellHeight);

    return AnimatedPositioned(
      key: ValueKey(key),
      duration: widget.duration,
      curve: widget.curve,
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: widget.duration,
        curve: widget.curve,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.itemBuilder(context, item),
      ),
    );
  }

  Widget _buildExitingItem(
    BuildContext context,
    Object key,
    _ExitingEntry<T> entry,
    double cellWidth,
    double cellHeight,
  ) {
    final rect = _slotRect(entry.slot, cellWidth, cellHeight);

    return Positioned(
      key: ValueKey(('exiting', key)),
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1, end: 0),
        duration: widget.duration,
        curve: widget.curve,
        onEnd: () => _removeExiting(key),
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.itemBuilder(context, entry.item),
      ),
    );
  }
}
