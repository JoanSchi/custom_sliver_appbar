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

class CustomImage {
  final double? minimum;
  final bool includeTopWithMinium;
  final WidgetBuilder imageBuilder;

  CustomImage({
    this.minimum = 56.0,
    this.includeTopWithMinium = true,
    required this.imageBuilder,
  });
}

class CustomTitle {
  final String title;
  final TextStyleTween textStyleTween;
  final Tween<double> height;

  CustomTitle({
    required this.title,
    required this.textStyleTween,
    required this.height,
  });

  CustomTitle copyWith({
    String? title,
    TextStyleTween? textStyleTween,
    Tween<double>? height,
  }) {
    return CustomTitle(
      title: title ?? this.title,
      textStyleTween: textStyleTween ?? this.textStyleTween,
      height: height ?? this.height,
    );
  }
}
