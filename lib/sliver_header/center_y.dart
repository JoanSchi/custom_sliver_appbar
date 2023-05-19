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

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  // }
}
