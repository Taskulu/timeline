import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../utils/child_delegate.dart';
import '../utils/model.dart';
import 'viewport.dart';

class TimelineScrollView<T extends TimelineItem>
    extends TwoDimensionalScrollView {
  final double columnWidth, rowHeight;

  const TimelineScrollView({
    super.key,
    required this.columnWidth,
    required this.rowHeight,
    required BaseChildDelegate<T> super.delegate,
    super.primary,
    super.mainAxis,
    super.cacheExtent,
    super.clipBehavior,
    super.verticalDetails,
    super.horizontalDetails,
    super.dragStartBehavior,
    super.diagonalDragBehavior,
    super.keyboardDismissBehavior,
    super.hitTestBehavior,
  });

  @override
  Widget buildViewport(BuildContext context, ViewportOffset verticalOffset,
          ViewportOffset horizontalOffset) =>
      TimelineViewport(
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
