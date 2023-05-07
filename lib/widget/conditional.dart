import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool condition;
  final Widget Function(BuildContext context) child;
  final Widget Function(BuildContext context)? fallback;

  final Widget Function(Widget child)? parent;

  const Conditional({
    super.key, 
    required this.condition, 
    required this.child, 
    this.fallback
  }) : parent = null;

  const Conditional.parent({
    super.key, 
    required this.condition,
    required this.child,
    required this.parent
  }) : fallback = null;

  @override
  Widget build(BuildContext context) {
    return parent != null
      ? condition 
        ? parent!.call(child.call(context))
        : child.call(context)
      : condition 
        ? child.call(context)
        : fallback?.call(context) ?? Container();
  }
}