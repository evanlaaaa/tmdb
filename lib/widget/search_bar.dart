import 'package:flutter/material.dart';
import 'package:tmdb/constant/color.dart';
import 'package:tmdb/widget/conditional.dart';
import 'package:tmdb/widget/spacer.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String value)? onChanged;

  const SearchBar({super.key, this.controller, this.onChanged});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(Icons.search),
          const HorizontalSpacer.small(),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration.collapsed(
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: secondaryLabel,
                ),
                hintText: 'Movie name'
              ),
              onChanged: widget.onChanged
            ),
          ),
          const HorizontalSpacer.small(),
          Conditional(
            condition: widget.controller?.text.isNotEmpty ?? false,
            child: (context) => GestureDetector(
              onTap: () {
                widget.controller?.text = "";
                widget.onChanged?.call("");
              },
              child: const Icon(Icons.clear)
            )
          )
        ],
      )
    );
  }
}