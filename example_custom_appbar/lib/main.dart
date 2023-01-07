import 'package:custom_sliver_appbar/shapeborder_appbar/shapeborder_lb_rb_rounded.dart';
import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
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
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Image Appbar',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      home: const AdjustScrollConfiguration(
          child: MyHomePage(title: 'Text Image Appbar')),
    );
  }
}

class AdjustScrollConfiguration extends StatelessWidget {
  final Widget child;

  const AdjustScrollConfiguration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final platform = defaultTargetPlatform;

    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      return child;
    } else {
      final media = MediaQuery.of(context);
      final padding = media.padding;

      if (padding.top == 0.0) {
        return MediaQuery(
            data: media.copyWith(padding: padding.copyWith(top: 24.0)),
            child: Stack(
              children: [
                Positioned(
                    left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: child),
                Positioned(
                    left: 0.0,
                    top: 0.0,
                    right: 0.0,
                    height: 24.0,
                    child: Container(color: Colors.pink.withOpacity(0.1))),
              ],
            ));
      } else {
        return child;
      }
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Options optionsPortrait = Options();
  Options optionsLandscape = Options();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    double minImageHeight = 50.0;
    double maxImageHeight = mediaQuery.size.shortestSide / 2.0;
    final options = orientation == Orientation.portrait
        ? optionsPortrait
        : optionsLandscape;

    options.imageHeight =
        clampDouble(options.imageHeight, minImageHeight, maxImageHeight);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: TitleImageAppBar(
              orientation: orientation,
              elevation: options.elevation,
              elevationScrolledUnder: options.elevationScrolledUnder,
              backgroundColor: options.backgroundColor,
              backgroundColorScrolledUnder:
                  options.backgroundColorScrolledUnder,
              title: options.showTitle ? widget.title : null,
              imageIncludeSafeTop: options.imageBehindAppbarStatus,
              notificationPredicate: (ScrollNotification notification) =>
                  notification.depth == 1,
              imageHeight: options.showImage ? options.imageHeight : 0.0,
              imageBuilder: options.showImage
                  ? (_) => const Image(
                          image: AssetImage(
                        'graphics/verf.png',
                      ))
                  : null,
              leftActions: options.showActionButtons
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {},
                        )
                      ],
                    )
                  : null,
              bottom: options.showBottom
                  ? const TabBar(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      tabs: [Tab(text: 'About'), Tab(text: 'Options')])
                  : null,
              appBarBackgroundBuilder: (
                  {required BuildContext context,
                  required EdgeInsets padding,
                  required double safeTopPadding,
                  required bool scrolledUnder,
                  Widget? child}) {
                const leftPadding = 56.0;
                return Material(
                    color: scrolledUnder
                        ? options.backgroundColorScrolledUnder
                        : options.backgroundColor,
                    shape: ShapeBorderLbRbRounded(
                      topPadding: safeTopPadding,
                      leftInsets: leftPadding,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: leftPadding),
                      child: child,
                    ));
              }),
          body: TabBarView(
            children: [
              CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: About()),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: 25,
                        (context, index) => Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0))),
                            color:
                                index.isOdd ? Colors.white : Colors.amber[50],
                            child: SizedBox(
                                height: 200.0,
                                child: Center(
                                    child: Text(
                                  'index $index',
                                  style: const TextStyle(fontSize: 24.0),
                                ))))),
                  )
                ],
              ),
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: OptionsCard(
                    options: options,
                    minImageHeight: minImageHeight,
                    maxImageHeight: maxImageHeight,
                    onChange: () {
                      setState(() {});
                    },
                  )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: 25,
                        (context, index) => Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0))),
                            color:
                                index.isOdd ? Colors.white : Colors.amber[50],
                            child: SizedBox(
                                height: 200.0,
                                child: Center(
                                    child: Text(
                                  'index $index',
                                  style: const TextStyle(fontSize: 24.0),
                                ))))),
                  )
                ],
              ),
            ],
          )),
    );
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
