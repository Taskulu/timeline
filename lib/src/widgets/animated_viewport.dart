import 'package:flutter/material.dart';

import '../rendering/animated_viewport.dart';
import '../utils/child_delegate.dart';
import 'viewport.dart';

class AnimatedTimelineViewport extends TimelineViewport {
  final Curve curve;
  final TickerProvider vsync;
  final Duration duration;

  const AnimatedTimelineViewport({
    super.key,
    required this.vsync,
    required this.duration,
    required super.columnWidth,
    required super.rowHeight,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    this.curve = Curves.linear,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  AnimatedRenderTimelineViewport createRenderObject(BuildContext context) =>
      AnimatedRenderTimelineViewport(
        vsync: vsync,
        curve: curve,
        duration: duration,
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
      covariant AnimatedRenderTimelineViewport renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.duration = duration;
  }
}
