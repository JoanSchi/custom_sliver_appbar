// Copyright (C) 2023 Joan Schipper
// 
// This file is part of custom_sliver_appbar.
// 
// custom_sliver_appbar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// custom_sliver_appbar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with custom_sliver_appbar.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Ratio {
  final double dx;
  final double dy;

  const Ratio.zero()
      : dx = 0.0,
        dy = 0.0;

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
    this.ratioPosition = const Ratio.zero(),
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
      child!.layout(
          BoxConstraints(
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight * ratioHeight),
          parentUsesSize: true);

      Size sizeChild = child!.size;

      final BoxParentData parentData = child!.parentData as BoxParentData;

      size = constraints
          .constrain(Size(sizeChild.width, sizeChild.height / ratioHeight));

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
