// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_sliver_appbar/title_image_appbar/left_bottom_right.dart';
import 'package:flutter/material.dart';
import '../title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'dart:math' as math;

class TitleImageAppBar extends StatefulWidget implements PreferredSizeWidget {
  final LrTbFit lrTbFit;
  final Widget? leftActions;
  final Widget? rightActions;
  final PreferredSizeWidget? bottom;
  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? image;
  final Orientation orientation;
  final double titleHeight;
  final double imageHeight;
  final bool imageIncludeSafeTop;
  final double space;
  final Color? backgroundColor;
  final Color? backgroundColorScrolledUnder;
  final double elevation;
  final double elevationScrolledUnder;
  final LbrFit lbrFit;
  final ScrollNotificationPredicate notificationPredicate;
  final double bottomPositionImage;

  const TitleImageAppBar(
      {Key? key,
      this.lrTbFit = LrTbFit.fit,
      this.leftActions,
      this.rightActions,
      this.bottom,
      this.title,
      this.titleTextStyle,
      this.image,
      this.titleHeight = kToolbarHeight,
      this.imageHeight = 0.0,
      this.orientation = Orientation.portrait,
      this.imageIncludeSafeTop = false,
      this.space = 0.0,
      double? bottomPositionImage,
      this.backgroundColor,
      this.backgroundColorScrolledUnder,
      this.elevation = 0.0,
      this.elevationScrolledUnder = 0.0,
      this.notificationPredicate = defaultScrollNotificationPredicate,
      this.lbrFit = LbrFit.fit})
      : bottomPositionImage = bottomPositionImage ?? titleHeight,
        super(key: key);

  @override
  State<TitleImageAppBar> createState() => _TitleImageAppBarState();

  @override
  Size get preferredSize {
    if (title == null && image == null) {
      if (bottom != null && leftActions == null && rightActions == null) {
        return bottom!.preferredSize;
      } else {
        return Size.fromHeight(titleHeight);
      }
    }

    final bottomHeight = bottom?.preferredSize.height ?? 0.0;

    if (orientation == Orientation.portrait) {
      return Size.fromHeight(math.max(titleHeight, bottomPositionImage) +
          imageHeight +
          bottomHeight);
    } else {
      return Size.fromHeight(math.max(titleHeight, imageHeight) + bottomHeight);
    }
  }
}

class _TitleImageAppBarState extends State<TitleImageAppBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
    }
    _scrollNotificationObserver = ScrollNotificationObserver.of(context);
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.addListener(_handleScrollNotification);
    }
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    debugPrint('notification depth ${notification.depth}');
    if (notification is ScrollUpdateNotification &&
        widget.notificationPredicate(notification)) {
      final bool oldScrolledUnder = _scrolledUnder;
      final ScrollMetrics metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          _scrolledUnder = metrics.extentAfter > 0;
          break;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
          break;
        case AxisDirection.right:
        case AxisDirection.left:
          // Scrolled under is only supported in the vertical axis.
          _scrolledUnder = false;
          break;
      }

      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {
          // React to a change in MaterialState.scrolledUnder
          debugPrint('ScrolledUnder is changed to $_scrolledUnder');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget? w;

    if (widget.title != null || widget.image != null) {
      w = _buildTitleImage(context);
    } else if (widget.bottom != null) {
      w = _buildLeftBottomRight(context);
    } else if (widget.leftActions != null || widget.rightActions != null) {
      w = _buildTitleImage(context);
    } else {
      w = Container();
    }

    return Material(
        elevation:
            _scrolledUnder ? widget.elevationScrolledUnder : widget.elevation,
        color: _scrolledUnder
            ? widget.backgroundColorScrolledUnder
            : widget.backgroundColor,
        child: w);
  }

  Widget _buildTitleImage(BuildContext context) {
    final theme = Theme.of(context);

    Color foregroundColor = theme.colorScheme.onSurface;

    final titleTextStyle = widget.titleTextStyle ??
        theme.appBarTheme.titleTextStyle ??
        theme.textTheme.headline6?.copyWith(color: foregroundColor);

    Widget w;

    if (widget.title != null && widget.image != null) {
      if (widget.orientation == Orientation.portrait) {
        w = Stack(
          children: [
            Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: widget.bottomPositionImage,
                child: Center(child: widget.image!)),
            Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                height: widget.titleHeight,
                child: Center(
                    child: Text(
                  widget.title!,
                  style: titleTextStyle,
                ))),
          ],
        );
      } else {
        w = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.image!,
              SizedBox(
                width: widget.space,
              ),
              SizedBox(
                  height: widget.titleHeight,
                  child: Center(
                      child: Text(
                    widget.title!,
                    style: titleTextStyle,
                  )))
            ]);
      }
    } else if (widget.title != null) {
      w = Center(
          child: (Text(
        widget.title!,
        style: titleTextStyle,
      )));
    } else {
      w = Center(child: widget.image);
    }

    if (widget.bottom != null) {
      w = Column(
        children: [
          Expanded(child: w),
          SizedBox(
              height: widget.bottom!.preferredSize.height, child: widget.bottom)
        ],
      );
    }

    final topPadding = MediaQuery.of(context).padding.top;
    final topCenter =
        widget.imageIncludeSafeTop && widget.image != null ? 0.0 : topPadding;

    return Stack(children: [
      if (widget.leftActions != null)
        Positioned(
            left: 0.0,
            top: topPadding,
            height: widget.titleHeight,
            child: widget.leftActions!),
      if (widget.rightActions != null)
        Positioned(
            right: 0.0,
            top: topPadding,
            height: widget.titleHeight,
            child: widget.rightActions!),
      Positioned(left: 0.0, top: topCenter, right: 0.0, bottom: 0.0, child: w)
    ]);
  }

  Widget _buildLeftBottomRight(BuildContext context) {
    final l = widget.leftActions;
    final b = widget.bottom;
    final r = widget.rightActions;
    final topPadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: LbrLayout(
        lbrFit: widget.lbrFit,
        children: [
          if (l != null) LbrWidget(item: LbrItem.left, child: l),
          if (b != null) LbrWidget(item: LbrItem.bottom, child: b),
          if (r != null) LbrWidget(item: LbrItem.right, child: r)
        ],
      ),
    );
  }
}
