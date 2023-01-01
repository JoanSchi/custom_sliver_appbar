import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../sliver_header/persistant_header_animation.dart';
import 'properties.dart';
import 'title_image_layout.dart';

class TitleImagePortrait extends StatefulWidget {
  final double shrinkOffset;
  final double minimum;
  final double maximum;
  final CustomTitle? title;
  final CustomImage? image;
  final double safeTop;
  final Tween<double>? tween;
  final double minExtent;

  const TitleImagePortrait({
    Key? key,
    required this.shrinkOffset,
    required this.minimum,
    required this.maximum,
    required this.minExtent,
    this.title,
    this.image,
    required this.safeTop,
    this.tween,
  }) : super(key: key);

  @override
  State<TitleImagePortrait> createState() => _TitleImagePortraitState();
}

class _TitleImagePortraitState extends State<TitleImagePortrait> {
  List<PersistantHeaderAnimation> persitantAnimation = [];
  Map<String, Animation> animations = {};

  double minimum = 0.0;
  double maximum = 0.0;

  CustomTitle? title;
  CustomImage? image;

  @override
  void didChangeDependencies() {
    setValues();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TitleImagePortrait oldWidget) {
    if (minimum != widget.minimum ||
        maximum != widget.maximum ||
        widget.title != title ||
        widget.image != image) {
      setValues();
    }

    if (oldWidget.shrinkOffset != widget.shrinkOffset) {
      for (PersistantHeaderAnimation a in persitantAnimation) {
        a.shrinkOffset = widget.shrinkOffset;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  setValues() {
    minimum = widget.minimum;
    maximum = widget.maximum;
    title = widget.title;
    image = widget.image;
    persitantAnimation.clear();
    animations.clear();

    final animation = PersistantHeaderAnimation(
        start: 0.0,
        delta: maximum - minimum,
        shrinkOffset: widget.shrinkOffset);

    persitantAnimation.add(animation);

    final customImage = widget.image;

    if (customImage != null) {
      final imageOpaquaAnimation = PersistantHeaderAnimation(
          start: maximum - minimum * 1.5,
          delta: minimum * 0.5,
          shrinkOffset: widget.shrinkOffset);

      persitantAnimation.add(imageOpaquaAnimation);
      animations['imageOpacity'] =
          Tween(begin: 1.0, end: 0.0).animate(imageOpaquaAnimation);

      final t = widget.tween;
      if (t != null) {
        animations['imagePosition'] = t.animate(animation);
      }
    }

    final customTitle = widget.title;

    if (customTitle != null) {
      animations['textStyle'] = customTitle.textStyleTween.animate(animation);
      animations['titleHeight'] = customTitle.height.animate(animation);

      final textOpaquaAnimation = PersistantHeaderAnimation(
          start: maximum - minimum / 2.0 - widget.safeTop,
          delta: minimum / 2.0,
          shrinkOffset: widget.shrinkOffset);

      animations['titleOpacity'] =
          Tween(begin: 1.0, end: 0.0).animate(textOpaquaAnimation);

      persitantAnimation.add(textOpaquaAnimation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customImage = image;
    final customTitle = title;

    final titleHeight = animations['titleHeight']?.value ?? 0.0;
    double imageHeight = 0.0;
    double imagePosition = 0.0;

    final imageOpacity = animations['imageOpacity']?.value ?? 1.0;
    Widget? imageWidget;

    if (customImage != null && imageOpacity > 0.0) {
      final top = customImage.includeTopWithMinium ? widget.safeTop : 0.0;
      imagePosition = animations['imagePosition']?.value ?? titleHeight;

      imageHeight = widget.maximum + top - imagePosition;

      imageHeight = imageHeight - widget.shrinkOffset;

      double? m = customImage.minimum;
      if (m != null) {
        if (imageHeight < m + top) {
          imageHeight = m + top;
        }
      }

      imageWidget = Opacity(
          opacity: imageOpacity, child: customImage.imageBuilder(context));
    }

    final titleOpacity = animations['titleOpacity']?.value ?? 1.0;
    Widget? titleWidget;
    if (customTitle != null && titleOpacity > 0) {
      titleWidget = Center(
        child: Text(
          customTitle.title,
          style: animations['textStyle']?.value,
        ),
      );

      if (widget.minExtent < minimum) {
        titleWidget = Opacity(opacity: titleOpacity, child: titleWidget);
      }
    }

    return TitleImageLayout(
      children: [
        if (titleWidget != null)
          TitleImageWidget(height: titleHeight, child: titleWidget),
        if (imageWidget != null)
          TitleImageWidget(
              item: TitleImageItem.image,
              height: imageHeight,
              position: imagePosition,
              child: imageWidget),
      ],
    );
  }
}

class TitleImageHorizontal extends StatefulWidget {
  final double shrinkOffset;

  final double minimum;
  final double maximum;
  final double safeTop;

  final CustomTitle? title;
  final CustomImage? image;
  final Tween<double>? tween;
  final double minExtent;

  const TitleImageHorizontal({
    Key? key,
    required this.shrinkOffset,
    required this.minimum,
    required this.maximum,
    required this.safeTop,
    this.title,
    this.image,
    this.tween,
    required this.minExtent,
  }) : super(key: key);

  @override
  State<TitleImageHorizontal> createState() => _TitleImageHorizontalState();
}

class _TitleImageHorizontalState extends State<TitleImageHorizontal> {
  List<PersistantHeaderAnimation> persitantAnimation = [];
  Map<String, Animation> animations = {};
  double minimum = 0.0;
  double maximum = 0.0;
  double top = 0.0;

  CustomTitle? title;
  CustomImage? image;

  @override
  void didChangeDependencies() {
    setValues();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(TitleImageHorizontal oldWidget) {
    if (minimum != widget.minimum ||
        maximum != widget.maximum ||
        widget.title != title ||
        widget.image != image ||
        widget.safeTop != oldWidget.safeTop) {
      setValues();
    }

    for (PersistantHeaderAnimation element in persitantAnimation) {
      element.shrinkOffset = widget.shrinkOffset;
    }
    super.didUpdateWidget(oldWidget);
  }

  setValues() {
    minimum = widget.minimum;
    maximum = widget.maximum;
    title = widget.title;
    image = widget.image;
    top = 0.0;

    final animation = PersistantHeaderAnimation(start: 0.0, delta: maximum)
      ..shrinkOffset = widget.shrinkOffset;

    persitantAnimation.add(animation);

    final customImage = widget.image;

    if (customImage != null) {
      top = customImage.includeTopWithMinium ? widget.safeTop : 0.0;
      final imageOpaquaAnimation = PersistantHeaderAnimation(
        start: maximum - minimum / 2.0 - widget.safeTop,
        delta: minimum / 2.0,
      )..shrinkOffset = widget.shrinkOffset;

      animations['opacity'] =
          Tween(begin: 1.0, end: 0.0).animate(imageOpaquaAnimation);

      persitantAnimation.add(imageOpaquaAnimation);
    }

    final customTitle = widget.title;

    if (customTitle != null) {
      animations['textStyle'] = customTitle.textStyleTween.animate(animation);
      animations['titleHeight'] = customTitle.height.animate(animation);

      final textOpaquaAnimation = PersistantHeaderAnimation(
        start: maximum - minimum / 2.0 - widget.safeTop,
        delta: minimum / 2.0,
      )..shrinkOffset = widget.shrinkOffset;

      animations['titleOpacity'] =
          Tween(begin: 1.0, end: 0.0).animate(textOpaquaAnimation);

      persitantAnimation.add(textOpaquaAnimation);

      if (top != 0.0) {
        final safeAnimation = PersistantHeaderAnimation(
          start: maximum - minimum - top,
          delta: widget.safeTop,
        )..shrinkOffset = widget.shrinkOffset;

        animations['safeTop'] =
            Tween(begin: widget.safeTop, end: 0.0).animate(safeAnimation);

        persitantAnimation.add(safeAnimation);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customTitle = title;
    final customImage = image;

    Widget? titleWidget;
    double titleOpacity = animations['titleOpacity']?.value ?? 1.0;
    if (customTitle != null && titleOpacity > 0.0) {
      titleWidget = Text(
        customTitle.title,
        style: animations['textStyle']?.value,
      );

      if (widget.minExtent < minimum) {
        titleWidget = Opacity(opacity: titleOpacity, child: titleWidget);
      }
    }

    double imageHeight = 0.0;

    Widget? imageWidget;
    double imageOpacity = animations['opacity']?.value ?? 1.0;
    double space = 0.0;

    if (customImage != null && imageOpacity > 0.0) {
      imageHeight = widget.maximum + top;
      imageHeight = imageHeight - widget.shrinkOffset;
      double m = customImage.minimum ?? 0.0;

      if (m != 0.0) {
        if (imageHeight < m + top) {
          imageHeight = m + top;
        }
      }

      final t = widget.tween;
      space = (t != null)
          ? t.transform(
              clampDouble((imageHeight - m) / (widget.maximum - m), 0.0, 1.0))
          : 12.0;

      imageWidget = customImage.imageBuilder(context);

      if (widget.minExtent < minimum) {
        imageWidget = Opacity(opacity: imageOpacity, child: imageWidget);
      }
    }

    double heightText =
        maximum + (animations['safeTop']?.value ?? 0.0) - widget.shrinkOffset;

    if (heightText < minimum) {
      heightText = minimum;
    }

    return TitleImageLayout(
      space: space,
      isPortrait: false,
      children: [
        if (imageWidget != null)
          TitleImageWidget(
              item: TitleImageItem.image,
              height: imageHeight,
              child: imageWidget),
        if (titleWidget != null)
          TitleImageWidget(
              item: TitleImageItem.title,
              height: heightText,
              child: titleWidget),
      ],
    );
  }
}
