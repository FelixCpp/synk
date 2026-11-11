import 'dart:math' as math;

import 'package:flutter/widgets.dart';

typedef ReflowGridItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

typedef ReflowGridKeyOf<T> = Object Function(T item);

typedef ReflowGridCellSizeOf<T> = Size Function(T item, double scale);

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
    this.minScale = 1,
    this.maxScale = 1,
  }) : assert(minScale <= maxScale);

  final List<T> items;
  final ReflowGridItemBuilder<T> itemBuilder;
  final ReflowGridKeyOf<T> keyOf;

  /// Every cell is sized at one shared scale: the largest between [minScale]
  /// and [maxScale] at which all items fit the viewport. Items flow left to
  /// right and wrap onto further rows; only below [minScale] do the rows
  /// scroll.
  final ReflowGridCellSizeOf<T> cellSizeOf;

  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Duration duration;
  final Curve curve;
  final ScrollController? scrollController;
  final EdgeInsets padding;
  final double minScale;
  final double maxScale;

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

  _Cell<T> shiftedBy(double dy) => _Cell(
    key: key,
    item: item,
    rect: rect.translate(0, dy),
    isExiting: isExiting,
  );
}

class _Layout<T> {
  _Layout({
    required this.cells,
    required this.height,
    required this.overflowsWidth,
  });

  final List<_Cell<T>> cells;
  final double height;
  final bool overflowsWidth;
}

class _ReflowGridState<T> extends State<ReflowGrid<T>> {
  final _exiting = <Object, _ExitingEntry<T>>{};
  var _previousItems = <T>[];
  Size? _previousAvailable;

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

  _Layout<T> _layout(
    List<({Object key, T item, bool isExiting})> entries,
    double maxWidth,
    double scale,
  ) {
    final rows = <List<({Object key, T item, bool isExiting, Size size})>>[];
    var x = 0.0;
    var overflowsWidth = false;

    for (final entry in entries) {
      final size = widget.cellSizeOf(entry.item, scale);
      overflowsWidth |= size.width > maxWidth;
      final width = math.min(size.width, maxWidth);

      if (rows.isEmpty || (x > 0 && x + width > maxWidth)) {
        rows.add([]);
        x = 0.0;
      }

      rows.last.add((
        key: entry.key,
        item: entry.item,
        isExiting: entry.isExiting,
        size: Size(width, size.height),
      ));
      x += width + widget.crossAxisSpacing;
    }

    final cells = <_Cell<T>>[];
    var rowTop = 0.0;

    for (final row in rows) {
      final rowWidth =
          row.fold(0.0, (width, cell) => width + cell.size.width) +
          widget.crossAxisSpacing * (row.length - 1);
      final rowHeight = row.fold(
        0.0,
        (height, cell) => math.max(height, cell.size.height),
      );
      var left = (maxWidth - rowWidth) / 2;

      for (final cell in row) {
        cells.add(
          _Cell(
            key: cell.key,
            item: cell.item,
            rect: Rect.fromLTWH(
              left,
              rowTop + (rowHeight - cell.size.height) / 2,
              cell.size.width,
              cell.size.height,
            ),
            isExiting: cell.isExiting,
          ),
        );
        left += cell.size.width + widget.crossAxisSpacing;
      }

      rowTop += rowHeight + widget.mainAxisSpacing;
    }

    return _Layout(
      cells: cells,
      height: rows.isEmpty ? 0.0 : rowTop - widget.mainAxisSpacing,
      overflowsWidth: overflowsWidth,
    );
  }

  _Layout<T> _fittingLayout(
    List<({Object key, T item, bool isExiting})> entries,
    Size available,
  ) {
    bool fits(_Layout<T> layout) =>
        !layout.overflowsWidth && layout.height <= available.height;

    final largest = _layout(entries, available.width, widget.maxScale);
    if (fits(largest)) return largest;

    final smallest = _layout(entries, available.width, widget.minScale);
    if (!fits(smallest)) return smallest;

    var fitting = smallest;
    var low = widget.minScale;
    var high = widget.maxScale;

    for (var i = 0; i < 12; i++) {
      final scale = (low + high) / 2;
      final layout = _layout(entries, available.width, scale);

      if (fits(layout)) {
        fitting = layout;
        low = scale;
      } else {
        high = scale;
      }
    }

    return fitting;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        final available = Size(
          math.max(
            0.0,
            viewportConstraints.maxWidth - widget.padding.horizontal,
          ),
          math.max(
            0.0,
            viewportConstraints.maxHeight - widget.padding.vertical,
          ),
        );

        final isResizing =
            _previousAvailable != null && _previousAvailable != available;
        _previousAvailable = available;

        final layout = _fittingLayout(_orderedItems(), available);
        final top = available.height.isFinite
            ? math.max(0.0, (available.height - layout.height) / 2)
            : 0.0;

        return SingleChildScrollView(
          controller: widget.scrollController,
          padding: widget.padding,
          child: SizedBox(
            height: layout.height + top,
            child: Stack(
              children: [
                for (final cell in layout.cells)
                  if (cell.isExiting)
                    _buildExitingCell(context, cell.shiftedBy(top))
                  else
                    _buildPresentCell(
                      context,
                      cell.shiftedBy(top),
                      isResizing: isResizing,
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPresentCell(
    BuildContext context,
    _Cell<T> cell, {
    required bool isResizing,
  }) {
    return AnimatedPositioned(
      key: ValueKey(cell.key),
      duration: isResizing ? Duration.zero : widget.duration,
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
