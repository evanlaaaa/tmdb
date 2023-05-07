import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tmdb/bloc/root/root_cubit.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/screen/detail_screen.dart';
import 'package:tmdb/widget/genre_chip.dart';

class MovieGridCard extends StatelessWidget {
  final Movie movie;
  final bool isLoading;

  const MovieGridCard({super.key, required this.movie, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie, mappedGenres: context.read<RootCubit>().state.mappedGenres)));
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !isLoading 
              ? movie.posterUrl == "" 
                ? Container(
                  color: Colors.black12,
                  width: double.infinity,
                  height: 120,
                  child: const Center(child: Text("No Poster Available", style: TextStyle(fontSize: 12, color: Color(0xFF808080))))
                )
                : CachedNetworkImage(
                  imageUrl: '$imageUrl/${movie.posterUrl}',
                  placeholder:(context, url) => const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: double.infinity,
                      height: double.infinity
                    )
                  ),
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                )
              : const SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  height: 120,
                  width: double.infinity
                )
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !isLoading 
                      ? RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(text: movie.title),
                            TextSpan(text: ' (${movie.year})', style: const TextStyle(
                              fontWeight: FontWeight.normal
                            ))
                          ]
                        ),
                      )
                      : const SkeletonLine(),
                    const SizedBox(height: 5),
                    !isLoading 
                      ? SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: movie.genres.take(3).map((genre) {
                            return GenreChip(label: context.read<RootCubit>().state.mappedGenres[genre]!);
                          }).toList()
                        ),
                      )
                      : Row(
                        children: const [
                          SkeletonAvatar(style: SkeletonAvatarStyle(width: 30, height: 15)),
                          SizedBox(width: 5),
                          SkeletonAvatar(style: SkeletonAvatarStyle(width: 30, height: 15)),
                          SizedBox(width: 5),
                          SkeletonAvatar(style: SkeletonAvatarStyle(width: 30, height: 15))
                        ],
                      ),
                    const SizedBox(height: 5),
                    !isLoading 
                      ? Flexible(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            TextStyle currentTextStyle = const TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 10,
                              overflow: TextOverflow.ellipsis
                            );
                            
                            int maxLines = ((constraints.maxHeight / currentTextStyle.fontSize!) * 0.8).floor();
                            maxLines = maxLines > 0 ? maxLines : 1;
      
                            return Text(
                              movie.overview,
                              style: const TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis
                              ), 
                              maxLines: maxLines,
                            );
                          }
                        )
                      )
                      : SkeletonParagraph(
                          style: const SkeletonParagraphStyle(
                            padding: EdgeInsets.zero,
                            lines: 3,
                            spacing: 8,
                            lineStyle: SkeletonLineStyle(
                              height: 12,
                            )
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