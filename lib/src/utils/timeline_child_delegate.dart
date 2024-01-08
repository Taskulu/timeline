import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'child_delegate.dart';
import 'model.dart';

class TimelineChildDelegate<T extends TimelineItem>
    extends BaseChildDelegate<T> {
  final T? Function(ChildVicinity) vicinityToItem;

  TimelineChildDelegate({
    required super.builder,
    required super.startDate,
    required super.endDate,
    required this.vicinityToItem,
    required int rows,
  }) : _maxYIndex = rows;

  int _maxYIndex;

  @override
  int get maxYIndex => _maxYIndex;

  set rows(int value) {
    if (value == _maxYIndex) return;
    _maxYIndex = value;
    notifyListeners();
  }

  @override
  Widget? build(BuildContext context, ChildVicinity vicinity) {
    if (vicinity.xIndex < 0 || (vicinity.xIndex > maxXIndex)) {
      return null;
    }
    if (vicinity.yIndex < 0 || (vicinity.yIndex > maxYIndex)) {
      return null;
    }

    final item = vicinityToItem(vicinity);
    if (item != null) {
      return builder(context, item);
    }

    return null;
  }

  @override
  bool shouldRebuild(covariant TwoDimensionalChildDelegate oldDelegate) => true;
}
