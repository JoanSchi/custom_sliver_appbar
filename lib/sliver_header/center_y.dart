import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class CenterY extends SingleChildRenderObjectWidget {
  const CenterY({
    super.key,
    super.child,
  });

  @override
  RenderCenterY createRenderObject(BuildContext context) {
    return RenderCenterY();
  }

  @override
  void updateRenderObject(BuildContext context, RenderCenterY renderObject) {}
}

class RenderCenterY extends RenderShiftedBox {
  RenderCenterY({
    RenderBox? child,
  }) : super(child);

  @override
  void performLayout() {
    final c = child;
    if (c != null) {
      final height = constraints.biggest.height;
      c.layout(constraints.loosen(), parentUsesSize: true);

      Size childSize = c.size;

      final BoxParentData childParentData = c.parentData! as BoxParentData;
      childParentData.offset = Offset(0.0, (height - childSize.height) / 2.0);

      size = Size(childSize.width, height);
    } else {
      size = Size.zero;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
