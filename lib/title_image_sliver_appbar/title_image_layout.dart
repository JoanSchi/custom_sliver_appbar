// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum TitleImageItem {
  title,
  image,
}

class TitleImageLayout extends MultiChildRenderObjectWidget {
  final bool isPortrait;
  final double space;

  TitleImageLayout({
    Key? key,
    List<Widget> children = const <Widget>[],
    this.isPortrait = true,
    this.space = 12.0,
  }) : super(key: key, children: children);

  @override
  RenderTitleImageLayout createRenderObject(BuildContext context) {
    return RenderTitleImageLayout(space: space, isPortrait: isPortrait);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderTitleImageLayout renderObject) {
    renderObject
      ..space = space
      ..isPortrait = isPortrait;
  }
}

class TitleImageWidget extends ParentDataWidget<TitleImageParentData> {
  /// Creates a widget that controls how a child of a [Row], [Column], or [Flex]
  /// flexes.
  const TitleImageWidget({
    Key? key,
    this.item = TitleImageItem.title,
    this.height = 0.0,
    this.padding = EdgeInsets.zero,
    this.position = 0.0,
    required Widget child,
  }) : super(key: key, child: child);

  final TitleImageItem item;
  final double height;
  final EdgeInsets padding;
  final double position;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is TitleImageParentData);
    final TitleImageParentData parentData =
        renderObject.parentData! as TitleImageParentData;
    bool needsLayout = false;

    if (parentData.item != item) {
      parentData.item = item;
      needsLayout = true;
    }

    if (parentData.height != height) {
      parentData.height = height;
      needsLayout = true;
    }

    if (parentData.padding != padding) {
      parentData.padding = padding;
      needsLayout = true;
    }

    if (parentData.position != position) {
      parentData.position = position;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => TitleImageLayout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('item', item));
  }
}

class TitleImageParentData extends ContainerBoxParentData<RenderBox> {
  TitleImageItem item = TitleImageItem.title;
  double height = 56.0;
  double position = 0.0;
  EdgeInsets padding = EdgeInsets.zero;

  @override
  String toString() =>
      'TitleImageParentData(item: $item, relativePosition: $padding)';
}

class RenderTitleImageLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TitleImageParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TitleImageParentData> {
  bool _isPortrait;
  double _space;

  RenderTitleImageLayout({
    List<RenderBox>? children,
    required bool isPortrait,
    required double space,
  })  : _isPortrait = isPortrait,
        _space = space {
    addAll(children);
  }

  set space(double value) {
    if (value != space) {
      _space = value;
      markNeedsLayout();
    }
  }

  double get space => _space;

  set isPortrait(bool value) {
    if (value != _isPortrait) {
      _isPortrait = value;
      markNeedsLayout();
    }
  }

  bool get isPortrait => _isPortrait;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! TitleImageParentData) {
      child.parentData = TitleImageParentData();
    }
  }

  @override
  void performLayout() {
    double width = constraints.maxWidth;
    double height = constraints.maxHeight;
    double x = 0.0;

    // print('height $height');

    RenderBox? child = firstChild;
    double widthChildren = 0.0;

    while (child != null) {
      final TitleImageParentData childParentData =
          child.parentData! as TitleImageParentData;

      child.layout(
          BoxConstraints(maxWidth: width, maxHeight: childParentData.height),
          parentUsesSize: true);

      widthChildren += child.size.width;

      child = childParentData.nextSibling;
    }

    x = (width - widthChildren - space) / 2.0;

    child = firstChild;

    while (child != null) {
      final TitleImageParentData childParentData =
          child.parentData! as TitleImageParentData;

      Size sizeChild = child.size;

      switch (childParentData.item) {
        case TitleImageItem.title:
          {
            double xc;
            double yc;
            if (isPortrait) {
              xc = (width - sizeChild.width) / 2.0;
              yc = yTitlePortrait(
                  height, childParentData.height, sizeChild.height);
            } else {
              xc = x;
              yc = yTitleLandscape(
                  height, childParentData.height, sizeChild.height);
              x += sizeChild.width;
            }

            childParentData.offset = Offset(xc, yc);
            break;
          }
        case TitleImageItem.image:
          {
            double xc;
            double yc;
            if (isPortrait) {
              xc = (width - sizeChild.width) / 2.0;
              yc = height -
                  childParentData.position -
                  sizeChild.height; //yFromBottom - sizeChild.height;
            } else {
              xc = x;
              yc = yTitleLandscape(
                  height, childParentData.height, sizeChild.height);
              x += sizeChild.width;
            }
            childParentData.offset = Offset(xc, yc);

            break;
          }
      }
      x += space;

      child = childParentData.nextSibling;
    }
    size = constraints.biggest;
  }

  double yTitleLandscape(height, desiredHeigth, childHeight) {
    return height - desiredHeigth + (desiredHeigth - childHeight) / 2.0;
  }

  double yTitlePortrait(height, desiredHeigth, childHeight) {
    return height - desiredHeigth + (desiredHeigth - childHeight) / 2.0;
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
