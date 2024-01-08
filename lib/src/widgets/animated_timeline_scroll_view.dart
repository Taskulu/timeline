import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../utils/child_delegate.dart';
import '../utils/model.dart';
import 'animated_viewport.dart';
import 'timeline_scroll_view.dart';

class AnimatedTimelineScrollView<T extends TimelineItem>
    extends TimelineScrollView<T> {
  final TickerProvider vsync;
  final Duration duration;
  final Curve curve;

  const AnimatedTimelineScrollView({
    super.key,
    required this.vsync,
    required this.duration,
    required super.columnWidth,
    required super.rowHeight,
    required super.delegate,
    this.curve = Curves.linear,
    super.primary,
    super.mainAxis,
    super.cacheExtent,
    super.clipBehavior,
    super.hitTestBehavior,
    super.verticalDetails,
    super.horizontalDetails,
    super.dragStartBehavior,
    super.diagonalDragBehavior,
    super.keyboardDismissBehavior,
  });

  @override
  Widget buildViewport(BuildContext context, ViewportOffset verticalOffset,
          ViewportOffset horizontalOffset) =>
      AnimatedTimelineViewport(
        vsync: vsync,
        duration: duration,
        curve: curve,
        columnWidth: columnWidth,
        rowHeight: rowHeight,
        verticalOffset: verticalOffset,
        verticalAxisDirection: verticalDetails.direction,
        horizontalOffset: horizontalOffset,
        horizontalAxisDirection: horizontalDetails.direction,
        delegate: delegate as BaseChildDelegate,
        mainAxis: mainAxis,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior,
      );
}
