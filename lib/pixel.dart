import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  var color;
  VoidCallback? onCleared;
  Pixel({super.key, required this.color, this.onCleared});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.all(1),
      child: Center(),
    );
  }
}
