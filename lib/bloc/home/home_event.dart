part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeMovieFetchRequested extends HomeEvent {
  final int page;
  final List<int> selectedGenreIds;

  HomeMovieFetchRequested({
    required this.page,
    this.selectedGenreIds = const []
  });
}

class HomeMovieFilterChanged extends HomeEvent {
  final List<int> selectedGenreIds;

  HomeMovieFilterChanged({
    this.selectedGenreIds = const []
  });
}
