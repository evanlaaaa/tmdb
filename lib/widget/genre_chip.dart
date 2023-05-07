import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GenreChip extends StatelessWidget {
  final int id;
  final String label;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;

  Color inactiveColor;

  bool isSelected;
  bool isSelectable;

  Function(int)? onTap;

  GenreChip({
    super.key,
    required this.label, 
    this.color = Colors.black,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 1)
  }) 
  : id = 0,
    isSelectable = false,
    isSelected = true,
    inactiveColor = Colors.black;

  GenreChip.selectable({
    super.key,
    required this.id,
    required this.label,
    required this.isSelected,
    this.inactiveColor = Colors.grey,
    this.color = Colors.black,
    this.fontSize = 10,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 1)
  })
  : isSelectable = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(id);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: isSelected ? color : inactiveColor),
          color: isSelectable 
            ? isSelected 
              ? color : null
            : null,
        ),
        padding: padding,
        child: Text(
          label,
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize,
            color: isSelectable 
              ? isSelected 
                ? Colors.white : inactiveColor
              : color,
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}