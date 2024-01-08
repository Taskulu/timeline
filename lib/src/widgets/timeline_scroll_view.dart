import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide TwoDimensionalScrollable;

import '../utils/child_delegate.dart';
import '../utils/model.dart';
import 'viewport.dart';
import 'two_dimensional_scrollable.dart';

class TimelineScrollView<T extends TimelineItem>
    extends TwoDimensionalScrollView {
  final double columnWidth, rowHeight;
  final HitTestBehavior hitTestBehavior;

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
    this.hitTestBehavior = HitTestBehavior.opaque,
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

  @override
  Widget build(BuildContext context) {
    assert(axisDirectionToAxis(verticalDetails.direction) == Axis.vertical,
        'TwoDimensionalScrollView.verticalDetails are not Axis.vertical.');
    assert(axisDirectionToAxis(horizontalDetails.direction) == Axis.horizontal,
        'TwoDimensionalScrollView.horizontalDetails are not Axis.horizontal.');

    ScrollableDetails mainAxisDetails = switch (mainAxis) {
      Axis.vertical => verticalDetails,
      Axis.horizontal => horizontalDetails,
    };

    final bool effectivePrimary = primary ??
        mainAxisDetails.controller == null &&
            PrimaryScrollController.shouldInherit(
              context,
              mainAxis,
            );

    if (effectivePrimary) {
      // Using PrimaryScrollController for mainAxis.
      assert(
          mainAxisDetails.controller == null,
          'TwoDimensionalScrollView.primary was explicitly set to true, but a '
          'ScrollController was provided in the ScrollableDetails of the '
          'TwoDimensionalScrollView.mainAxis.');
      mainAxisDetails = mainAxisDetails.copyWith(
        controller: PrimaryScrollController.of(context),
      );
    }

    final TwoDimensionalScrollable scrollable = TwoDimensionalScrollable(
      horizontalDetails: switch (mainAxis) {
        Axis.horizontal => mainAxisDetails,
        Axis.vertical => horizontalDetails,
      },
      verticalDetails: switch (mainAxis) {
        Axis.vertical => mainAxisDetails,
        Axis.horizontal => verticalDetails,
      },
      diagonalDragBehavior: diagonalDragBehavior,
      viewportBuilder: buildViewport,
      dragStartBehavior: dragStartBehavior,
      hitTestBehavior: hitTestBehavior,
    );

    final Widget scrollableResult = effectivePrimary
        // Further descendant ScrollViews will not inherit the same PrimaryScrollController
        ? PrimaryScrollController.none(child: scrollable)
        : scrollable;

    if (keyboardDismissBehavior == ScrollViewKeyboardDismissBehavior.onDrag) {
      return NotificationListener<ScrollUpdateNotification>(
        child: scrollableResult,
        onNotification: (ScrollUpdateNotification notification) {
          final FocusScopeNode focusScope = FocusScope.of(context);
          if (notification.dragDetails != null && focusScope.hasFocus) {
            focusScope.unfocus();
          }
          return false;
        },
      );
    }
    return scrollableResult;
  }
}
