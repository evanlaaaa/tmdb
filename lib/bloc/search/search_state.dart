part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

extension SearchStatusX on SearchStatus {
  bool get isInitial => this == SearchStatus.initial;
  bool get isLoading => this == SearchStatus.loading;
  bool get isSuccess => this == SearchStatus.success;
  bool get isFailure => this == SearchStatus.failure;
}

class SearchState {
  final SearchStatus status;
  final String currentSearchQuery;
  final List<Movie> searchResult;

  const SearchState({
    this.status = SearchStatus.initial,
    this.currentSearchQuery = "",
    this.searchResult = const [],
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Movie>? searchResult,
    String? currentSearchQuery
  }) {
    return SearchState(
      status: status ?? this.status,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
      searchResult: searchResult ?? this.searchResult,
    );
  }
}
