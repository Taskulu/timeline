import 'package:flutter/material.dart';

import '../rendering/viewport.dart';
import '../utils/child_delegate.dart';

class TimelineViewport extends TwoDimensionalViewport {
  final double columnWidth, rowHeight;

  const TimelineViewport({
    super.key,
    required this.columnWidth,
    required this.rowHeight,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required BaseChildDelegate super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  RenderTimelineViewport createRenderObject(BuildContext context) =>
      RenderTimelineViewport(
        columnWidth: columnWidth,
        rowHeight: rowHeight,
        horizontalOffset: horizontalOffset,
        horizontalAxisDirection: horizontalAxisDirection,
        verticalOffset: verticalOffset,
        verticalAxisDirection: verticalAxisDirection,
        delegate: delegate as BaseChildDelegate,
        mainAxis: mainAxis,
        childManager: context as TwoDimensionalChildManager,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior,
      );

  @override
  void updateRenderObject(BuildContext context,
          covariant RenderTimelineViewport renderObject) =>
      renderObject
        ..horizontalOffset = horizontalOffset
        ..horizontalAxisDirection = horizontalAxisDirection
        ..verticalOffset = verticalOffset
        ..verticalAxisDirection = verticalAxisDirection
        ..delegate = delegate
        ..mainAxis = mainAxis
        ..cacheExtent = cacheExtent
        ..clipBehavior = clipBehavior;
}
