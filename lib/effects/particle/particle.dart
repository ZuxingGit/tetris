import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.life,
  });

  void update(double dt) {
    position += velocity * dt;
    velocity += const Offset(0, 300) * dt; // gravity
    life -= dt;
  }

  bool get isDead => life <= 0;
}
