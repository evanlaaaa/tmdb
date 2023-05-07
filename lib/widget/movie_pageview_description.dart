import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tmdb/bloc/root/root_cubit.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/widget/conditional.dart';
import 'package:tmdb/widget/genre_chip.dart';
import 'package:tmdb/widget/spacer.dart';

class MoviePageViewDescription extends StatelessWidget {
  final Movie movie;
  final bool isLoading;

  const MoviePageViewDescription({super.key, required this.movie, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Conditional(
          condition: isLoading, 
          child: (context) => const SkeletonLine(),
          fallback: (context) => RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
              children: [
                TextSpan(text: movie.title),
                TextSpan(text: ' (${movie.year})', style: const TextStyle(
                  fontWeight: FontWeight.normal
                ))
              ]
            ),
          ),
        ),
        const VerticalSpacer.medium(),
        Conditional(
          condition: isLoading, 
          child: (context) => Row(
            children: const [
              SkeletonAvatar(style: SkeletonAvatarStyle(width: 30, height: 15)),
              HorizontalSpacer.small(),
              SkeletonAvatar(style: SkeletonAvatarStyle(width: 30, height: 15)),
              HorizontalSpacer.small(),
              SkeletonAvatar(style: SkeletonAvatarStyle(width: 30, height: 15))
            ],
          ),
          fallback: (context) =>  SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: movie.genres.map((genre) {
                return GenreChip(label: context.read<RootCubit>().state.mappedGenres[genre]!, color: Colors.white);
              }).toList()
            ),
          ),
        ),
        const VerticalSpacer.medium(),
        Flexible(
          child: Conditional(
            condition: isLoading,
            child: (context) => SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                padding: EdgeInsets.zero,
                lines: 3,
                spacing: 8,
                lineStyle: SkeletonLineStyle(
                  height: 12,
                )
              ),
            ),
            fallback: (context) => Text(
              movie.overview,
              style: const TextStyle(
                color: Color.fromARGB(255, 203, 203, 203),
                fontSize: 12
              )
            )
          ),
        )
      ],
    );
  }
}