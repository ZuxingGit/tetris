import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tetris/effects/effect_widget.dart';
import 'effect_layer.dart';

class BirdFlyEffect extends StatefulWidget implements EffectWidget {
  final Offset startPosition;
  final double size;

  const BirdFlyEffect({
    super.key,
    required this.startPosition,
    required this.size,
  });

  @override
  State<BirdFlyEffect> createState() => _BirdFlyEffectState();
}

class _BirdFlyEffectState extends State<BirdFlyEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    final random = Random();
    final dx = (random.nextDouble() - 0.5) * 200;
    final dy = -200 - random.nextDouble() * 200;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx, dy),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _controller.forward().whenComplete(() {
      EffectLayer.of(context).remove(widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double scaleFactor = 1.5;
    final double effectSize = widget.size * scaleFactor;
    final double left =
        widget.startPosition.dx - (effectSize - widget.size) / 2;
    final double top = widget.startPosition.dy - (effectSize - widget.size) / 2;

    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Transform.translate(
            offset: _offsetAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: SizedBox(
                width: effectSize,
                height: effectSize,
                child: Lottie.asset(
                  'assets/lottie/owl_bird.json',
                  repeat: true,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
