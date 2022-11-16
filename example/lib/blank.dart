import 'package:flutter/material.dart';

class BlankCard extends StatelessWidget {
  final int index;
  final double radial;
  final Widget title;

  const BlankCard({
    super.key,
    required this.index,
    this.radial = 24.0,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final color = index % 2 == 0 ? Colors.white : Colors.amber[50];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radial),
          ),
          color: color,
          child: Center(
            child: title,
          )),
    );
  }
}
