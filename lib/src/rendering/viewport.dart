import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../utils/child_delegate.dart';
import 'base_viewport.dart';

class RenderTimelineViewport extends BaseTwoDimensionalViewport {
  final double columnWidth, rowHeight;

  RenderTimelineViewport({
    required this.columnWidth,
    required this.rowHeight,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  void layoutChildSequence() {
    super.layoutChildSequence();
    for (int column = leadingColumn; column < trailingColumn; column++) {
      for (int row = leadingRow; row < trailingRow; row++) {
        final vicinity = ChildVicinity(xIndex: column, yIndex: row);
        layoutChild(vicinity);
      }
    }
  }

  void layoutChild(ChildVicinity vicinity) {
    final child = buildOrObtainChildFor(vicinity);
    if (child != null) {
      child.layout(const BoxConstraints());
      final layoutOffsetInViewport =
          Offset(vicinity.xIndex * columnWidth, vicinity.yIndex * rowHeight);
      parentDataOf(child).layoutOffset = layoutOffsetInViewport -
          Offset(horizontalOffset.pixels, verticalOffset.pixels);
    }
  }

  @override
  void computeColumnRange() {
    final horizontalPixels = horizontalOffset.pixels;
    final viewportWidth = viewportDimension.width + cacheExtent;
    final maxColumnIndex = (delegate as BaseChildDelegate).maxXIndex;
    leadingColumn =
        math.max(((horizontalPixels - cacheExtent) / columnWidth).floor(), 0);
    trailingColumn = math.min(
        ((horizontalPixels + viewportWidth + cacheExtent) / columnWidth).ceil(),
        maxColumnIndex);
  }

  @override
  void computeRowRange() {
    final verticalPixels = verticalOffset.pixels;
    final viewportHeight = viewportDimension.height + cacheExtent;
    final maxRowIndex = (delegate as BaseChildDelegate).maxYIndex;
    leadingRow =
        math.max(((verticalPixels - cacheExtent) / rowHeight).floor(), 0);
    trailingRow = math.min(
        ((verticalPixels + viewportHeight + cacheExtent) / rowHeight).ceil(),
        maxRowIndex);
  }

  @override
  void updateExtent() {
    final builderDelegate = delegate as BaseChildDelegate;
    final maxRowIndex = builderDelegate.maxYIndex;
    final maxColumnIndex = builderDelegate.maxXIndex;
    final verticalExtent = rowHeight * maxRowIndex;
    final horizontalExtent = columnWidth * maxColumnIndex;
    verticalOffset.applyContentDimensions(
        0, math.max(verticalExtent - viewportDimension.height, 0));
    horizontalOffset.applyContentDimensions(
        0, math.max(horizontalExtent - viewportDimension.width, 0));
  }
}
