import 'package:bloc/bloc.dart';
import 'package:tmdb/constant/string.dart';
import 'package:tmdb/model/trailer.dart';
import 'package:tmdb/utils/api_service.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(const DetailState());

  void onTrailerRequested(int movieId) async {
    emit(state.copyWith(status: DetailStatus.loading));

    await ApiService().httpGet<Trailer, List<Trailer>>(
      "/movie/$movieId/videos",
      param: {
        "api_key": apiKey,
        "language": "en-US"
      },
      parser: Trailer.fromJson,
      dataKey: "results"
    )
    .whenComplete(() { if(isClosed) return; })
    .then((wrapper) {
      emit(
        state.copyWith(
          status: DetailStatus.success,
          trailers: wrapper.data
        )
      );
    })
    .catchError((e) {
      emit(state.copyWith(status: DetailStatus.failure));
    });
  }
}
