part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

extension HomeStatusX on HomeStatus {
  bool get isInitial => this == HomeStatus.initial;
  bool get isLoading => this == HomeStatus.loading;
  bool get isSuccess => this == HomeStatus.success;
  bool get isFailure => this == HomeStatus.failure;
}

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.movies = const [],
    this.filterGenreIds = const [],
    this.genreMap = const {},
    this.currentPage = 1
  });

  final HomeStatus status;
  final List<Movie> movies;
  final List<int> filterGenreIds;
  final Map<int, String> genreMap;
  final int currentPage;

  HomeState copyWith({
    HomeStatus? status,
    List<Movie>? movies,
    List<int>? filterGenreIds,
    Map<int, String>? genreMap,
    int? currentPage
  }) {
    return HomeState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      filterGenreIds: filterGenreIds ?? this.filterGenreIds,
      genreMap: genreMap ?? this.genreMap,
      currentPage: currentPage ?? this.currentPage
    );
  }
}
