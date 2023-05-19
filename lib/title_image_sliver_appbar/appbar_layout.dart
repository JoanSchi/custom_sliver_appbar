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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum AppBarItem {
  center,
  bottom,
  left,
  right,
}

class AppBarLayout extends MultiChildRenderObjectWidget {
  final double innerPadding;

  const AppBarLayout({
    Key? key,
    List<Widget> children = const <Widget>[],
    this.innerPadding = 12.0,
  }) : super(key: key, children: children);

  @override
  RenderAppBarLayout createRenderObject(BuildContext context) {
    return RenderAppBarLayout(
      innerPadding: innerPadding,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderAppBarLayout renderObject) {
    renderObject.innerPadding = innerPadding;
  }
}

class AppBarWidget extends ParentDataWidget<AppBarParentData> {
  /// Creates a widget that controls how a child of a [Row], [Column], or [Flex]
  /// flexes.
  const AppBarWidget({
    Key? key,
    required this.item,
    this.height = 0.0,
    this.padding = EdgeInsets.zero,
    this.position = 0.0,
    required Widget child,
  }) : super(key: key, child: child);

  final AppBarItem item;
  final double height;
  final double position;
  final EdgeInsets padding;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is AppBarParentData);
    final AppBarParentData parentData =
        renderObject.parentData! as AppBarParentData;
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
  Type get debugTypicalAncestorWidgetClass => AppBarLayout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('item', item));
  }
}

class AppBarParentData extends ContainerBoxParentData<RenderBox> {
  AppBarItem item = AppBarItem.center;
  double height = 0.0;
  double position = 0.0;
  EdgeInsets padding = EdgeInsets.zero;

  @override
  String toString() =>
      'TitleImageParentData(item: $item, relativePosition: $height)';
}

class RenderAppBarLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, AppBarParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, AppBarParentData> {
  double _innerPadding;

  RenderAppBarLayout({
    List<RenderBox>? children,
    required double innerPadding,
  }) : _innerPadding = innerPadding {
    addAll(children);
  }

  set innerPadding(double value) {
    if (value != _innerPadding) {
      _innerPadding = value;
      markNeedsLayout();
    }
  }

  double get innerPadding => _innerPadding;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! AppBarParentData) {
      child.parentData = AppBarParentData();
    }
  }

  @override
  void performLayout() {
    double width = constraints.maxWidth;
    double height = constraints.maxHeight;

    double bottom = 0.0;

    RenderBox? child = firstChild;

    while (child != null) {
      final AppBarParentData childParentData =
          child.parentData! as AppBarParentData;

      EdgeInsets padding = childParentData.padding;

      child.layout(
          BoxConstraints(
            maxWidth: width - padding.horizontal,
            maxHeight: childParentData.height - padding.vertical,
          ),
          parentUsesSize: true);

      Size sizeChild = child.size;

      switch (childParentData.item) {
        case AppBarItem.center:
          {
            double xc = 0.0;
            double yc = height - childParentData.position - sizeChild.height;
            childParentData.offset = Offset(xc, yc);
          }
          break;
        case AppBarItem.bottom:
          {
            bottom = sizeChild.height;
            double xc = 0.0;
            double yc = height - bottom;
            childParentData.offset = Offset(xc, yc);
          }
          break;
        case AppBarItem.left:
          double xc = 0.0;
          double yc = centerY(sizeChild.height, childParentData);
          childParentData.offset = Offset(xc, yc);
          break;
        case AppBarItem.right:
          double xc = width - sizeChild.width;
          double yc = centerY(sizeChild.height, childParentData);
          childParentData.offset = Offset(xc, yc);
          break;
      }
      child = childParentData.nextSibling;
    }
    size = constraints.biggest;
  }

  double centerY(childHeight, AppBarParentData parentData) {
    return parentData.position + (parentData.height - childHeight) / 2.0;
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
