import 'dart:math';
import 'package:flutter/material.dart';
import 'effect_layer.dart';
import 'package:tetris/effects/effect_widget.dart';

class HeartFlyEffect extends StatefulWidget implements EffectWidget {
  final Offset startPosition;
  final double size;

  const HeartFlyEffect({
    super.key,
    required this.startPosition,
    required this.size,
  });

  @override
  State<HeartFlyEffect> createState() => _HeartFlyEffectState();
}

class _HeartFlyEffectState extends State<HeartFlyEffect>
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
      duration: const Duration(milliseconds: 1000),
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
    return Positioned(
      left: widget.startPosition.dx,
      top: widget.startPosition.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Transform.translate(
            offset: _offsetAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.pink,
                size: widget.size,
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
