import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tmdb/bloc/detail/detail_cubit.dart';
import 'package:tmdb/constant/color.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/screen/video_screen.dart';
import 'package:tmdb/widget/conditional.dart';
import 'package:tmdb/widget/genre_chip.dart';
import 'package:tmdb/widget/spacer.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  final Map<int, String> mappedGenres;

  const MovieDetailScreen({super.key, required this.movie, required this.mappedGenres});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final DetailCubit _detailBloc;

  @override
  void initState() {
    super.initState();

    _detailBloc = DetailCubit()..onTrailerRequested(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailCubit, DetailState>(
        bloc: _detailBloc,
        builder: (context, state) {
          return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 280,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Conditional(
                                  condition: widget.movie.posterUrl == "",
                                  child: (context) => Container(
                                    color: Colors.black12,
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: const Center(child: Text("No Poster Available", style: TextStyle(fontSize: 12, color: Color(0xFF808080))))
                                  ),
                                  fallback: (context) => CachedNetworkImage(
                                    imageUrl: '$imageUrl/${widget.movie.posterUrl}',
                                    placeholder:(context, url) => const SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                        width: double.infinity,
                                        height: double.infinity
                                      )
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                )
                              ),
                              Container(width: double.infinity, height: double.infinity, color: Colors.black.withOpacity(0.6)),
                              SafeArea(
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                                        HorizontalSpacer.extraSmall(),
                                        Text("Home", style: TextStyle(height: 1.05, color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        Positioned(
                          right: 10,
                          bottom: 0,
                          child: ElevatedButton(
                            onPressed: () {
                              if(state.trailers.isEmpty) return;

                              Navigator.push(context, MaterialPageRoute(builder: (_) => VideoScreen(videoId: state.trailers.first.key, site: state.trailers.first.site)));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              // padding: state.status == DetailStatus.loading ? EdgeInsets.zero : const EdgeInsets.all(20),
                              backgroundColor: state.trailers.isEmpty ? Colors.grey : Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                            child: Conditional(
                              condition: state.status.isLoading,
                              child: (context) => const SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  shape: BoxShape.circle,
                                  width: 48, 
                                  height: 48
                                ),
                              ),
                              fallback: (context) => const Icon(Icons.play_arrow, color: Colors.white),
                            )
                          )
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.movie.title, style: const TextStyle(fontSize: 32)),
                        const VerticalSpacer.large(),
                        Container(
                          padding: const EdgeInsets.only(right: 50),
                          width: double.infinity,
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 7,
                            children: widget.movie.genres.map((genre) {
                              return GenreChip(label: widget.mappedGenres[genre]!);
                            }).toList()
                          ),
                        ),
                        const VerticalSpacer.large(),
                        const Text("Overview"),
                        const VerticalSpacer.small(),
                        Text(
                          widget.movie.overview == "" ? "-" : widget.movie.overview ,
                          style: const TextStyle(
                            color: secondaryLabel,
                            fontSize: 12
                          )
                        )
                      ],
                    )
                  )
                ],
              ),
            );
        },
      )
    );
  }
}