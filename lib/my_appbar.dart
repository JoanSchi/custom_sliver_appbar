// import 'dart:math' as math;

// import 'package:custom_sliver_appbar/sliver_header/SliverHeader.dart';
// import 'package:flutter/material.dart';

// import 'sliver_header/SliverHeaderRender.dart';

// class MySliverAppBar extends StatefulWidget {
//   final bool pinned;
//   final bool floating;
//   final String? title;
//   final String? imageName;
//   final PreferredSizeWidget? bottom;
//   final Widget? leftActions;
//   final Widget? rightActions;
//   final bool hasNavigationBar;
//   final bool handleSliverOverlap;

//   MySliverAppBar({
//     Key? key,
//     this.pinned = false,
//     this.floating = false,
//     this.title,
//     this.imageName,
//     this.bottom,
//     this.leftActions,
//     this.rightActions,
//     this.hasNavigationBar = true,
//     this.handleSliverOverlap = false,
//   }) : super(key: key);

//   @override
//   State<MySliverAppBar> createState() => _MySliverAppBarState();
// }

// class _MySliverAppBarState extends State<MySliverAppBar>
//     with SingleTickerProviderStateMixin {
//   ScrollNotificationObserverState? _scrollNotificationObserver;
//   bool _scrolledUnder = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_scrollNotificationObserver != null) {
//       _scrollNotificationObserver!.removeListener(_handleScrollNotification);
//       _scrollNotificationObserver = ScrollNotificationObserver.of(context);
//     }
//     if (_scrollNotificationObserver != null) {
//       _scrollNotificationObserver!.addListener(_handleScrollNotification);
//     }
//   }

//   @override
//   void dispose() {
//     if (_scrollNotificationObserver != null) {
//       _scrollNotificationObserver!.removeListener(_handleScrollNotification);
//       _scrollNotificationObserver = null;
//     }
//     super.dispose();
//   }

//   void _handleScrollNotification(ScrollNotification notification) {
//     if (notification is ScrollUpdateNotification) {
//       final bool oldScrolledUnder = _scrolledUnder;
//       _scrolledUnder = notification.depth == 0 &&
//           notification.metrics.extentBefore > 0 &&
//           notification.metrics.axis == Axis.vertical;
//       if (_scrolledUnder != oldScrolledUnder) {
//         setState(() {
//           // React to a change in MaterialState.scrolledUnder
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     DeviceScreen3 deviceScreen = DeviceScreen3.of(context);
//     double topPadding = 0.0;
//     double leftInsets = 0.0;
//     bool pinned = true;
//     bool floating = false;

//     switch (deviceScreen.formFactorType) {
//       case FormFactorType.SmallPhone:
//       case FormFactorType.LargePhone:
//         topPadding = deviceScreen.topPadding;

//         if (deviceScreen.isPortrait) {
//           leftInsets = 0.0;
//         } else {
//           if (widget.hasNavigationBar) {
//             leftInsets = kLeftMobileNavigationBarSize;
//           }

//           if (widget.bottom == null) {
//             floating = true;
//           }
//         }
//         break;

//       case FormFactorType.Tablet:
//       case FormFactorType.Monitor:
//         topPadding = deviceScreen.topPadding;
//         break;
//     }

//     final sliver = SliverSafeArea(
//       top: false,
//       sliver: CustomAdjustedSliverPersistentHeader(
//         pinned: pinned,
//         floating: floating,
//         delegate: MobileSliverPersistentHeaderDelegate(
//             vsync: this,
//             screen: deviceScreen,
//             leftInsets: leftInsets,
//             leftPadding: 8.0,
//             rightPadding: 8.0,
//             title: widget.title,
//             imageName: widget.imageName,
//             topPadding: topPadding,
//             bottom: widget.bottom,
//             leftActions: widget.leftActions,
//             rightActions: widget.rightActions),
//       ),
//     );

//     return widget.handleSliverOverlap
//         ? SliverOverlapAbsorber(
//             handle: NestedScrollView3M.sliverOverlapAbsorberHandleFor(context),
//             sliver: sliver)
//         : sliver;
//   }
// }

// class MobileSliverPersistentHeaderDelegate
//     extends CustomAdjustedSliverPersistentHeaderDelegate {
//   double leftInsets;
//   double rightInsets;
//   double leftPadding;
//   double topPadding;
//   double rightPadding;
//   late PersistantHeaderAnimation _animation;
//   PersistantHeaderAnimation? _headerAnimationText;
//   late Animation<Color?> colorAnimation;
//   Animation<double>? opacityAnimation;
//   Animation<double>? opacityAnimationText;
//   Animation<double>? scaleTextAnimation;
//   late Animation<BorderRadius?> borderAnimation;
//   final PreferredSizeWidget? bottom;
//   double _maxExtent = 0.0;
//   double _minExtent = 0.0;
//   double _floatingExtent = 0.0;
//   final String? title;
//   final IconData? icon;
//   final String? imageName;
//   Orientation orientation = Orientation.portrait;
//   double innerSize = 0.0;
//   double textTopPadding = 12.0;
//   double textBottomPadding = 12.0;
//   double imagePaddingLeft = 12.0;
//   double imagePaddingTop = 12.0;
//   double imagePaddingRight = 12.0;
//   double imagePaddingBottom = 12.0;
//   Widget? leftActions;
//   Widget? rightActions;
//   bool useBorder = false;
//   TickerProvider? _vsync;
//   double minToolbarBottom = 0.0;
//   double maxToolbarBottom = 0.0;
//   bool pinnedHeader = false;

//   MobileSliverPersistentHeaderDelegate({
//     this.leftInsets = 0.0,
//     this.rightInsets = 0.0,
//     this.leftPadding = 0.0,
//     this.topPadding = 0.0,
//     this.rightPadding = 0.0,
//     this.icon,
//     this.imageName,
//     this.title,
//     this.bottom,
//     this.leftActions,
//     this.rightActions,
//     required this.screen,
//     TickerProvider? vsync,
//   }) : _vsync = vsync {
//     double bottomHeight = bottom?.preferredSize.height ?? 0.0;

//     if (bottomHeight > 0.0 && bottomHeight < kToolbarHeight) {
//       bottomHeight = kToolbarHeight;
//     }

//     switch (screen.formFactorType) {
//       case FormFactorType.SmallPhone:
//         orientation = screen.orientation;
//         useBorder = true;
//         pinnedHeader = false;

//         final toolBarHeight =
//             (screen.orientation == Orientation.portrait ? kToolbarHeight : 0.0);

//         _minExtent = topPadding + bottomHeight;

//         if (orientation == Orientation.portrait) {
//           innerSize = 80.0;
//           textTopPadding = 0.0;
//         } else {
//           innerSize = 80.0;
//         }

//         _maxExtent = topPadding + innerSize + toolBarHeight + bottomHeight;

//         _headerAnimationText = PersistantHeaderAnimation(
//             minExtent: _minExtent,
//             maxExtent: _maxExtent,
//             endAnimation: screen.orientation == Orientation.portrait
//                 ? topPadding + kToolbarHeight + bottomHeight
//                 : _maxExtent);

//         opacityAnimationText =
//             Tween(begin: 1.0, end: 0.0).animate(_headerAnimationText!);

//         break;
//       case FormFactorType.LargePhone:
//         orientation = screen.orientation;
//         double toolBarHeight;
//         useBorder = true;
//         pinnedHeader = false;

//         if (orientation == Orientation.portrait) {
//           toolBarHeight = kToolbarHeight;
//           innerSize = 150.0;
//           imagePaddingTop = 24.0;
//           imagePaddingBottom = 8.0;
//           textTopPadding = 12.0;
//           textBottomPadding = 12.0;
//           _minExtent = topPadding + toolBarHeight + bottomHeight;
//           _maxExtent = topPadding + innerSize + toolBarHeight + bottomHeight;
//           _floatingExtent = _maxExtent;
//         } else {
//           toolBarHeight = (leftActions != null || rightActions != null)
//               ? kToolbarHeight
//               : 0.0;
//           innerSize = 100.0;
//           textTopPadding = 12.0;
//           textBottomPadding = 12.0;
//           _minExtent = topPadding + bottomHeight;
//           minToolbarBottom = math.max(toolBarHeight, bottomHeight);
//           maxToolbarBottom = toolBarHeight + bottomHeight;
//           _maxExtent = topPadding + innerSize + bottomHeight;
//           _floatingExtent = topPadding + minToolbarBottom;
//         }

//         if (orientation == Orientation.landscape) {
//           _headerAnimationText = PersistantHeaderAnimation(
//               minExtent: _minExtent, maxExtent: _maxExtent);

//           opacityAnimationText =
//               Tween(begin: 1.0, end: 0.0).animate(_headerAnimationText!);
//         }
//         break;
//       case FormFactorType.Tablet:
//       case FormFactorType.Monitor:
//         orientation = screen.size.height <= 900.0
//             ? Orientation.landscape
//             : Orientation.portrait;

//         useBorder = false;
//         pinnedHeader = true;

//         if (orientation == Orientation.portrait) {
//           innerSize = 150.0;
//           imagePaddingTop = 24.0;
//           imagePaddingBottom = 8.0;
//           textTopPadding = 12.0;
//           textBottomPadding = 12.0;
//           _minExtent = topPadding + kToolbarHeight + bottomHeight;
//           _maxExtent = topPadding + kToolbarHeight + innerSize + bottomHeight;
//         } else {
//           innerSize = 150.0;
//           imagePaddingLeft = 16.0;
//           imagePaddingTop = 16.0;
//           imagePaddingRight = 16.0;
//           imagePaddingBottom = 16.0;
//           textTopPadding = 12.0;
//           textBottomPadding = 12.0;
//           _minExtent = topPadding + kToolbarHeight + bottomHeight;
//           _maxExtent = topPadding + innerSize + bottomHeight;
//         }
//         break;
//     }

//     _animation =
//         PersistantHeaderAnimation(minExtent: _minExtent, maxExtent: _maxExtent);
//     opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(_animation);
//     scaleTextAnimation = Tween(begin: 1.3, end: 1.0).animate(_animation);
//   }
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     final theme = Theme.of(context);

//     AppBarOverViewPageStyle? style = theme.extension<AppBarOverViewPageStyle>();
//     Color? backgroundColor =
//         shrinkOffset > 0.0 ? style?.background : style?.background;

//     // final Color foregroundColor = theme.appBarTheme.foregroundColor ??
//     //     (theme.colorScheme.brightness == Brightness.dark
//     //         ? theme.colorScheme.onSurface
//     //         : theme.colorScheme.onPrimary);

//     _animation.shrinkOffset = shrinkOffset;
//     _headerAnimationText?.shrinkOffset = shrinkOffset;

//     if (orientation == Orientation.portrait) {
//       final list = <Widget>[];

//       if (title != null && (opacityAnimationText?.value ?? 1.0) > 0.0) {
//         Widget text = Text(title!,
//             style: theme.textTheme.bodyText2
//                 ?.copyWith(color: style?.color, fontSize: 24.0));

//         if (opacityAnimationText != null) {
//           text = Opacity(opacity: opacityAnimationText!.value, child: text);
//         }

//         if (scaleTextAnimation != null) {
//           text =
//               ScaleResizedTransition(scale: scaleTextAnimation!, child: text);
//         }

//         text = Container(
//           padding:
//               EdgeInsets.only(top: textTopPadding, bottom: textBottomPadding),
//           alignment: Alignment.center,
//           child: text,
//         );

//         list.add(LayoutId(
//           id: 'text',
//           child: text,
//         ));
//       }

//       if (icon != null && (opacityAnimation?.value ?? 1.0) > 0.0) {
//         Widget widget = Icon(
//           icon,
//           size: innerSize,
//           color: Colors.white,
//         );

//         list.add(LayoutId(
//           id: 'icon',
//           child: opacityAnimation != null
//               ? Opacity(opacity: opacityAnimation!.value, child: widget)
//               : widget,
//         ));
//       }

//       if (imageName != null && (opacityAnimation?.value ?? 1.0) > 0.0) {
//         Widget widget = Container(
//             height: innerSize,
//             padding: EdgeInsets.only(
//                 left: imagePaddingLeft,
//                 top: imagePaddingTop,
//                 right: imagePaddingRight,
//                 bottom: imagePaddingBottom),
//             child: Image.asset(
//               imageName!,
//               height: innerSize,
//               color: style?.color,
//             ));

//         list.add(LayoutId(
//           id: 'icon',
//           child: opacityAnimation != null
//               ? Opacity(opacity: opacityAnimation!.value, child: widget)
//               : widget,
//         ));
//       }

//       if (bottom != null) {
//         list.add(LayoutId(
//             id: 'bottom',
//             child: ConstrainedBox(
//                 constraints:
//                     BoxConstraints(maxHeight: bottom!.preferredSize.height),
//                 child: bottom)));
//       }

//       if (leftActions != null) {
//         list.add(LayoutId(id: 'leftActions', child: leftActions!));
//       }

//       if (rightActions != null) {
//         list.add(LayoutId(id: 'rightActions', child: leftActions!));
//       }

//       final components = CustomMultiChildLayout(
//         delegate: VerticalHeader(
//           leftPadding: leftInsets + leftPadding,
//           rightPadding: rightInsets + rightPadding,
//           topPadding: topPadding,
//           minExtent: minExtent,
//           maxExtent: maxExtent,
//         ),
//         children: list,
//       );

//       return useBorder
//           ? Material(
//               shape: ShapeBorderHeader(
//                   topPadding: topPadding,
//                   heightToFlat: _minExtent,
//                   leftInsets: leftInsets,
//                   rightInsets: rightInsets),
//               color: backgroundColor,
//               // elevation: elevationAnimation.value,
//               child: components,
//             )
//           : components;
//     } else {
//       final list = <Widget>[];

//       if (title != null && (opacityAnimationText?.value ?? 1.0) > 0.0) {
//         Widget text = Text(title!,
//             style: theme.textTheme.bodyText2
//                 ?.copyWith(color: style?.color, fontSize: 24.0));

//         if (opacityAnimationText != null)
//           text = Opacity(opacity: opacityAnimationText!.value, child: text);

//         if (scaleTextAnimation != null)
//           text =
//               ScaleResizedTransition(scale: scaleTextAnimation!, child: text);

//         text = Container(
//           padding:
//               EdgeInsets.only(top: textTopPadding, bottom: textBottomPadding),
//           alignment: Alignment.center,
//           child: text,
//         );

//         list.add(LayoutId(
//           id: 'text',
//           child: text,
//         ));
//       }

//       if (icon != null && (opacityAnimation?.value ?? 1.0) > 0.0) {
//         Widget widget = Icon(
//           icon,
//           size: innerSize,
//           color: Colors.white,
//         );

//         list.add(LayoutId(
//           id: 'icon',
//           child: opacityAnimation != null
//               ? Opacity(opacity: opacityAnimation!.value, child: widget)
//               : widget,
//         ));
//       }

//       if (imageName != null && (opacityAnimation?.value ?? 1.0) > 0.0) {
//         Widget widget = Container(
//             height: innerSize,
//             padding: EdgeInsets.only(
//                 left: imagePaddingLeft,
//                 top: imagePaddingTop,
//                 right: imagePaddingRight,
//                 bottom: imagePaddingBottom),
//             child: Image.asset(
//               imageName!,
//               height: innerSize,
//               color: style?.color,
//             ));

//         list.add(LayoutId(
//           id: 'icon',
//           child: opacityAnimation != null
//               ? Opacity(opacity: opacityAnimation!.value, child: widget)
//               : widget,
//         ));
//       }

//       if (bottom != null) {
//         list.add(LayoutId(
//             id: 'bottom',
//             child: ConstrainedBox(
//                 constraints:
//                     BoxConstraints(maxHeight: bottom!.preferredSize.height),
//                 child: bottom)));
//       }

//       if (leftActions != null) {
//         Widget w = pinnedHeader
//             ? leftActions!
//             : AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: (maxExtent - topPadding - shrinkOffset < kToolbarHeight)
//                     ? const SizedBox(
//                         width: 0.0,
//                         height: 0.0,
//                       )
//                     : leftActions);
//         list.add(LayoutId(id: 'leftActions', child: w));
//       }

//       if (rightActions != null) {
//         Widget w = pinnedHeader
//             ? rightActions!
//             : AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: (maxExtent - topPadding - shrinkOffset < kToolbarHeight)
//                     ? const SizedBox(
//                         width: 0.0,
//                         height: 0.0,
//                       )
//                     : rightActions);
//         list.add(LayoutId(id: 'rightActions', child: w));
//       }

//       final components = CustomMultiChildLayout(
//         delegate: HorizontalHeader(
//             shrinkOffset: shrinkOffset,
//             leftPadding: leftInsets + leftPadding,
//             rightPadding: rightInsets + rightPadding,
//             topPadding: topPadding,
//             minExtent: _minExtent,
//             maxExtent: _maxExtent,
//             minToolbarBottom: minToolbarBottom,
//             maxToolbarBottom: maxToolbarBottom,
//             pinnedHeader: pinnedHeader),
//         children: list,
//       );

//       return useBorder
//           ? Material(
//               shape: ShapeBorderHeader(
//                   topPadding: topPadding,
//                   heightToFlat: minExtent,
//                   leftInsets: leftInsets,
//                   rightInsets: rightInsets),
//               color: backgroundColor,
//               // elevation: elevationAnimation.value,
//               child: components,
//             )
//           : components;
//     }
//   }

//   TickerProvider? get vsync => _vsync;

//   @override
//   double get maxExtent => _maxExtent;

//   @override
//   double get minExtent => _minExtent;

//   @override
//   double get floatingExtent => _floatingExtent;

//   @override
//   FloatingHeaderSnapConfiguration get snapConfiguration =>
//       FloatingHeaderSnapConfiguration();

//   @override
//   bool shouldRebuild(MobileSliverPersistentHeaderDelegate oldDelegate) {
//     return this != oldDelegate;
//   }
// }

// class PersistantHeaderAnimation extends Animation<double>
//     with AnimationLocalListenersMixin, AnimationLocalStatusListenersMixin {
//   double _shrinkOffset = 0.0;
//   double minExtent;
//   double maxExtent;
//   double _startAnimation = 0.0;
//   double _endAnimation = 0.0;

//   PersistantHeaderAnimation({
//     required this.minExtent,
//     required this.maxExtent,
//     double? startAnimation,
//     double? endAnimation,
//   })  : _startAnimation = startAnimation ?? minExtent,
//         _endAnimation = endAnimation ?? maxExtent,
//         assert(
//             startAnimation == null ||
//                 minExtent <= startAnimation ||
//                 startAnimation <= maxExtent,
//             'startAnimation: $startAnimation is not between minExtent: $minExtent and maxExtent: $maxExtent'),
//         assert(
//             endAnimation == null ||
//                 minExtent <= endAnimation ||
//                 endAnimation <= maxExtent,
//             'endAnimation: $endAnimation is not between minExtent: $minExtent and maxExtent: $maxExtent');

//   set shrinkOffset(value) {
//     if (value != _shrinkOffset) {
//       _shrinkOffset = value;
//       notifyListeners();
//     }
//   }

//   void addListener(VoidCallback listener) {
//     super.addListener(listener);
//   }

//   void removeListener(VoidCallback listener) {
//     super.removeListener(listener);
//   }

//   @override
//   AnimationStatus get status => throw UnimplementedError();

//   @override
//   double get value {
//     if (maxExtent - _shrinkOffset > _endAnimation) {
//       return 0.0;
//     } else if (maxExtent - _shrinkOffset < _startAnimation) {
//       return 1.0;
//     }

//     double v = (_shrinkOffset - (maxExtent - _endAnimation)) /
//         (_endAnimation - _startAnimation);

//     return (v > 1.0) ? 1.0 : v;
//   }

//   @override
//   void didRegisterListener() {}

//   @override
//   void didUnregisterListener() {}
// }

// class HorizontalHeader extends MultiChildLayoutDelegate {
//   final double shrinkOffset;
//   final double topPadding;
//   final double leftPadding;
//   final double rightPadding;
//   final double minExtent;
//   final double maxExtent;
//   final double minToolbarBottom;
//   final double maxToolbarBottom;
//   final double floatingExtent;
//   final bool pinnedHeader;

//   HorizontalHeader(
//       {this.shrinkOffset = 0.0,
//       this.leftPadding = 0.0,
//       this.topPadding = 0.0,
//       this.rightPadding = 0.0,
//       this.minExtent = 0.0,
//       this.maxExtent = 0.0,
//       this.minToolbarBottom = 0.0,
//       this.maxToolbarBottom = 0.0,
//       this.floatingExtent = 0.0,
//       this.pinnedHeader: false});

//   @override
//   void performLayout(Size size) {
//     Size bottomSize = Size.zero;
//     Size textSize = Size.zero;
//     Size iconSize = Size.zero;
//     Size leftActionSize = Size.zero;
//     Size rightActionSize = Size.zero;

//     final availibleConstraint = BoxConstraints(
//         maxWidth: size.width - leftPadding - rightPadding,
//         maxHeight: size.height - topPadding);

//     if (hasChild('leftActions')) {
//       leftActionSize = layoutChild('leftActions', BoxConstraints());
//       double actionTop = math.min(
//           topPadding + (kToolbarHeight - leftActionSize.height) / 2.0,
//           size.height - leftActionSize.height);

//       positionChild('leftActions', Offset(leftPadding, actionTop));
//     }

//     if (hasChild('rightActions')) {
//       rightActionSize = layoutChild('rightActions', BoxConstraints());
//       double actionTop = math.min(
//           topPadding + (kToolbarHeight - rightActionSize.height) / 2.0,
//           size.height - rightActionSize.height);
//       positionChild('rightActions',
//           Offset(size.width - rightPadding - rightActionSize.width, actionTop));
//     }

//     if (hasChild('bottom')) {
//       double intent = 0.0;
//       BoxConstraints bottomContraints;

//       if (minToolbarBottom < maxToolbarBottom) {
//         double d = maxExtent - shrinkOffset - topPadding;

//         if (d < maxToolbarBottom) {
//           intent = math.max(leftActionSize.width, rightActionSize.width) /
//               (maxToolbarBottom - minToolbarBottom) *
//               (maxToolbarBottom - d);
//         }

//         bottomContraints = BoxConstraints(
//             maxWidth: size.width - leftPadding - rightPadding - 2 * intent,
//             maxHeight: size.height - topPadding);
//       } else {
//         bottomContraints = availibleConstraint;
//       }

//       bottomSize = layoutChild('bottom', bottomContraints);
//       positionChild(
//           'bottom',
//           Offset(
//               leftPadding +
//                   intent +
//                   (size.width -
//                           bottomSize.width -
//                           leftPadding -
//                           rightPadding -
//                           2.0 * intent) /
//                       2.0,
//               size.height - bottomSize.height));
//     }

//     if (hasChild('text')) {
//       textSize = layoutChild('text', const BoxConstraints());
//     }

//     if (hasChild('icon')) {
//       iconSize = layoutChild('icon', const BoxConstraints());

//       double top = size.height - iconSize.height - bottomSize.height;

//       positionChild(
//           'icon',
//           Offset(
//               leftPadding +
//                   (size.width - iconSize.width - leftPadding - rightPadding) /
//                       2.0 -
//                   textSize.width / 2.0 -
//                   iconSize.width / 2.0,
//               top));
//     }

//     if (hasChild('text')) {
//       double v = 1.0 - (maxExtent - size.height) / (maxExtent - minExtent);

//       double top;

//       if (pinnedHeader) {
//         double topMax = maxExtent -
//             bottomSize.height -
//             textSize.height -
//             (iconSize.height - textSize.height) / 2.0;

//         double topMin = topPadding + (kToolbarHeight - textSize.height) / 2.0;

//         top = topMin + (topMax - topMin) * v;
//       } else {
//         top = size.height -
//             bottomSize.height -
//             textSize.height -
//             (iconSize.height - textSize.height) / 2.0 * v;
//       }

//       positionChild(
//           'text',
//           Offset(
//               leftPadding +
//                   (size.width - textSize.width - leftPadding - rightPadding) /
//                       2.0,
//               top));
//     }
//   }

//   @override
//   bool shouldRelayout(HorizontalHeader oldDelegate) =>
//       leftPadding != oldDelegate.leftPadding ||
//       topPadding != oldDelegate.topPadding ||
//       rightPadding != oldDelegate.rightPadding;
// }

// class VerticalHeader extends MultiChildLayoutDelegate {
//   final double topPadding;
//   final double leftPadding;
//   final double rightPadding;
//   final double minExtent;
//   final double maxExtent;

//   VerticalHeader({
//     this.leftPadding = 0.0,
//     this.topPadding = 0.0,
//     this.rightPadding = 0.0,
//     this.minExtent = 0.0,
//     this.maxExtent = 0.0,
//   });

//   @override
//   void performLayout(Size size) {
//     Size bottomSize = Size.zero;
//     Size textSize = Size.zero;
//     Size iconSize = Size.zero;

//     final availibleConstraint = BoxConstraints(
//         maxWidth: size.width - leftPadding - rightPadding,
//         maxHeight: size.height - topPadding);

//     double top = size.height;

//     if (hasChild('leftActions')) {
//       final leftActionSize = layoutChild('leftActions', availibleConstraint);
//       double actionTop = math.min(
//           topPadding + (kToolbarHeight - leftActionSize.height) / 2.0,
//           size.height - leftActionSize.height);

//       positionChild('leftActions', Offset(leftPadding, actionTop));
//     }

//     if (hasChild('rightActions')) {
//       final rightActionSize = layoutChild('rightActions', availibleConstraint);
//       double actionTop = math.min(
//           topPadding + (kToolbarHeight - rightActionSize.height) / 2.0,
//           size.height - rightActionSize.height);
//       positionChild('rightActions',
//           Offset(size.width - rightPadding - rightActionSize.width, actionTop));
//     }

//     if (hasChild('bottom')) {
//       bottomSize = layoutChild('bottom', availibleConstraint);

//       top -= bottomSize.height;

//       positionChild(
//           'bottom',
//           Offset(
//               leftPadding +
//                   (size.width - bottomSize.width - leftPadding - rightPadding) /
//                       2.0,
//               top));
//     }

//     if (hasChild('text')) {
//       textSize = layoutChild('text', const BoxConstraints());
//       double v = 1.0 - (maxExtent - size.height) / (maxExtent - minExtent);

//       // double topMax =
//       //     maxExtent - topPadding - textSize.height - bottomSize.height;

//       double topMax = top - textSize.height;

//       // size.height -
//       //     bottomSize.height -
//       //     textSize.height -
//       //     (iconSize.height - textSize.height) / 2.0;

//       double topMin = topPadding + (kToolbarHeight - textSize.height) / 2.0;

//       // double top = size.height -
//       //     bottomSize.height -
//       //     textSize.height -
//       //     (iconSize.height - textSize.height) / 2.0 * v;

//       top = topMin + (topMax - topMin) * v;
//       // print('v: $v top: $top');

//       positionChild(
//           'text',
//           Offset(
//               leftPadding +
//                   (size.width - textSize.width - leftPadding - rightPadding) /
//                       2.0,
//               top));
//     }

//     if (hasChild('icon')) {
//       iconSize = layoutChild('icon', const BoxConstraints());

//       top -= iconSize.height;

//       positionChild(
//           'icon',
//           Offset(
//               leftPadding +
//                   (size.width - iconSize.width - leftPadding - rightPadding) /
//                       2.0,
//               top));
//     }
//   }

//   @override
//   bool shouldRelayout(VerticalHeader oldDelegate) =>
//       leftPadding != oldDelegate.leftPadding ||
//       topPadding != oldDelegate.topPadding ||
//       rightPadding != oldDelegate.rightPadding;
// }
