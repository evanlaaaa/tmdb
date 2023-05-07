import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tmdb/bloc/home/home_bloc.dart';
import 'package:tmdb/bloc/root/root_cubit.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/screen/error_screen.dart';
import 'package:tmdb/widget/filter_drawer.dart';
import 'package:tmdb/widget/movie_grid_card.dart';
import 'package:tmdb/widget/movie_pageview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  List<int> selectedGenreIds = [];
  bool isGridView = true;

  late final HomeBloc _homeBloc;
  final PagingController<int, Movie> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    _homeBloc = HomeBloc()..add(HomeMovieFetchRequested(page: 1));
    _pagingController.addPageRequestListener((pageKey) {
      if(pageKey != 0) {
        _homeBloc.add(HomeMovieFetchRequested(page: pageKey, selectedGenreIds: selectedGenreIds));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: FilterDrawer(
        selectedGenreIds: selectedGenreIds,
        genreList: context.read<RootCubit>().state.genreList,
        onFilterApplied: (ids) {
          selectedGenreIds = ids;
          _pagingController.itemList = [];
          _homeBloc.add(HomeMovieFilterChanged(selectedGenreIds: ids));
        },
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: _homeBloc,
        listener: (context, state) {
          if(state.status.isSuccess) {
            _pagingController.itemList = null;
            _pagingController.appendPage(state.movies, state.currentPage + 1);
          }
        },
        builder: (context, state) {
          return state.status.isFailure
          ? ErrorScreen(
            onRefresh: () async {
              _homeBloc.add(HomeMovieFetchRequested(page: 1));
            },
          )
          : CustomScrollView(
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            slivers: [
              SliverAppBar.medium(
                automaticallyImplyLeading: false,
                actions: [Container()],
                backgroundColor: const Color(0xFFf6f5fa),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Home"),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: const Icon(Icons.filter_alt_outlined, size: 20)
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isGridView = !isGridView;
                            });
                          },
                          child: Icon(isGridView ? Icons.view_carousel_outlined : Icons.grid_view, size: 20)
                        )
                      ],
                    )
                  ],
                ),
              ),
              isGridView
                ? state.status.isLoading 
                  ? SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 5,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: state.movies.length,
                        itemBuilder: (context, index) {
                          return MovieGridCard(movie: state.movies[index], isLoading: state.status.isLoading);
                        },
                      )
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: PagedSliverGrid<int, Movie>(
                        pagingController: _pagingController,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 5,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ), 
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, item, index) {
                            return MovieGridCard(movie: item, isLoading: state.status.isLoading);
                          }
                        ), 
                      )
                    )
                : SliverFillRemaining(
                    child: MoviePageView(
                      movieList: state.movies, 
                      isLoading: state.status.isLoading,
                      onLoadMore: () {
                        _homeBloc.add(HomeMovieFetchRequested(page: state.currentPage + 1));
                      }
                    )
                  )
            ]
          );
        },
      )
    );
  }
}
