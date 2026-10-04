import 'dart:math' as math;

import 'package:flutter/widgets.dart';

typedef ReflowGridItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

typedef ReflowGridKeyOf<T> = Object Function(T item);

typedef ReflowGridCellSizeOf<T> = Size Function(T item);

class ReflowGrid<T> extends StatefulWidget {
  const ReflowGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.keyOf,
    required this.cellSizeOf,
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

  /// A cell's size depends on its item alone, never on the window or on how
  /// many other items there are - so a tile never grows or shrinks just
  /// because another device connected or disconnected elsewhere in the grid.
  /// Items flow left to right and wrap onto further rows, which scroll; each
  /// row is as tall as the tallest cell in it.
  final ReflowGridCellSizeOf<T> cellSizeOf;

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

class _Cell<T> {
  _Cell({
    required this.key,
    required this.item,
    required this.rect,
    required this.isExiting,
  });

  final Object key;
  final T item;
  final Rect rect;
  final bool isExiting;
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

  List<({Object key, T item, bool isExiting})> _orderedItems() {
    final ordered = [
      for (final item in widget.items)
        (key: widget.keyOf(item), item: item, isExiting: false),
    ];

    final exiting = _exiting.entries.toList()
      ..sort((a, b) => a.value.slot.compareTo(b.value.slot));

    for (final entry in exiting) {
      ordered.insert(
        entry.value.slot.clamp(0, ordered.length),
        (key: entry.key, item: entry.value.item, isExiting: true),
      );
    }

    return ordered;
  }

  List<_Cell<T>> _layout(double maxWidth) {
    final cells = <_Cell<T>>[];

    var rowTop = 0.0;
    var rowHeight = 0.0;
    var x = 0.0;

    for (final entry in _orderedItems()) {
      final size = widget.cellSizeOf(entry.item);
      final width = math.min(size.width, maxWidth);

      if (x > 0 && x + width > maxWidth) {
        rowTop += rowHeight + widget.mainAxisSpacing;
        rowHeight = 0.0;
        x = 0.0;
      }

      cells.add(
        _Cell(
          key: entry.key,
          item: entry.item,
          rect: Rect.fromLTWH(x, rowTop, width, size.height),
          isExiting: entry.isExiting,
        ),
      );

      x += width + widget.crossAxisSpacing;
      rowHeight = math.max(rowHeight, size.height);
    }

    return cells;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        final cells = _layout(viewportConstraints.maxWidth);
        final totalHeight = cells.fold(
          0.0,
          (height, cell) => math.max(height, cell.rect.bottom),
        );

        return SingleChildScrollView(
          controller: widget.scrollController,
          padding: widget.padding,
          child: SizedBox(
            height: totalHeight,
            child: Stack(
              children: [
                for (final cell in cells)
                  if (cell.isExiting)
                    _buildExitingCell(context, cell)
                  else
                    _buildPresentCell(context, cell),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPresentCell(BuildContext context, _Cell<T> cell) {
    return AnimatedPositioned(
      key: ValueKey(cell.key),
      duration: widget.duration,
      curve: widget.curve,
      left: cell.rect.left,
      top: cell.rect.top,
      width: cell.rect.width,
      height: cell.rect.height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: widget.duration,
        curve: widget.curve,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.itemBuilder(context, cell.item),
      ),
    );
  }

  Widget _buildExitingCell(BuildContext context, _Cell<T> cell) {
    return Positioned(
      key: ValueKey(('exiting', cell.key)),
      left: cell.rect.left,
      top: cell.rect.top,
      width: cell.rect.width,
      height: cell.rect.height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1, end: 0),
        duration: widget.duration,
        curve: widget.curve,
        onEnd: () => _removeExiting(cell.key),
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.itemBuilder(context, cell.item),
      ),
    );
  }
}
