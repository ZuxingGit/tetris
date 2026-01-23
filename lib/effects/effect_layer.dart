import 'package:flutter/material.dart';

class EffectLayer extends StatefulWidget {
  final Widget child;

  const EffectLayer({super.key, required this.child});

  static _EffectLayerState of(BuildContext context) {
    return context.findAncestorStateOfType<_EffectLayerState>()!;
  }

  @override
  State<EffectLayer> createState() => _EffectLayerState();
}

class _EffectLayerState extends State<EffectLayer> {
  final List<Widget> _effects = [];

  void play(Widget effect) {
    setState(() {
      _effects.add(effect);
    });
  }

  void remove(Widget effect) {
    setState(() {
      _effects.remove(effect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [widget.child, ..._effects]);
  }
}
