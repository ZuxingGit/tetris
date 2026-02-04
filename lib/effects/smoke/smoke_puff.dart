import 'dart:math';
import 'package:flutter/material.dart';

class SmokePuff {
  final Offset origin;
  final double angle;
  final double speed;
  final double size;
  final Color color;

  SmokePuff({
    required this.origin,
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });

  Offset position(double t) {
    final wobble = sin(t * pi * 2 + angle) * 6;
    final dx = cos(angle) * speed * t + wobble;
    final dy = -speed * t * 0.8 - t * t * 30;
    return origin.translate(dx, dy);
  }
}
