import 'package:flutter/material.dart';

import '../utils/child_delegate.dart';

abstract class BaseTwoDimensionalViewport extends RenderTwoDimensionalViewport {
  int leadingColumn = 0, trailingColumn = 0;
  int leadingRow = 0, trailingRow = 0;

  BaseTwoDimensionalViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required BaseChildDelegate super.delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  void layoutChildSequence() {
    computeColumnRange();
    computeRowRange();
    updateExtent();
  }

  void computeColumnRange();
  void computeRowRange();
  void updateExtent();
}
