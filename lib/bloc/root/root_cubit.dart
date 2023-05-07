import 'package:bloc/bloc.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/model/genre.dart';
import 'package:tmdb/utils/api_service.dart';

part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit() : super(const RootState());

  void onGenreResourceRequested() async {
    emit(state.copyWith(status: RootStatus.loading));

    await ApiService().httpGet<Genre, List<Genre>>(
      "/genre/movie/list",
      param: {
        "api_key": apiKey,
        "language": "en-US"
      },
      parser: Genre.fromJson,
      dataKey: "genres"
    )
    .whenComplete(() { if(isClosed) return; })
    .then((wrapper) {
      emit(
        state.copyWith(
          status: RootStatus.success,
          genreList: wrapper.data,
          mappedGenres: Genre.convertToMap(wrapper.data)
        )
      );
    })
    .catchError((e) {
      emit(state.copyWith(status: RootStatus.failure));
    });
  }
}
