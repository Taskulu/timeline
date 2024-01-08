import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:timeline/timeline.dart';

class Item extends TimelineItem {
  final String id;
  final Color color;

  const Item({
    required this.id,
    required super.start,
    required super.end,
    required this.color,
  });

  DateTimeRange get range => DateTimeRange(start: start, end: end);
}

final List<List<Item>> items1 = [
  [
    Item(
      id: '1',
      start: DateTime(2024, 1, 3),
      end: DateTime(2024, 1, 5),
      color: Colors.blue,
    ),
    Item(
      id: '4',
      start: DateTime(2024, 1, 15),
      end: DateTime(2024, 1, 19),
      color: Colors.red,
    ),
  ],
  [
    Item(
      id: '2',
      start: DateTime(2024, 1, 5),
      end: DateTime(2024, 1, 6),
      color: Colors.yellow,
    ),
  ],
  [
    Item(
      id: '3',
      start: DateTime(2024, 1, 5),
      end: DateTime(2024, 1, 7),
      color: Colors.green,
    ),
  ],
];

final List<List<Item>> items2 = [
  [
    Item(
      id: '1',
      start: DateTime(2024, 1, 6),
      end: DateTime(2024, 1, 8),
      color: Colors.blue,
    ),
    Item(
      id: '2',
      start: DateTime(2024, 1, 2),
      end: DateTime(2024, 1, 4),
      color: Colors.yellow,
    ),
    Item(
      id: '4',
      start: DateTime(2024, 1, 15),
      end: DateTime(2024, 1, 19),
      color: Colors.red,
    ),
  ],
  [
    Item(
      id: '3',
      start: DateTime(2024, 1, 5),
      end: DateTime(2024, 1, 7),
      color: Colors.green,
    ),
  ],
];

const _columnWidth = 50.0;
const _rowHeight = 50.0;

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  late List<List<Item>> items;

  @override
  void initState() {
    super.initState();
    items = items1;
  }

  void updateItems() {
    if (items == items1) {
      items = items2;
    } else {
      items = items1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timeline Demo')),
      floatingActionButton: FloatingActionButton(
          onPressed: updateItems, child: Icon(Icons.update)),
      body: Timeline<Item>(
        items: items,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 2, 1),
        biggestItemRange: DateTimeRange(
            start: DateTime(2024, 1, 5), end: DateTime(2024, 1, 12)),
        columnWidth: _columnWidth,
        rowHeight: _rowHeight,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        builder: (context, item) {
          final width = (item.range.duration.inDays + 1) * _columnWidth;
          return AnimatedContainer(
            key: ValueKey(item.id),
            duration: Duration(milliseconds: 250),
            alignment: AlignmentDirectional.topStart,
            curve: Curves.easeInOut,
            width: width,
            height: _rowHeight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: item.color),
          );
        },
      ),
    );
  }
}

class Timeline<T extends TimelineItem> extends StatefulWidget {
  final List<List<T>> items;
  final TimelineItemBuilder<T> builder;
  final double columnWidth, rowHeight;
  final Duration duration;
  final Curve? curve;
  final DateTime startDate, endDate;
  final DateTimeRange biggestItemRange;

  const Timeline({
    super.key,
    required this.items,
    required this.builder,
    required this.columnWidth,
    required this.rowHeight,
    required this.startDate,
    required this.endDate,
    required this.biggestItemRange,
    required this.duration,
    this.curve,
  });

  @override
  State<Timeline<T>> createState() => _TimelineState<T>();
}

class _TimelineState<T extends TimelineItem> extends State<Timeline<T>>
    with TickerProviderStateMixin {
  final _horizontalGroupController = LinkedScrollControllerGroup();
  final _verticalGroupController = LinkedScrollControllerGroup();
  late final _calendarController = _horizontalGroupController.addAndGet();
  late final _itemsHorizontalController =
      _horizontalGroupController.addAndGet();
  late final _itemsVerticalController = _verticalGroupController.addAndGet();
  late final _timelineGridsController = _horizontalGroupController.addAndGet();

  @override
  Widget build(BuildContext context) {
    final columnsCount = widget.endDate.difference(widget.startDate).inDays + 1;
    return Scrollbar(
      controller: _itemsHorizontalController,
      child: Column(
        children: [
          SizedBox(
            height: widget.columnWidth,
            child: ListView.builder(
              controller: _calendarController,
              scrollDirection: Axis.horizontal,
              itemExtent: widget.columnWidth,
              itemCount: columnsCount,
              itemBuilder: (context, index) {
                final date = DateUtils.addDaysToDate(widget.startDate, index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(date.day.toString()),
                    Text(date.month.toString()),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _itemsVerticalController,
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _timelineGridsController,
                    scrollDirection: Axis.horizontal,
                    itemExtent: widget.columnWidth,
                    itemCount: columnsCount,
                    itemBuilder: (_, index) {
                      const divider = Align(
                        alignment: AlignmentDirectional.topStart,
                        child: VerticalDivider(width: 0),
                      );
                      if (index % 5 <= 1) {
                        return Container(
                          width: widget.columnWidth * 2,
                          color: Colors.grey,
                        );
                      }
                      return divider;
                    },
                  ),
                  AnimatedTimelineScrollView<T>(
                    vsync: this,
                    duration: widget.duration,
                    curve: Curves.easeInOut,
                    horizontalDetails: ScrollableDetails.horizontal(
                      controller: _itemsHorizontalController,
                    ),
                    verticalDetails: ScrollableDetails.vertical(
                      controller: _itemsVerticalController,
                      physics: const ClampingScrollPhysics(),
                    ),
                    columnWidth: widget.columnWidth,
                    rowHeight: widget.rowHeight,
                    cacheExtent: widget.biggestItemRange.duration.inDays *
                        widget.columnWidth,
                    diagonalDragBehavior:
                        DiagonalDragBehavior.weightedContinuous,
                    delegate: TimelineChildDelegate(
                      startDate: widget.startDate,
                      endDate: widget.endDate,
                      rows: widget.items.length,
                      builder: widget.builder,
                      vicinityToItem: (vicinity) {
                        final date = DateUtils.addDaysToDate(
                            widget.startDate, vicinity.xIndex);
                        return widget.items[vicinity.yIndex].firstWhereOrNull(
                            (e) => DateUtils.isSameDay(date, e.start));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
