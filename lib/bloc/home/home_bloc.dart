import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/utils/api_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeMovieFetchRequested>(_onFetchRequested);
    on<HomeMovieFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFetchRequested(
    HomeMovieFetchRequested event,
    Emitter<HomeState> emit
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    await ApiService().httpGet(
      "/discover/movie", 
      param: {
        "api_key": apiKey,
        "language": "en-US",
        "sort_by": "release_date.desc",
        "page": event.page,
        "with_genres": event.selectedGenreIds.join(",")
      },
      parser: Movie.fromJson,
      dataKey: "results"
    )
    .whenComplete(() { if(isClosed) return; })
    .then((wrapper) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          movies: [
            ...state.movies,
            ...wrapper.data
          ],
          currentPage: event.page
        )
      );
    })
    .catchError((e) {
      emit(state.copyWith(status: HomeStatus.failure));
    });
  }

  Future<void> _onFilterChanged(
    HomeMovieFilterChanged event,
    Emitter<HomeState> emit
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    await ApiService().httpGet<Movie, List<Movie>>(
      "/discover/movie", 
      param: {
        "api_key": apiKey,
        "language": "en-US",
        "sort_by": "release_date.desc",
        "with_genres": event.selectedGenreIds.join(",")
      },
      parser: Movie.fromJson,
      dataKey: "results"
    )
    .whenComplete(() { if(isClosed) return; })
    .then((wrapper) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          movies: wrapper.data,
          currentPage: 1
        )
      );
    })
    .catchError((e) {
      emit(state.copyWith(status: HomeStatus.failure));
    });
  }
}
