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

import 'dart:math' as math;
import 'package:custom_sliver_appbar/custom_appbar.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/appbar_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:custom_sliver_appbar/sliver_header/persistant_header_animation.dart';
import 'package:custom_sliver_appbar/sliver_header/sliver_header_render.dart';
import '../sliver_header/clip_top.dart';
import '../sliver_header/sliver_header.dart';
import 'left_right_to_bottom_layout.dart';
import 'properties.dart';
import 'title_image.dart';

typedef BuildWidgetAppBar = Widget Function(
    BuildContext context, double height);

class TextImageSliverAppBar extends StatefulWidget {
  final bool pinned;
  final bool floating;
  final CustomTitle? title;
  final CustomImage? image;
  final PreferredSizeWidget? bottom;
  final BuildWidgetAppBar? leftActions;
  final BuildWidgetAppBar? rightActions;
  final double floatingExtent;
  final double minCenter;
  final double maxCenter;
  final double minExtent;
  final Orientation orientation;
  final LrTbFit lrTbFit;
  final double elevation;
  final double scrolledUnderElevation;
  final Color? backgroundColor;
  final Color? scrolledUnderBackgroundColor;
  final Tween<double>? tween;
  final EdgeInsets padding;
  final AppBarBackgroundBuilder? appBarBackgroundBuilder;
  final bool? innerBoxIsScrolled;

  const TextImageSliverAppBar(
      {Key? key,
      this.pinned = true,
      this.floating = true,
      this.title,
      this.image,
      this.minCenter = 56.0,
      this.maxCenter = 150.0,
      this.bottom,
      this.leftActions,
      this.rightActions,
      required this.floatingExtent,
      required this.orientation,
      this.minExtent = 0.0,
      this.lrTbFit = LrTbFit.fit,
      this.backgroundColor,
      this.scrolledUnderBackgroundColor,
      this.elevation = 0.0,
      this.scrolledUnderElevation = 1.0,
      this.tween,
      this.padding = EdgeInsets.zero,
      this.appBarBackgroundBuilder,
      this.innerBoxIsScrolled})
      : super(key: key);

  @override
  State<TextImageSliverAppBar> createState() => _TextImageSliverAppBarState();
}

class _TextImageSliverAppBarState extends State<TextImageSliverAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    debugPrint('devices ${ScrollConfiguration.of(context).dragDevices}');

    debugPrint('platform ${Theme.of(context).platform}');

    final safeTop = MediaQuery.of(context).padding.top;
// MySliverSafeArea(
//       top: false,
//       sliver:
    return CustomAdjustedSliverPersistentHeader(
      pinned: widget.pinned,
      floating: widget.floating,
      innerBoxIsScrolled: widget.innerBoxIsScrolled,
      delegate: widget.lrTbFit == LrTbFit.no
          ? TextImageSliverPersistentHeaderDelegate(
              vsync: this,
              backgroundColor: widget.backgroundColor,
              scrolledUnderBackground: widget.scrolledUnderBackgroundColor,
              elevation: widget.elevation,
              scrolledUnderElevation: widget.scrolledUnderElevation,
              title: widget.title,
              image: widget.image,
              leftActions: widget.leftActions,
              rightActions: widget.rightActions,
              padding: widget.padding,
              appBarBackgroundBuilder: widget.appBarBackgroundBuilder,
              bottom: widget.bottom,
              floatingExtent: widget.floatingExtent,
              orientation: widget.orientation,
              safeTop: safeTop,
              minCenter: widget.minCenter,
              maxCenter: widget.maxCenter,
              minExtent: widget.minExtent,
              tween: widget.tween)
          : LeftRightToBottomTextImageSliverPersistentHeaderDelegate(
              vsync: this,
              backgroundColor: widget.backgroundColor,
              scrolledUnderBackground: widget.scrolledUnderBackgroundColor,
              elevation: widget.elevation,
              scrolledUnderElevation: widget.scrolledUnderElevation,
              title: widget.title,
              image: widget.image,
              leftActions: widget.leftActions,
              rightActions: widget.rightActions,
              padding: widget.padding,
              appBarBackgroundBuilder: widget.appBarBackgroundBuilder,
              bottom: widget.bottom,
              floatingExtent: widget.floatingExtent,
              orientation: widget.orientation,
              safeTop: safeTop,
              minCenter: widget.minCenter,
              maxCenter: widget.maxCenter,
              minExtent: widget.minExtent,
              lrTbFit: widget.lrTbFit,
              tween: widget.tween),
    );
  }
}

class TextImageSliverPersistentHeaderDelegate
    extends CustomAdjustedSliverPersistentHeaderDelegate {
  final TickerProvider? _vsync;

  final CustomTitle? title;
  final CustomImage? image;
  final PreferredSizeWidget? bottom;
  final BuildWidgetAppBar? leftActions;
  final BuildWidgetAppBar? rightActions;
  final double _floatingExtent;
  final Orientation orientation;
  final double safeTop;
  final double maxCenter;
  final double minCenter;
  final double _minExtent;
  final double bottomHeight;
  final Color? backgroundColor;
  final Color? scrolledUnderBackground;
  final double elevation;
  final double scrolledUnderElevation;
  final Tween<double>? tween;
  final EdgeInsets padding;
  final AppBarBackgroundBuilder? appBarBackgroundBuilder;

  TextImageSliverPersistentHeaderDelegate({
    this.title,
    this.image,
    this.bottom,
    this.leftActions,
    this.rightActions,
    required this.padding,
    this.appBarBackgroundBuilder,
    required double floatingExtent,
    required this.orientation,
    required this.safeTop,
    required this.maxCenter,
    required this.minCenter,
    double minExtent = 0.0,
    this.backgroundColor,
    this.scrolledUnderBackground,
    required this.elevation,
    required this.scrolledUnderElevation,
    this.tween,
    TickerProvider? vsync,
    bool correctForNestedSnap = false,
  })  : _vsync = vsync,
        _minExtent = minExtent,
        _floatingExtent = floatingExtent,
        bottomHeight = bottom?.preferredSize.height ?? 0.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (shrinkOffset > maxExtent - minExtent) {
      shrinkOffset = maxExtent - minExtent;
    }
    double height = maxExtent - shrinkOffset - padding.vertical;

    final List<Widget> children = [];

    if (bottom != null && height - kScrollTolerance > safeTop) {
      children.add(AppBarWidget(
          item: AppBarItem.bottom,
          height: bottomHeight,
          child: ClipTop(
              maxHeight: height - safeTop,
              child: Disappear(
                height: bottomHeight,
                disappearHeight: bottomHeight / 2.0,
                shrinkOffsetCorrected: shrinkOffset - maxCenter,
                child: bottom!,
              ))));
    }

    if (leftActions != null &&
        height - kScrollTolerance > safeTop + bottomHeight) {
      final availableHeight =
          math.min(height - safeTop - bottomHeight, minCenter);

      children.add(AppBarWidget(
        item: AppBarItem.left,
        height: minCenter,
        position: safeTop + availableHeight - minCenter,
        child: leftActions!.call(context, availableHeight),
      ));
    }

    if (rightActions != null &&
        height - kScrollTolerance > safeTop + bottomHeight) {
      final availableHeight =
          math.min(height - safeTop - bottomHeight, minCenter);

      children.add(AppBarWidget(
          item: AppBarItem.right,
          height: minCenter,
          position: safeTop + availableHeight - minCenter,
          child: rightActions!.call(context, availableHeight)));
    }

    if (height - kScrollTolerance > safeTop + bottomHeight) {
      if (title != null && image == null) {
        final disappear = _minExtent < minCenter;

        final w = Center(
            child: Text(
          title!.title,
          style: title!.textStyleTween.transform(animationValueFromHeight(
              minCenter, minCenter / 2.0, shrinkOffset,
              reverse: true)),
        ));

        children.add(AppBarWidget(
          item: AppBarItem.center,
          height: minCenter,
          position: bottomHeight,
          child: disappear
              ? Disappear(
                  shrinkOffsetCorrected: shrinkOffset,
                  height: minCenter,
                  disappearHeight: minCenter / 2.0,
                  child: w)
              : w,
        ));
      } else if (title == null && image != null) {
        final disappear = _minExtent < minCenter;

        double h = height -
            bottomHeight -
            (image!.includeTopWithMinium ? 0.0 : safeTop);

        final m = image!.minimum ?? 0.0;

        if (h < m) {
          h = m;
        }

        final w = Center(child: image!.imageBuilder(context));

        children.add(AppBarWidget(
          item: AppBarItem.center,
          height: h,
          position: bottomHeight,
          child: disappear
              ? Disappear(
                  shrinkOffsetCorrected: shrinkOffset - bottomHeight,
                  height: h,
                  disappearHeight: minCenter / 2.0,
                  child: w)
              : w,
        ));
      } else {
        children.add(AppBarWidget(
            item: AppBarItem.center,
            height: maxExtent - bottomHeight - shrinkOffset,
            position: bottomHeight,
            child: orientation == Orientation.portrait
                ? TitleImagePortrait(
                    minExtent: minExtent - bottomHeight,
                    safeTop: safeTop,
                    title: title,
                    image: image,
                    minimum: minCenter,
                    maximum: maxCenter,
                    shrinkOffset: shrinkOffset,
                    tween: tween)
                : TitleImageHorizontal(
                    minExtent: _minExtent - bottomHeight,
                    safeTop: safeTop,
                    title: title,
                    image: image,
                    minimum: minCenter,
                    maximum: maxCenter,
                    shrinkOffset: shrinkOffset,
                    tween: tween,
                  )));
      }
    }

    Widget w = AppBarLayout(
      children: children,
    );

    final builder = appBarBackgroundBuilder;

    if (builder != null) {
      return builder(
          context: context,
          scrolledUnder: overlapsContent,
          padding: padding,
          safeTopPadding: safeTop,
          child: w);
    } else {
      if (padding != EdgeInsets.zero) {
        w = Padding(padding: padding, child: w);
      }

      return Material(
          elevation: overlapsContent ? scrolledUnderElevation : elevation,
          color: overlapsContent ? scrolledUnderBackground : backgroundColor,
          child: w);
    }
  }

  TickerProvider? get vsync => _vsync;

  @override
  double get floatingExtent => safeTop + _floatingExtent;

  @override
  double get maxExtent => safeTop + maxCenter + bottomHeight;

  @override
  double get minExtent => safeTop + _minExtent;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration =>
      FloatingHeaderSnapConfiguration();

  @override
  bool shouldRebuild(TextImageSliverPersistentHeaderDelegate oldDelegate) {
    return this != oldDelegate;
  }
}

class LeftRightToBottomTextImageSliverPersistentHeaderDelegate
    extends CustomAdjustedSliverPersistentHeaderDelegate {
  final TickerProvider? _vsync;

  final CustomTitle? title;
  final CustomImage? image;
  final PreferredSizeWidget? bottom;
  final BuildWidgetAppBar? leftActions;
  final BuildWidgetAppBar? rightActions;
  final double _floatingExtent;
  final Orientation orientation;
  final double safeTop;
  final double maxCenter;
  final double minCenter;
  final double _minExtent;
  final double bottomHeight;
  late PersistantHeaderAnimation _animation;
  late Animation<double> leftRightHeight;
  final Color? backgroundColor;
  final Color? scrolledUnderBackground;
  final double elevation;
  final double scrolledUnderElevation;
  final LrTbFit lrTbFit;
  final Tween<double>? tween;
  final EdgeInsets padding;
  final AppBarBackgroundBuilder? appBarBackgroundBuilder;

  LeftRightToBottomTextImageSliverPersistentHeaderDelegate({
    this.title,
    this.image,
    this.bottom,
    this.leftActions,
    this.rightActions,
    required this.padding,
    this.appBarBackgroundBuilder,
    required double floatingExtent,
    required this.orientation,
    required this.safeTop,
    required this.maxCenter,
    required this.minCenter,
    double minExtent = 0.0,
    this.backgroundColor,
    this.scrolledUnderBackground,
    required this.elevation,
    required this.scrolledUnderElevation,
    required this.lrTbFit,
    this.tween,
    TickerProvider? vsync,
  })  : _vsync = vsync,
        _minExtent = minExtent,
        bottomHeight = bottom?.preferredSize.height ?? 0.0,
        _floatingExtent = floatingExtent {
    _animation = PersistantHeaderAnimation(start: 0.0, delta: maxCenter);
    leftRightHeight = Tween<double>(
            begin: minCenter, end: math.min(minCenter, floatingExtent))
        .animate(_animation);
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (shrinkOffset > maxExtent - minExtent) {
      shrinkOffset = maxExtent - minExtent;
    }
    double height = maxExtent - shrinkOffset - padding.vertical;

    _animation.shrinkOffset = shrinkOffset;
    final List<Widget> children = [];

    if (bottom != null && height - kScrollTolerance > safeTop) {
      children.add(LrTbWidget(
          lrTbPositionFrom: LrTbPositionFrom.bottom,
          item: LrTbItem.bottom,
          height: bottomHeight,
          child: ClipTop(
              maxHeight: height - safeTop,
              child: Disappear(
                height: bottomHeight,
                disappearHeight: bottomHeight / 2.0,
                shrinkOffsetCorrected: shrinkOffset - maxCenter,
                child: bottom!,
              ))));
    }

    if (leftActions != null && height - kScrollTolerance > safeTop) {
      final availableHeight = math.min(height - safeTop, leftRightHeight.value);
      children.add(LrTbWidget(
          position: safeTop,
          lrTbPositionFrom: LrTbPositionFrom.top,
          item: LrTbItem.left,
          height: leftRightHeight.value,
          child: leftActions!.call(context, availableHeight)));
    }

    if (rightActions != null && height - kScrollTolerance > safeTop) {
      final availableHeight = math.min(height - safeTop, leftRightHeight.value);

      children.add(LrTbWidget(
        position: safeTop,
        lrTbPositionFrom: LrTbPositionFrom.top,
        item: LrTbItem.right,
        height: leftRightHeight.value,
        child: rightActions!.call(context, availableHeight),
      ));
    }

    if (height - kScrollTolerance > safeTop + bottomHeight) {
      if (title != null && image == null) {
        final disappear = _minExtent < minCenter;

        final w = Center(
            child: Text(
          title!.title,
          style: title!.textStyleTween.transform(animationValueFromHeight(
              minCenter, minCenter / 2.0, shrinkOffset,
              reverse: true)),
        ));

        children.add(LrTbWidget(
          lrTbPositionFrom: LrTbPositionFrom.bottom,
          item: LrTbItem.center,
          position: bottomHeight,
          height: minCenter,
          child: disappear
              ? Disappear(
                  shrinkOffsetCorrected: shrinkOffset,
                  height: minCenter,
                  disappearHeight: minCenter / 2.0,
                  child: w)
              : w,
        ));
      } else if (title == null && image != null) {
        final disappear = _minExtent <= minCenter;

        double h = height -
            bottomHeight -
            (image!.includeTopWithMinium ? 0.0 : safeTop);

        final m = image!.minimum ?? 0.0;

        if (h < m) {
          h = m;
        }

        final w = Center(
          child: image!.imageBuilder(context),
        );

        children.add(LrTbWidget(
          item: LrTbItem.center,
          height: h,
          position: bottomHeight,
          lrTbPositionFrom: LrTbPositionFrom.bottom,
          child: disappear
              ? Disappear(
                  shrinkOffsetCorrected: shrinkOffset - bottomHeight,
                  height: maxCenter,
                  disappearHeight: minCenter / 2.0,
                  child: w)
              : w,
        ));
      } else {
        children.add(LrTbWidget(
            lrTbPositionFrom: LrTbPositionFrom.bottom,
            item: LrTbItem.center,
            height: maxExtent - bottomHeight - shrinkOffset,
            position: bottomHeight,
            child: orientation == Orientation.portrait
                ? TitleImagePortrait(
                    safeTop: safeTop,
                    minExtent: _minExtent - bottomHeight,
                    title: title,
                    image: image,
                    minimum: minCenter,
                    maximum: maxCenter,
                    shrinkOffset: shrinkOffset,
                    tween: tween,
                  )
                : TitleImageHorizontal(
                    minExtent: _minExtent - bottomHeight,
                    safeTop: safeTop,
                    title: title,
                    image: image,
                    minimum: minCenter,
                    maximum: maxCenter,
                    shrinkOffset: shrinkOffset,
                    tween: tween,
                  )));
      }
    }

    Widget w = LrTbLayout(
      lrTbFit: lrTbFit,
      aligmentRatio: _animation.value,
      children: children,
    );

    final builder = appBarBackgroundBuilder;

    if (builder != null) {
      return builder(
          context: context,
          padding: padding,
          scrolledUnder: overlapsContent,
          safeTopPadding: safeTop,
          child: w);
    } else {
      if (padding != EdgeInsets.zero) {
        w = Padding(
          padding: padding,
          child: w,
        );
      }

      return Material(
          elevation: overlapsContent ? scrolledUnderElevation : elevation,
          color: overlapsContent ? scrolledUnderBackground : backgroundColor,
          child: w);
    }
  }

  TickerProvider? get vsync => _vsync;

  @override
  double get floatingExtent => safeTop + _floatingExtent;

  @override
  double get maxExtent => safeTop + maxCenter + bottomHeight;

  @override
  double get minExtent => safeTop + _minExtent;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration =>
      FloatingHeaderSnapConfiguration();

  @override
  bool shouldRebuild(
      LeftRightToBottomTextImageSliverPersistentHeaderDelegate oldDelegate) {
    return this != oldDelegate;
  }
}

class Disappear extends StatelessWidget {
  final Widget child;
  final double height;
  final double disappearHeight;
  final double shrinkOffsetCorrected;

  const Disappear(
      {super.key,
      required this.child,
      required this.height,
      required this.disappearHeight,
      required this.shrinkOffsetCorrected});

  @override
  Widget build(BuildContext context) {
    final opacity = clampDouble(
        (height - disappearHeight - shrinkOffsetCorrected) / disappearHeight,
        0.0,
        1.0);
    // debugPrint('opacity $opacity $height $disappearHeight');
    return Opacity(
      opacity: opacity,
      child: child,
    );
  }
}

double animationValueFromHeight(
    double height, double disappearHeight, double shrinkOffsetCorrected,
    {bool reverse = false}) {
  double v =
      clampDouble((height - shrinkOffsetCorrected) / disappearHeight, 0.0, 1.0);

  return reverse ? 1.0 - v : v;
}
