import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris/effects/effect_layer.dart';
import 'package:tetris/effects/effect_widget.dart';
import 'smoke_puff.dart';

class SmokeClearEffect extends StatefulWidget implements EffectWidget {
  final Offset startPosition;
  final double size;
  final Color color;

  const SmokeClearEffect({
    super.key,
    required this.startPosition,
    required this.size,
    required this.color,
  });

  @override
  State<SmokeClearEffect> createState() => _SmokeClearEffectState();
}

class _SmokeClearEffectState extends State<SmokeClearEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SmokePuff> _puffs = [];
  final Random _random = Random();

  static const int puffCount = 10;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 990),
    );

    for (int i = 0; i < puffCount; i++) {
      _puffs.add(
        SmokePuff(
          origin: widget.startPosition,
          angle: -pi / 2 + (_random.nextDouble() - 0.5) * pi / 1.5,
          speed: 150 + _random.nextDouble() * 20,
          size: widget.size * (0.3 + _random.nextDouble() * 0.4),
          color: widget.color,
        ),
      );
    }

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        EffectLayer.of(context).remove(widget);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value;

        return Stack(
          children: _puffs.map((puff) {
            final pos = puff.position(t);
            final opacity = (1 - t) * 0.5;
            final scale = 3 + Curves.easeOut.transform(t) * 0.5;

            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: puff.size,
                    height: puff.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          puff.color.withOpacity(0.85),
                          puff.color.withOpacity(0.15),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
