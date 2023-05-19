// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'dart:math' as math;

enum LbrFit { fit, even }

enum LbrItem { left, bottom, right }

class LbrLayout extends MultiChildRenderObjectWidget {
  final LbrFit lbrFit;

  const LbrLayout({
    Key? key,
    List<Widget> children = const <Widget>[],
    required this.lbrFit,
  }) : super(key: key, children: children);

  @override
  RenderLbrLayout createRenderObject(BuildContext context) {
    return RenderLbrLayout(
      lbrFit: lbrFit,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderLbrLayout renderObject) {
    renderObject.lbrFit = lbrFit;
  }
}

class LbrWidget extends ParentDataWidget<LbrParentData> {
  const LbrWidget({
    Key? key,
    required this.item,
    required Widget child,
  }) : super(key: key, child: child);

  final LbrItem item;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is LbrParentData);
    final LbrParentData parentData = renderObject.parentData! as LbrParentData;
    bool needsLayout = false;

    if (parentData.item != item) {
      parentData.item = item;
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

class LbrParentData extends ContainerBoxParentData<RenderBox> {
  LbrItem item = LbrItem.bottom;

  @override
  String toString() => 'LbrParentData(item: $item)';
}

class RenderLbrLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, LbrParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, LbrParentData> {
  LbrFit _lbrFit;

  RenderLbrLayout({
    List<RenderBox>? children,
    required LbrFit lbrFit,
  }) : _lbrFit = lbrFit {
    addAll(children);
  }

  set lbrFit(LbrFit value) {
    if (value != _lbrFit) {
      _lbrFit = value;
      markNeedsLayout();
    }
  }

  LbrFit get lbrFit => _lbrFit;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! LbrParentData) {
      child.parentData = LbrParentData();
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
      final LbrParentData childParentData = child.parentData! as LbrParentData;

      switch (childParentData.item) {
        case LbrItem.left:
          {
            layoutChild(
              child,
              width,
              height,
            );

            final sizeChild = child.size;
            leftWidth = sizeChild.width;
            childParentData.offset =
                Offset(0.0, (height - sizeChild.height) / 2.0);

            break;
          }
        case LbrItem.right:
          {
            layoutChild(child, width, height);

            final sizeChild = child.size;

            rightWidth = sizeChild.width;

            childParentData.offset = Offset(
                width - sizeChild.width, (height - sizeChild.height) / 2.0);
            break;
          }
        default:
          {}
      }
      child = childParentData.nextSibling;
    }

    child = firstChild;

    while (child != null) {
      final LbrParentData childParentData = child.parentData! as LbrParentData;

      if (childParentData.item == LbrItem.bottom) {
        double left;
        double widthBottom;

        switch (lbrFit) {
          case LbrFit.even:
            left = math.max(leftWidth, rightWidth);
            widthBottom = width - 2.0 * left;
            break;
          case LbrFit.fit:
            left = leftWidth;
            widthBottom = width - leftWidth - rightWidth;
            break;
        }

        layoutChild(child, widthBottom, height);

        final sizeChild = child.size;
        childParentData.offset = Offset(left, height - sizeChild.height);
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
