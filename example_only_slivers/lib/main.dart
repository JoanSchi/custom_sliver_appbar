import 'package:custom_sliver_appbar/sliver_header/center_y.dart';
import 'package:custom_sliver_appbar/sliver_header/clip_top.dart';
import 'package:custom_sliver_appbar/sliver_header/ratio_reposition_resize.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/properties.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: CustomScrollView(slivers: [
        TextImageSliverAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          // appBarBackgroundBuilder: builderBackground,
          minExtent: 80,
          floatingExtent: 136,
          maxCenter: 200,
          tween: Tween(begin: 42, end: 36),
          scrolledUnderBackground: const Color.fromARGB(255, 236, 247, 251),
          lrTbFit: LrTbFit.fit,
          leftActions: (_, double height) => ClipTop(
            maxHeight: height,
            child: CenterY(
              child: IconButton(
                  icon: const Icon(Icons.arrow_back), onPressed: () {}),
            ),
          ),
          rightActions: (_, double height) => ClipTop(
            maxHeight: height,
            child: CenterY(
              child: IconButton(
                  icon: const Icon(Icons.settings), onPressed: () {}),
            ),
          ),
          title: CustomTitle(
            title: "Joan's appbar",
            textStyleTween: TextStyleTween(
                begin: const TextStyle(fontSize: 24.0),
                end: const TextStyle(fontSize: 16.0)),
            height: Tween(begin: 56.0, end: 56.0),
          ),
          image: CustomImage(
            includeTopWithMinium: false,
            imageBuilder: (_) => const RePositionReSize(
              ratioHeight: 1.0,
              ratioPosition: Ratio(0.0, 0.0),
              child: Image(
                  image: AssetImage(
                'graphics/verf.png',
              )),
            ),
          ),

          pinned: true,

          orientation: Orientation.portrait,
        ),
        SliverList(
            delegate: SliverChildListDelegate.fixed([
          Container(
            height: 400,
            color: Colors.pink,
          ),
          TextField(
            controller: textEditingController,
          ),
          Container(
            height: 300,
            color: Colors.pink,
          ),
        ]))
      ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
