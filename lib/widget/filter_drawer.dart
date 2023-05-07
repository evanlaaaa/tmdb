import 'package:flutter/material.dart';
import 'package:tmdb/constant/button_radius.dart';
import 'package:tmdb/constant/button_style.dart';
import 'package:tmdb/model/genre.dart';
import 'package:tmdb/widget/button.dart';
import 'package:tmdb/widget/genre_chip.dart';
import 'package:tmdb/widget/spacer.dart';

class FilterDrawer extends StatefulWidget {
  final List<Genre> genreList;
  final List<int> selectedGenreIds;
  final Function(List<int> ids) onFilterApplied;

  const FilterDrawer({
    super.key,
    required this.genreList, 
    required this.selectedGenreIds,
    required this.onFilterApplied
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  List<int> selectedGenreIds = [];

  @override
  void initState() {
    selectedGenreIds = widget.selectedGenreIds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text("Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
            const VerticalSpacer.medium(),
            const Text("Genre", style: TextStyle(fontSize: 16)),
            const VerticalSpacer.medium(),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.genreList.map((genre) {
                return GenreChip.selectable(
                  id: genre.id,
                  label: genre.name, 
                  isSelected: selectedGenreIds.contains(genre.id),
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  onTap: (id) {
                    if(selectedGenreIds.contains(id)) {
                      setState(() {
                        selectedGenreIds.remove(id);
                      });
                    }
                    else {
                      setState(() {
                        selectedGenreIds.add(id);
                      });
                    }
                  }
                );
              }).toList(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: VButton(
                        style: VButtonStyle.outlined,
                        radiusStyle: ButtonRadius.stadium,
                        borderColor: Theme.of(context).colorScheme.primary,
                        child: Text("Clear", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                        onPressed: () {
                          setState(() {
                            selectedGenreIds.clear();
                          });
                        },
                      ),
                    ),
                    const HorizontalSpacer.medium(),
                    Expanded(
                      child: VButton(
                        style: VButtonStyle.filled,
                        radiusStyle: ButtonRadius.stadium,
                        borderColor: Theme.of(context).colorScheme.primary,
                        child: const Text("Apply"),
                        onPressed: () {
                          widget.onFilterApplied(selectedGenreIds);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}