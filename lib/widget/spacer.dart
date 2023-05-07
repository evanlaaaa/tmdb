import 'package:flutter/material.dart';

class HorizontalSpacer extends StatelessWidget {
  final double width;

  const HorizontalSpacer({super.key, required this.width});

  const HorizontalSpacer.extraSmall({super.key}) : width = 2.5;
  const HorizontalSpacer.small({super.key}) : width = 5;
  const HorizontalSpacer.medium({super.key}) : width = 10;
  const HorizontalSpacer.large({super.key}) : width = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class VerticalSpacer extends StatelessWidget {
  final double height;

  const VerticalSpacer({super.key, required this.height});

  const VerticalSpacer.extraSmall({super.key}) : height = 2.5;
  const VerticalSpacer.small({super.key}) : height = 5;
  const VerticalSpacer.medium({super.key}) : height = 10;
  const VerticalSpacer.large({super.key}) : height = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}