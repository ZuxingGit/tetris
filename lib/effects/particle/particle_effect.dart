import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tetris/effects/effect_layer.dart';
import 'package:tetris/effects/effect_widget.dart';
import 'particle.dart';

class ParticleClearEffect extends StatefulWidget implements EffectWidget {
  final Offset startPosition;
  final double size;
  final Color color;

  const ParticleClearEffect({
    super.key,
    required this.startPosition,
    required this.size,
    required this.color,
  });

  @override
  State<ParticleClearEffect> createState() => _ParticleClearEffectState();
}

class _ParticleClearEffectState extends State<ParticleClearEffect>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final List<Particle> particles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // create particles
    for (int i = 0; i < 12; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 60 + random.nextDouble() * 120;

      particles.add(
        Particle(
          position: widget.startPosition,
          velocity: Offset(cos(angle) * speed, sin(angle) * speed),
          size: 2 + random.nextDouble() * 3,
          color: widget.color,
          life: 0.8 + random.nextDouble() * 0.2,
        ),
      );
    }

    _ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;

    if (dt <= 0) return;

    for (final p in particles) {
      p.update(dt);
    }

    particles.removeWhere((p) => p.isDead);

    if (particles.isEmpty) {
      _ticker.stop();
      if (!mounted) return;
      EffectLayer.of(context).remove(widget);
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: particles.map((p) {
        return Positioned(
          left: p.position.dx,
          top: p.position.dy,
          child: Opacity(
            opacity: p.life.clamp(0.0, 1.0),
            child: Container(
              width: p.size,
              height: p.size,
              decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
            ),
          ),
        );
      }).toList(),
    );
  }
}
