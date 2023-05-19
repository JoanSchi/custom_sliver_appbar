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
        ),
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
                    child: Container(
                        color: const Color(0xFF70b7d3).withOpacity(0.2))),
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
    final theme = Theme.of(context);

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
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                          onPressed: () =>
                              info('A button just for the decoration :)'),
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
                const leftPadding = 0.0; //56.0;
                return Material(
                    color: scrolledUnder
                        ? options.backgroundColorScrolledUnder
                        : options.backgroundColor,
                    shape: ShapeBorderLbRbRounded(
                      topPadding: safeTopPadding,
                      leftInsets: leftPadding,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: leftPadding) + padding,
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
                            color: index.isOdd
                                ? theme.colorScheme.surface
                                : theme.colorScheme.surfaceTint,
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
                            color: index.isOdd
                                ? theme.colorScheme.surface
                                : theme.colorScheme.surfaceTint,
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
