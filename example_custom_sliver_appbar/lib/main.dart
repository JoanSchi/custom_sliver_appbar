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

import 'dart:ui';
import 'package:custom_sliver_appbar/shapeborder_appbar/shapeborder_lb_rb_rounded.dart';
import 'package:custom_sliver_appbar/sliver_header/center_y.dart';
import 'package:custom_sliver_appbar/sliver_header/clip_top.dart';
import 'package:custom_sliver_appbar/sliver_header/ratio_reposition_resize.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/properties.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:example_custom_sliver_appbar/blank.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'about.dart';
import 'options.dart';

void main() {
  setOverlayStyle();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom sliver appbar',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 17, 85, 114),
            onPrimary: Color(0xFFFFFFFF),
            primaryContainer: Color(0xFFf1f5fd),
            onPrimaryContainer: Color.fromARGB(255, 5, 66, 92),
            secondary: Color(0xFF625B71),
            onSecondary: Color(0xFFFFFFFF),
            secondaryContainer:
                Color.fromARGB(255, 174, 188, 193), //Color(0xFFE8DEF8),
            onSecondaryContainer: Color.fromARGB(255, 5, 66, 92),
            tertiary: Color(0xFF7E5260),
            onTertiary: Color(0xFFFFFFFF),
            tertiaryContainer: Color(0xFFFFD9E3),
            onTertiaryContainer: Color(0xFF31101D),
            error: Color(0xFFBA1A1A),
            errorContainer: Color(0xFFFFDAD6),
            onError: Color(0xFFFFFFFF),
            onErrorContainer: Color(0xFF410002),
            background: Colors.white, // Color(0xFFFFFBFF),
            onBackground: Color(0xFF1C1B1E),
            surface: Color.fromARGB(255, 246, 250, 253),
            //onSurface: Text, icons
            onSurface: Color.fromARGB(255, 3, 50, 71),
            surfaceVariant: Color(0xFFE7E0EB),
            onSurfaceVariant: Color(0xFF49454E),
            outline: Color(0xFF7A757F),
            onInverseSurface: Color(0xFFF4EFF4),
            inverseSurface: Color(0xFF313033),
            inversePrimary: Color(0xFF70b7d3),
            shadow: Color(0xFF000000),
            //surfaceTint: Tint background calendar
            surfaceTint: Color(0xFF70b7d3),
            //outlineVariant: Divider
            outlineVariant: Color(0xFFCAC4CF),
            scrim: Color(0xFF000000),
          )),
      home: const AdjustScrollConfiguration(),
    );
  }
}

class AdjustScrollConfiguration extends StatelessWidget {
  const AdjustScrollConfiguration({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = defaultTargetPlatform;

    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      return ScrollConfiguration(
          behavior: MyScrollBehavior(), child: const Example());
    } else {
      final media = MediaQuery.of(context);
      final padding = media.padding;

      final w = ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: const Example(blockTabPhysics: true),
      );

      if (padding.top == 0.0) {
        return MediaQuery(
            data: media.copyWith(padding: padding.copyWith(top: 24.0)),
            child: Stack(
              children: [
                Positioned(
                    left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: w),
                Positioned(
                    left: 0.0,
                    top: 0.0,
                    right: 0.0,
                    height: 24.0,
                    child: Container(
                        color: const Color(0xFF70b7d3).withOpacity(0.2))),
              ],
            ));
      } else {
        return w;
      }
    }
  }
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  TargetPlatform getPlatform(BuildContext context) {
    final platform = defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return platform;
      default:
        return TargetPlatform.android;
    }
  }

  @override
  Set<PointerDeviceKind> get dragDevices {
    final platform = defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return super.dragDevices;
      default:
        return {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        };
    }
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        );
    }
  }
}

class Example extends StatefulWidget {
  final bool blockTabPhysics;
  const Example({Key? key, this.blockTabPhysics = false})
      : super(
          key: key,
        );

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late final optionsPortrait = Options(
      minExtent: 0.0,
      floatingExtent: 56.0 + 48,
      maxExtent: 260.0,
      lrTbFit: LrTbFit.no,
      imageBehindStatusbar: false,
      bottomHeigth: 0,
      blockTabScroll: widget.blockTabPhysics);
  late final optionsLandscape = Options(
      minExtent: 0.0,
      floatingExtent: 48.0,
      maxExtent: 100.0,
      lrTbFit: LrTbFit.fit,
      bottomHeigth: 0,
      blockTabScroll: widget.blockTabPhysics);

  bool blockTabScroll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orientation = MediaQuery.of(context).orientation;

    final List<String> tabs = <String>[
      'About',
      'Options',
    ];

    final bottom = TabBar(
      labelColor: theme.colorScheme.primary,
      tabs: tabs.map((String name) => Tab(text: name)).toList(),
    );

    (orientation == Orientation.portrait ? optionsPortrait : optionsLandscape)
        .bottomHeigth = bottom.preferredSize.height;

    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            // SliverOverlapAbsorber(
            //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            //   sliver:
            TextImageSliverAppBar(
              correctForSnap: true,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              // appBarBackgroundBuilder: builderBackground,
              minExtent: orientation == Orientation.portrait
                  ? optionsPortrait.minExtent
                  : optionsLandscape.minExtent,
              floatingExtent: orientation == Orientation.portrait
                  ? optionsPortrait.floatingExtent
                  : optionsLandscape.floatingExtent,
              maxCenter: orientation == Orientation.portrait
                  ? optionsPortrait.maxExtent
                  : optionsLandscape.maxExtent,
              tween: orientation == Orientation.portrait
                  ? Tween(begin: 42, end: 36)
                  : null,
              scrolledUnderBackground: const Color.fromARGB(255, 236, 247, 251),
              lrTbFit: orientation == Orientation.portrait
                  ? optionsPortrait.lrTbFit
                  : optionsLandscape.lrTbFit,
              leftActions: (_, double height) => ClipTop(
                maxHeight: height,
                child: CenterY(
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          info('A button just for the decoration :)')),
                ),
              ),
              rightActions: (_, double height) => ClipTop(
                maxHeight: height,
                child: CenterY(
                  child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () =>
                          info('A button just for the decoration :)')),
                ),
              ),
              title: CustomTitle(
                title: "Joan's appbar",
                textStyleTween: TextStyleTween(
                    begin: const TextStyle(fontSize: 24.0),
                    end: const TextStyle(fontSize: 16.0)),
                height: Tween(begin: 56.0, end: 56.0),
              ),
              image: orientation == Orientation.portrait
                  ? CustomImage(
                      includeTopWithMinium:
                          optionsPortrait.imageBehindStatusbar,
                      imageBuilder: (_) => const RePositionReSize(
                        ratioHeight: 1.0,
                        ratioPosition: Ratio(0.0, 0.0),
                        child: Image(
                            image: AssetImage(
                          'graphics/verf.png',
                        )),
                      ),
                    )
                  : CustomImage(
                      includeTopWithMinium:
                          optionsLandscape.imageBehindStatusbar,
                      imageBuilder: (_) => const RePositionReSize(
                            ratioHeight: 1.0,
                            ratioPosition: Ratio(0.0, 0.0),
                            child: Image(
                                image: AssetImage(
                              'graphics/verf.png',
                            )),
                          )),
              pinned: true,
              bottom: bottom,
              orientation: orientation,
              // ),
            ),
          ];
        },
        body: TabBarView(
          physics: (orientation == Orientation.portrait
                  ? optionsPortrait.blockTabScroll
                  : optionsLandscape.blockTabScroll)
              ? const NeverScrollableScrollPhysics()
              : null,
          // These are the contents of the tab views, below the tabs.
          children: [
            Builder(
              // This Builder is needed to provide a BuildContext that is
              // "inside" the NestedScrollView, so that
              // sliverOverlapAbsorberHandleFor() can find the
              // NestedScrollView.
              builder: (BuildContext context) {
                return CustomScrollView(
                  // The "controller" and "primary" members should be left
                  // unset, so that the NestedScrollView can control this
                  // inner scroll view.
                  // If the "controller" property is set, then this scroll
                  // view will not be associated with the NestedScrollView.
                  // The PageStorageKey should be unique to this ScrollView;
                  // it allows the list to remember its scroll position when
                  // the tab view is not on the screen.
                  key: const PageStorageKey<String>('list'),
                  slivers: <Widget>[
                    // SliverOverlapInjector(
                    //   // This is the flip side of the SliverOverlapAbsorber
                    //   // above.
                    //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    //       context),
                    // ),
                    const SliverToBoxAdapter(
                        child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: About(),
                    )),
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      // In this example, the inner scroll view has
                      // fixed-height list items, hence the use of
                      // SliverFixedExtentList. However, one could use any
                      // sliver widget here, e.g. SliverList or SliverGrid.
                      sliver: SliverFixedExtentList(
                        // The items in this example are fixed to 48 pixels
                        // high. This matches the Material Design spec for
                        // ListTile widgets.
                        itemExtent: 300.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // This builder is called for each child.
                            // In this example, we just number each list item.
                            return BlankCard(
                              index: index,
                              title: Text('Item $index'),
                            );
                          },
                          // The childCount of the SliverChildBuilderDelegate
                          // specifies how many children this inner list
                          // has. In this example, each tab has a list of
                          // exactly 30 items, but this is arbitrary.
                          childCount: 60,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Builder(
              builder: (BuildContext context) {
                return CustomScrollView(
                  key: const PageStorageKey<String>('options'),
                  slivers: <Widget>[
                    // SliverOverlapInjector(
                    //   // This is the flip side of the SliverOverlapAbsorber
                    //   // above.
                    //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    //       context),
                    // ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: OptionsCardPortrait(
                          options: orientation == Orientation.portrait
                              ? optionsPortrait
                              : optionsLandscape,
                          onChange: onChange,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverFixedExtentList(
                        itemExtent: 300.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // This builder is called for each child.
                            // In this example, we just number each list item.
                            return BlankCard(
                              index: index,
                              title: Text('Item $index'),
                            );
                          },
                          childCount: 60,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      )),
    );
  }

  onChange() {
    setState(() {});
  }

  Widget builderBackground(
      {required BuildContext context,
      required EdgeInsets padding,
      required double safeTopPadding,
      required bool scrolledUnder,
      Widget? child}) {
    const leftPadding = 56.0;
    return Material(
        color: scrolledUnder
            ? const Color.fromARGB(255, 254, 252, 245)
            : Colors.white,
        shape: ShapeBorderLbRbRounded(
          topPadding: safeTopPadding,
          leftInsets: leftPadding,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: leftPadding),
          child: child,
        ));
  }

  void info(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Info',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

setOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white, //Color(0xFFf1f4fb),
      systemNavigationBarIconBrightness: Brightness.dark));
}
