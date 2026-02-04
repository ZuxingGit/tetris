import 'package:flutter/material.dart';
import 'package:tetris/effects/effect_widget.dart';

class EffectLayer extends StatefulWidget {
  final Widget child;

  const EffectLayer({super.key, required this.child});

  static _EffectLayerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_EffectLayerState>();
    assert(state != null, 'EffectLayer not found in context');
    return state!;
  }

  @override
  State<EffectLayer> createState() => _EffectLayerState();
}

class _EffectLayerState extends State<EffectLayer> {
  final List<EffectWidget> _effects = [];

  void play(EffectWidget effect) {
    setState(() {
      _effects.add(effect);
    });
  }

  void remove(EffectWidget effect) {
    setState(() {
      _effects.remove(effect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [widget.child, ..._effects]);
  }
}
