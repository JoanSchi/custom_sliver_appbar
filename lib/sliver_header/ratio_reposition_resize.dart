import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Ratio {
  final double dx;
  final double dy;

  const Ratio(
    this.dx,
    this.dy,
  );

  Offset toOffset(OffsetBase other) {
    if (other is Size) {
      return Offset(other.width * dx, other.height * dy);
    } else if (other is Offset) {
      return Offset(other.dx * dx, other.dy * dy);
    }

    throw ArgumentError(other);
  }
}

class RePositionReSize extends SingleChildRenderObjectWidget {
  const RePositionReSize({
    Key? key,
    Widget? child,
    required this.ratioPosition,
    required this.ratioHeight,
  }) : super(key: key, child: child);

  final Ratio ratioPosition;
  final double ratioHeight;

  @override
  RePositionReSizeRender createRenderObject(BuildContext context) {
    return RePositionReSizeRender(
        ratioPosition: ratioPosition, ratioHeight: ratioHeight);
  }

  @override
  void updateRenderObject(
      BuildContext context, RePositionReSizeRender renderObject) {
    renderObject
      ..ratioPosition = ratioPosition
      ..ratioHeight = ratioHeight;
  }
}

class RePositionReSizeRender extends RenderShiftedBox {
  RePositionReSizeRender({
    RenderBox? child,
    required Ratio ratioPosition,
    required double ratioHeight,
  })  : _ratioPosition = ratioPosition,
        _ratioHeight = ratioHeight,
        super(child);

  Ratio _ratioPosition;

  Ratio get ratioPosition => _ratioPosition;

  set ratioPosition(Ratio value) {
    if (_ratioPosition == value) return;
    _ratioPosition = value;
    markNeedsLayout();
  }

  double _ratioHeight;

  double get ratioHeight => _ratioHeight;

  set ratioHeight(double value) {
    if (_ratioHeight == value) return;
    _ratioHeight = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) child.parentData = BoxParentData();
  }

  // @override
  // double computeMinIntrinsicWidth(double height) {
  //   return super.computeMinIntrinsicWidth(height);
  // }

  // @override
  // double computeMaxIntrinsicWidth(double height) {
  //   return super.computeMaxIntrinsicWidth(height);
  // }

  // @override
  // double computeMinIntrinsicHeight(double width) {
  //   return super.computeMinIntrinsicHeight(width);
  // }

  // @override
  // double computeMaxIntrinsicHeight(double width) {
  //   return super.computeMaxIntrinsicHeight(width);
  // }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(const BoxConstraints(), parentUsesSize: true);

      Size sizeChild = child!.size;

      final BoxParentData parentData = child!.parentData as BoxParentData;

      size = constraints.constrain(sizeChild / ratioHeight);

      Offset correctOffset = ratioPosition.toOffset(sizeChild);

      parentData.offset = center(
          Offset(size.width - sizeChild.width, size.height - sizeChild.height) +
              correctOffset);
    } else {
      size = Size.zero;
    }
  }

  Offset center(Offset other) {
    final double centerX = other.dx / 2.0;
    final double centerY = other.dy / 2.0;
    return Offset(centerX, centerY);
  }

  // @override
  // Size computeDryLayout(BoxConstraints constraints) {
  //   if (child != null) {
  //     return child!.getDryLayout(constraints);
  //   } else {
  //     return Size.zero;
  //   }
  // }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   // properties.add(DiagnosticsProperty<double>('scale', scale));
  // }
}
