import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShapeBorderLbRbRounded extends ShapeBorder {
  final double leftTopRadial;
  final double rightTopRadial;
  final double leftBottomRadial;
  final double rightBottomRadial;
  final double topPadding;
  final double heightToFlat;
  final double leftInsets;
  final double rightInsets;
  final pi = math.pi;

  ShapeBorderLbRbRounded({
    this.heightToFlat = 28.0,
    this.leftTopRadial = 16.0,
    this.rightTopRadial = 16.0,
    this.leftBottomRadial = 16.0,
    this.rightBottomRadial = 16.0,
    this.topPadding = 0.0,
    this.leftInsets = 0.0,
    this.rightInsets = 0.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(rect, inner: true);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(rect);
  }

  Path getPath(Rect rect, {inner = false}) {
    final width = rect.width;
    final height = inner ? rect.height : rect.height;
    double minLeftHeight = leftInsets == 0.0 ? heightToFlat : topPadding;
    double minRightHeight = rightInsets == 0.0 ? heightToFlat : topPadding;

    Path path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, minLeftHeight);

    bool equalToStatusBar = rect.height <= minLeftHeight;

    if (equalToStatusBar) {
      path
        ..lineTo(width, minLeftHeight)
        ..lineTo(width, 0.0)
        ..close();

      return path;
    }

    final availibleLeftSpace = rect.height - minLeftHeight;
    const curveFactor = 0.5;

    /* Left
     *
     */
    final neededSpaceLeft = leftTopRadial + leftBottomRadial;

    double leftFactor = availibleLeftSpace > neededSpaceLeft
        ? 1.0
        : availibleLeftSpace / neededSpaceLeft;

    //lefDistance is distance between controlPoint X2 top to controlPoint X1 bottom

    final double leftDistance = (availibleLeftSpace < neededSpaceLeft)
        ? math.sqrt(neededSpaceLeft * neededSpaceLeft -
                availibleLeftSpace * availibleLeftSpace) *
            curveFactor
        : 0.0;

    if (leftInsets != 0.0) {
      if (leftTopRadial * leftFactor != 0.0) {
        path.lineTo(leftInsets - leftTopRadial, minLeftHeight);

        path.quadraticBezierTo(
          leftInsets - (leftDistance / neededSpaceLeft * leftTopRadial),
          minLeftHeight,
          leftInsets,
          minLeftHeight + leftTopRadial * leftFactor,
        );
      } else {
        path.lineTo(leftInsets, minRightHeight);
      }
    }

    if (leftBottomRadial != 0.0) {
      path
        ..lineTo(leftInsets, height - leftBottomRadial * leftFactor)
        ..quadraticBezierTo(
          leftInsets +
              (leftDistance / neededSpaceLeft * leftBottomRadial / 2.0),
          height,
          leftInsets + leftBottomRadial,
          height,
        );
    } else {
      path.lineTo(leftInsets, height);
    }

    /* Right
     *
     */
    final availibleRightSpace = rect.height - minRightHeight;
    final neededSpaceRight = rightTopRadial + rightBottomRadial;

    double rightFactor = availibleRightSpace > neededSpaceRight
        ? 1.0
        : availibleRightSpace / neededSpaceRight;

    //rightDistance is distance between controlPoint X2 top to controlPoint X1 bottom

    final double rightDistance = (availibleRightSpace < neededSpaceRight)
        ? math.sqrt(neededSpaceRight * neededSpaceRight -
                availibleRightSpace * availibleRightSpace) *
            curveFactor
        : 0.0;

    if (rightBottomRadial != 0.0) {
      path
        ..lineTo(width - rightInsets - rightBottomRadial, height)
        ..quadraticBezierTo(
            width -
                rightInsets -
                rightDistance / neededSpaceRight * rightBottomRadial,
            height,
            width - rightInsets,
            height - rightBottomRadial * rightFactor);
    } else {
      path.lineTo(width - rightInsets, height);
    }

    if (rightInsets != 0.0) {
      if (rightTopRadial != 0.0) {
        path
          ..lineTo(width - rightInsets,
              minRightHeight + rightTopRadial * rightFactor)
          ..quadraticBezierTo(
              width -
                  rightInsets +
                  rightDistance / neededSpaceRight * rightTopRadial,
              minRightHeight,
              width - rightInsets + rightTopRadial,
              minRightHeight);
      } else {
        path.lineTo(width - rightInsets, minRightHeight);
      }
    }

    path
      ..lineTo(width, minRightHeight)
      ..lineTo(width, 0.0)
      ..close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return ShapeBorderLbRbRounded(
      heightToFlat: heightToFlat * t,
      leftTopRadial: leftTopRadial * t,
      rightTopRadial: rightTopRadial * t,
      leftBottomRadial: leftBottomRadial * t,
      rightBottomRadial: rightBottomRadial * t,
      leftInsets: leftInsets * t,
      rightInsets: rightInsets * t,
    );
  }
}
