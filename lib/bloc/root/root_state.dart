part of 'root_cubit.dart';

enum RootStatus { initial, loading, success, failure }

extension RootStatusX on RootStatus {
  bool get isInitial => this == RootStatus.initial;
  bool get isLoading => this == RootStatus.loading;
  bool get isSuccess => this == RootStatus.success;
  bool get isFailure => this == RootStatus.failure;
}

class RootState {
  final RootStatus status;
  final List<Genre> genreList;
  final Map<int, String> mappedGenres;

  const RootState({
    this.status = RootStatus.initial,
    this.genreList = const [],
    this.mappedGenres = const {}
  });

  RootState copyWith({
    RootStatus? status,
    List<Genre>? genreList,
    Map<int, String>? mappedGenres
  }) {
    return RootState(
      status: status ?? this.status,
      genreList: genreList ?? this.genreList,
      mappedGenres: mappedGenres ?? this.mappedGenres
    );
  }
}
