import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/model/movie.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:tmdb/utils/api_service.dart';
import 'package:tmdb/utils/shared_pref.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchRequested>(_onSearchRequested, transformer: debounce(const Duration(milliseconds: 700)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }


  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));

    await ApiService().httpGet<Movie, List<Movie>>(
      "/search/movie", 
      param: {
        "api_key": apiKey,
        "language": "en-US",
        "query": event.query
      },
      parser: Movie.fromJson,
      dataKey: "results"
    )
    .whenComplete(() { if(isClosed) return; })
    .then((wrapper) async {
      List<String> history = SharedPreferencesService.readHistory();
      
      if(event.query.isNotEmpty && !history.contains(event.query)) {
        if(history.length >= 10) {
          history.removeLast();
        } 
        history.insert(0, event.query);

        await SharedPreferencesService.writeHistory(history);
      }

      emit(
        state.copyWith(
          status: SearchStatus.success,
          searchResult: wrapper.data,
        )
      );
    })
    .catchError((e) {
      emit(state.copyWith(status: SearchStatus.failure, currentSearchQuery: event.query));
    });
  }
}
