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

import 'package:flutter/widgets.dart';

class ClipTop extends StatelessWidget {
  final Widget child;

  final double maxHeight;

  const ClipTop({super.key, required this.child, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: TopClipper(maxHeight),
      child: child,
    );
  }
}

class TopClipper extends CustomClipper<Rect> {
  final double maxHeight;

  TopClipper(this.maxHeight);

  @override
  Rect getClip(Size size) {
    if (maxHeight < size.height) {
      return Rect.fromLTWH(0.0, size.height - maxHeight, size.width, maxHeight);
    } else {
      return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(TopClipper oldClipper) {
    return maxHeight != oldClipper.maxHeight;
  }
}
