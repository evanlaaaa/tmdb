import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tmdb/bloc/root/root_cubit.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/screen/detail_screen.dart';
import 'package:tmdb/widget/conditional.dart';
import 'package:tmdb/widget/movie_pageview_description.dart';

class MoviePageView extends StatefulWidget {
  final List<Movie> movieList;
  final bool isLoading;
  final Function()? onLoadMore;

  const MoviePageView({super.key, required this.movieList, required this.isLoading, this.onLoadMore});

  @override
  State<MoviePageView> createState() => _MoviePageViewState();
}

class _MoviePageViewState extends State<MoviePageView> {

  final PageController _pageController = PageController(viewportFraction: 0.9, initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final Animatable<double> tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease));
              
              return FadeTransition(opacity: animation.drive(tween), child: child);
            },
            child: Container(
              key: UniqueKey(),
              decoration: BoxDecoration(
                image: widget.movieList[_selectedIndex].posterUrl != "" 
                  ? DecorationImage(
                    image: CachedNetworkImageProvider('$imageUrl/${widget.movieList[_selectedIndex].posterUrl}'),
                    // image: NetworkImage('$imageUrl/${widget.movieList[_selectedIndex].posterUrl}'),
                    fit: BoxFit.cover
                  )
                  : null
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                ),
              ),
            ),
          )
        ),
        Positioned.fill(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.movieList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: widget.movieList[index], mappedGenres: context.read<RootCubit>().state.mappedGenres)));
                    },
                    child: SizedBox(
                      height: 58.0.h,
                      width: 88.0.w,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                        child: Conditional(
                          condition: widget.isLoading,
                          child: (context) => const SkeletonAvatar(),
                          fallback: (context) => Conditional(
                            condition: widget.movieList[index].posterUrl == "" ,
                            child: (context) => Container(
                              color: Colors.black12,
                              width: double.infinity,
                              height: double.infinity,
                              child: const Center(child: Text("No Poster Available", style: TextStyle(fontSize: 12, color: Colors.white)))
                            ),
                            fallback: (context) => CachedNetworkImage(
                              imageUrl: '$imageUrl/${widget.movieList[index].posterUrl}',
                              placeholder:(context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.black12,
                                width: double.infinity,
                                height: double.infinity,
                                child: const Center(child: Text("No Poster Available", style: TextStyle(fontSize: 12, color: Colors.white)))
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ((100.0.w * 0.1) / 2) - 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: index == _selectedIndex 
                        ? MoviePageViewDescription(
                          key: UniqueKey(),
                          movie: widget.movieList[_selectedIndex],
                          isLoading: widget.isLoading
                        )
                        : Container()
                      )
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);

              if(index == widget.movieList.length - 1) {
                widget.onLoadMore?.call();
              }
            },
          ),
        )
      ],
    );
  }
}