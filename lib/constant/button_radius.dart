import 'package:flutter/material.dart';

enum ButtonRadius {
  sharp, stadium, rounded, circle, semiRounded
}

extension ButtonRadiusExtension on ButtonRadius {
  OutlinedBorder get radius {
    switch(this) {
      case ButtonRadius.sharp:
        return const RoundedRectangleBorder(borderRadius: BorderRadius.zero);

      case ButtonRadius.stadium:
        return const StadiumBorder();

      case ButtonRadius.circle:
        return const CircleBorder();

      case ButtonRadius.semiRounded:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));

      case ButtonRadius.rounded:
      default:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    }
  }
}