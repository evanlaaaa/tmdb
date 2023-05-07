import 'package:flutter/material.dart';
import 'package:tmdb/constant/button_radius.dart';
import 'package:tmdb/constant/button_style.dart';

class VButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final ButtonRadius? radiusStyle;
  final VButtonStyle style;

  final double? width;
  final double? height;

  final Color? color;
  final Color? borderColor;

  final EdgeInsetsGeometry? padding;

  const VButton({
    super.key, 
    this.onPressed,
    this.radiusStyle,
    this.height,
    this.width,
    this.color,
    this.style = VButtonStyle.filled,
    this.borderColor,
    this.padding,

    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
        padding: padding,
        side: style == VButtonStyle.outlined ? BorderSide(color: borderColor ?? Colors.black) : null,
        shape: (radiusStyle ?? ButtonRadius.rounded).radius,
        minimumSize: Size(width ?? 88.0, height ?? 36.0),
        shadowColor: Colors.transparent,
        backgroundColor: style == VButtonStyle.outlined
          ? Colors.transparent
          : color ?? Theme.of(context).colorScheme.primary,
        foregroundColor: (style == VButtonStyle.outlined
            ? Colors.transparent
            : color ?? Theme.of(context).colorScheme.primary
          ).computeLuminance() >= 0.5 || (style == VButtonStyle.outlined
            ? Colors.transparent
            : color ?? Theme.of(context).colorScheme.primary
          ).alpha == 0x00
          ? Colors.black
          : Colors.white,
      ),
      onPressed: onPressed ?? () {},
      child: child
    );
  }
}