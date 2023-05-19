import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

enum LrTbFit {
  even,
  fit,
  no,
}

enum LrTbPositionFrom {
  top,
  bottom,
}

enum LrTbItem {
  bottom,
  center,
  left,
  right,
}

class LrTbLayout extends MultiChildRenderObjectWidget {
  final double aligmentRatio;
  final LrTbFit lrTbFit;

  const LrTbLayout({
    Key? key,
    List<Widget> children = const <Widget>[],
    required this.aligmentRatio,
    required this.lrTbFit,
  }) : super(key: key, children: children);

  @override
  RenderLrTbLayout createRenderObject(BuildContext context) {
    return RenderLrTbLayout(
      alignmentRatio: aligmentRatio,
      lrTbFit: lrTbFit,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderLrTbLayout renderObject) {
    renderObject
      ..ratio = aligmentRatio
      ..lrTbFit = lrTbFit;
  }
}

class LrTbWidget extends ParentDataWidget<LrTbParentData> {
  const LrTbWidget({
    Key? key,
    required this.item,
    this.height = 0.0,
    this.position = 0.0,
    required this.lrTbPositionFrom,
    required Widget child,
  }) : super(key: key, child: child);

  final LrTbItem item;
  final double height;
  final double position;
  final LrTbPositionFrom lrTbPositionFrom;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is LrTbParentData);
    final LrTbParentData parentData =
        renderObject.parentData! as LrTbParentData;
    bool needsLayout = false;

    if (parentData.item != item) {
      parentData.item = item;
      needsLayout = true;
    }

    if (parentData.height != height) {
      parentData.height = height;
      needsLayout = true;
    }

    if (parentData.possition != position) {
      parentData.possition = position;
      needsLayout = true;
    }

    if (parentData.lrTbPositionFrom != lrTbPositionFrom) {
      parentData.lrTbPositionFrom = lrTbPositionFrom;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => LrTbLayout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('item', item));
  }
}

class LrTbParentData extends ContainerBoxParentData<RenderBox> {
  LrTbItem item = LrTbItem.bottom;
  double height = 0.0;
  double possition = 0.0;
  LrTbPositionFrom lrTbPositionFrom = LrTbPositionFrom.bottom;

  @override
  String toString() =>
      'TitleImageParentData(item: $item, relativePosition: $height)';
}

class RenderLrTbLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, LrTbParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, LrTbParentData> {
  double _ratio;
  LrTbFit _lrTbFit;

  RenderLrTbLayout({
    List<RenderBox>? children,
    required double alignmentRatio,
    required LrTbFit lrTbFit,
  })  : _ratio = alignmentRatio,
        _lrTbFit = lrTbFit {
    addAll(children);
  }

  set ratio(double value) {
    if (value != _ratio) {
      _ratio = value;
      markNeedsLayout();
    }
  }

  double get ratio => _ratio;

  set lrTbFit(LrTbFit value) {
    if (value != _lrTbFit) {
      _lrTbFit = value;
      markNeedsLayout();
    }
  }

  LrTbFit get lrTbFit => _lrTbFit;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! LrTbParentData) {
      child.parentData = LrTbParentData();
    }
  }

  @override
  void performLayout() {
    double width = constraints.maxWidth;
    double height = constraints.maxHeight;

    double leftWidth = 0.0;
    double rightWidth = 0.0;

    RenderBox? child = firstChild;

    while (child != null) {
      final LrTbParentData childParentData =
          child.parentData! as LrTbParentData;

      switch (childParentData.item) {
        case LrTbItem.left:
          {
            layoutChild(
              child,
              width,
              childParentData.height,
            );

            final sizeChild = child.size;

            final top = (height < childParentData.possition + sizeChild.height
                ? height - sizeChild.height
                : childParentData.possition);

            leftWidth = sizeChild.width;

            childParentData.offset = Offset(0.0, top);

            break;
          }
        case LrTbItem.right:
          {
            layoutChild(child, width, childParentData.height);

            final sizeChild = child.size;

            final top = (height < childParentData.possition + sizeChild.height
                ? height - sizeChild.height
                : childParentData.possition);

            rightWidth = sizeChild.width;

            childParentData.offset = Offset(width - sizeChild.width, top);
            break;
          }
        default:
          {}
      }
      child = childParentData.nextSibling;
    }

    child = firstChild;

    while (child != null) {
      final LrTbParentData childParentData =
          child.parentData! as LrTbParentData;

      switch (childParentData.item) {
        case LrTbItem.bottom:
          {
            double left;
            double widthBottom;

            switch (lrTbFit) {
              case LrTbFit.even:
                left = math.max(leftWidth, rightWidth) * ratio;
                widthBottom = width - 2.0 * left;
                break;
              case LrTbFit.fit:
                left = leftWidth * ratio;
                widthBottom = width - leftWidth * ratio - rightWidth * ratio;
                break;
              case LrTbFit.no:
                left = 0.0;
                widthBottom = width;
                break;
            }

            layoutChild(child, widthBottom, childParentData.height);

            final sizeChild = child.size;
            childParentData.offset = Offset(
                left, childParentData.possition + height - sizeChild.height);

            break;
          }
        case LrTbItem.center:
          {
            double left = math.max(leftWidth * ratio, rightWidth * ratio);
            layoutChild(child, width - 2.0 * left, childParentData.height);

            final sizeChild = child.size;

            childParentData.offset = Offset(
                left, height - childParentData.possition - sizeChild.height);
            break;
          }
        default:
          {}
      }
      child = childParentData.nextSibling;
    }

    size = constraints.biggest;
  }

  void layoutChild(RenderBox child, double width, double height) {
    child.layout(
        BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        parentUsesSize: true);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
