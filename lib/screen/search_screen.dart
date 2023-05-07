import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tmdb/bloc/root/root_cubit.dart';
import 'package:tmdb/bloc/search/search_bloc.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/screen/detail_screen.dart';
import 'package:tmdb/screen/error_screen.dart';
import 'package:tmdb/utils/shared_pref.dart';
import 'package:tmdb/widget/conditional.dart';
import 'package:tmdb/widget/search_bar.dart';
import 'package:tmdb/widget/spacer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  late final SearchBloc _searchBloc;

  @override
  void initState() {
    _searchBloc = SearchBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SearchBloc, SearchState>(
        bloc: _searchBloc,
        builder: (context, state) {
          return Conditional(
            condition: state.status.isFailure,
            child: (context) => ErrorScreen(onRefresh: () async {
              _searchBloc.add(SearchRequested(query: state.currentSearchQuery));
            }),
            fallback: (context) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBar(
                        controller: _textController,
                        onChanged: (value) {
                          _searchBloc.add(SearchRequested(query: value));
                        },
                      ),
                      const VerticalSpacer.large(),
                      Conditional(
                        condition: _textController.text.isEmpty, 
                        child: (context) => const Text("Search History", style: TextStyle(fontSize: 16))
                      ),
                      const VerticalSpacer.medium(),
                      Conditional(
                        condition:_textController.text.isEmpty,
                        child: (context) => Conditional(
                          condition: SharedPreferencesService.readHistory().isEmpty,
                          child: (context) => const SizedBox(
                            height: 150, 
                            child: Center(
                              child: Text("Oops, there is no history here")
                            )
                          ),
                          fallback: (context) => ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: ListTile.divideTiles(
                              context: context,
                              tiles: SharedPreferencesService.readHistory().map((history) {
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(history, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary)), 
                                    onTap: () {
                                    _textController.text = history;
                                    _searchBloc.add(SearchRequested(query: history));
                                  }
                                );
                              }).toList()
                            ).toList()
                          ),
                        ),
                        fallback: (context) => Conditional(
                          condition: state.status.isLoading,
                          child: (context) => ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.transparent,
                                height: 50,
                                width: double.infinity,
                                child: Row(
                                  children: const [
                                    SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                        width: 50,
                                        height: 50
                                      ),
                                    ),
                                    HorizontalSpacer.medium(),
                                    Expanded(
                                      child: SkeletonLine(),
                                    )
                                  ],
                                )
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                          ),
                          fallback: (context) => Conditional(
                            condition: state.searchResult.isEmpty,
                            child: (context) => const SizedBox(
                              height: 150, 
                              child: Center(
                                child: Text("Empty result with current query")
                              )
                            ),
                            fallback: (context) => ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: state.searchResult.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: state.searchResult[index], mappedGenres: context.read<RootCubit>().state.mappedGenres)));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 50,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Conditional(
                                          condition: state.searchResult[index].posterUrl.isEmpty,
                                          child: (context) => Container(
                                            color: Colors.black12,
                                            width: 50,
                                            height: double.infinity,
                                            child: const Center(child: Text("No Poster Available", style: TextStyle(fontSize: 12, color: Color(0xFF808080))))
                                          ),
                                          fallback: (context) => CachedNetworkImage(imageUrl: '$imageUrl/${state.searchResult[index].posterUrl}', width: 50, height: 50, fit: BoxFit.cover),
                                        ),
                                        const HorizontalSpacer.medium(),
                                        Flexible(child: Text(state.searchResult[index].title))
                                      ],
                                    )
                                  ),
                                );
                              }, 
                              separatorBuilder: (BuildContext context, int index) {
                                return const Divider();
                              },
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }
}