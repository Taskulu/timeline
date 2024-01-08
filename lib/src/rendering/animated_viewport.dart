import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'viewport.dart';

class AnimatedTwoDimensionalViewportParentData
    extends TwoDimensionalViewportParentData {
  /// It's to track whether the child's position needs to be animated
  /// It will be set after the child laid out
  ChildVicinity previousVicinity = ChildVicinity.invalid;

  AnimationController? _controller;
  double? _lastValue;
  Animation<Offset>? _animation;

  void initiateLayoutAnimation(
    Offset currentLayoutOffsetInViewport,
    Offset newLayoutOffsetInViewport,
    TickerProvider vsync,
    Duration duration,
    VoidCallback markNeedsLayout,
    Curve curve,
  ) {
    _controller?.dispose();
    _controller = AnimationController(vsync: vsync, duration: duration)
      ..addListener(() {
        if (_controller != null && _controller?.value != _lastValue) {
          markNeedsLayout();
        }
        if (_controller?.isCompleted == true) {
          _controller?.dispose();
          _controller = null;
          _lastValue = null;
          _animation = null;
        }
      })
      ..forward(from: 0);
    final tween = Tween(
        begin: currentLayoutOffsetInViewport, end: newLayoutOffsetInViewport);
    _animation =
        tween.animate(CurvedAnimation(parent: _controller!, curve: curve));
  }

  Offset? get animationValue => _animation?.value;

  @override
  void detach() {
    _controller?.dispose();
    super.detach();
  }
}

class AnimatedRenderTimelineViewport extends RenderTimelineViewport {
  final TickerProvider vsync;

  Duration _duration;
  Curve _curve;

  AnimatedRenderTimelineViewport({
    required this.vsync,
    required Duration duration,
    required super.columnWidth,
    required super.rowHeight,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior,
    Curve curve = Curves.linear,
  })  : _duration = duration,
        _curve = curve;

  set duration(Duration value) {
    _duration = value;
  }

  set curve(Curve value) {
    _curve = value;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! AnimatedTwoDimensionalViewportParentData) {
      child.parentData = AnimatedTwoDimensionalViewportParentData();
    }
  }

  @override
  void layoutChild(ChildVicinity vicinity) {
    final child = buildOrObtainChildFor(vicinity);
    if (child != null) {
      child.layout(BoxConstraints());
      final parentData =
          parentDataOf(child) as AnimatedTwoDimensionalViewportParentData;
      final previousVicinity = parentData.previousVicinity;
      final newLayoutOffsetInViewport =
          Offset(vicinity.xIndex * columnWidth, vicinity.yIndex * rowHeight);
      final Offset layoutOffsetInViewport;
      if (previousVicinity != ChildVicinity.invalid &&
          previousVicinity != vicinity) {
        final currentLayoutOffsetInViewport = parentData.animationValue ??
            Offset(previousVicinity.xIndex * columnWidth,
                previousVicinity.yIndex * rowHeight);
        parentData.initiateLayoutAnimation(
          currentLayoutOffsetInViewport,
          newLayoutOffsetInViewport,
          vsync,
          _duration,
          markNeedsLayout,
          _curve,
        );
        layoutOffsetInViewport = currentLayoutOffsetInViewport;
      } else {
        layoutOffsetInViewport =
            parentData.animationValue ?? newLayoutOffsetInViewport;
      }
      parentData.layoutOffset = layoutOffsetInViewport -
          Offset(horizontalOffset.pixels, verticalOffset.pixels);
      parentData.previousVicinity = parentData.vicinity;
      parentData._lastValue = parentData._controller?.value;
    }
  }
}
