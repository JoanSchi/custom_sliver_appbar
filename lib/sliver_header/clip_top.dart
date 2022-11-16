import 'package:flutter/widgets.dart';

class ClipTop extends StatelessWidget {
  final Widget child;

  final double maxHeight;

  const ClipTop({super.key, required this.child, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: TopClipper(maxHeight),
      child: child,
    );
  }
}

class TopClipper extends CustomClipper<Rect> {
  final double maxHeight;

  TopClipper(this.maxHeight);

  @override
  Rect getClip(Size size) {
    if (maxHeight < size.height) {
      return Rect.fromLTWH(0.0, size.height - maxHeight, size.width, maxHeight);
    } else {
      return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(TopClipper oldClipper) {
    return maxHeight != oldClipper.maxHeight;
  }
}
