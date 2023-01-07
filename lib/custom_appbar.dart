import 'package:flutter/widgets.dart';

typedef AppBarBackgroundBuilder = Widget Function(
    {required BuildContext context,
    required EdgeInsets padding,
    required double safeTopPadding,
    required bool scrolledUnder,
    Widget? child});
