import 'package:flutter/widgets.dart';

import 'model.dart';

typedef TimelineItemBuilder<T extends TimelineItem> = Widget Function(
    BuildContext context, T item);

abstract class BaseChildDelegate<T extends TimelineItem>
    extends TwoDimensionalChildDelegate {
  BaseChildDelegate({
    required this.builder,
    required DateTime startDate,
    required DateTime endDate,
  })  : assert(endDate.isAfter(startDate)),
        _startDate = startDate,
        _endDate = endDate;

  final TimelineItemBuilder<T> builder;

  DateTime get startDate => _startDate;
  DateTime _startDate;
  set startDate(DateTime value) {
    assert(value.isBefore(endDate));
    if (value == startDate) {
      return;
    }
    _startDate = value;
    notifyListeners();
  }

  DateTime get endDate => _endDate;
  DateTime _endDate;
  set endDate(DateTime value) {
    assert(value.isAfter(startDate));
    if (value == endDate) {
      return;
    }
    _endDate = value;
    notifyListeners();
  }

  int get maxXIndex => endDate.difference(startDate).inDays;
  int get maxYIndex;

  @override
  bool shouldRebuild(covariant TwoDimensionalChildDelegate oldDelegate) => true;
}
