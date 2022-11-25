import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:flutter/widgets.dart';

import '../sliver_header/ratio_reposition_resize.dart';

class CustomImage {
  final EdgeInsets padding;
  final Ratio positionRatio;
  final double heightRatio;
  final double? minimum;
  final bool includeTopWithMinium;
  final BuildWidgetAppBar imageBuild;

  CustomImage({
    this.padding = EdgeInsets.zero,
    this.positionRatio = const Ratio(0.0, 0.0),
    this.heightRatio = 1.0,
    this.minimum = 56.0,
    this.includeTopWithMinium = true,
    required this.imageBuild,
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
