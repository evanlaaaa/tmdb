part of 'detail_cubit.dart';

enum DetailStatus { initial, loading, success, failure }

extension DetailStatusX on DetailStatus {
  bool get isInitial => this == DetailStatus.initial;
  bool get isLoading => this == DetailStatus.loading;
  bool get isSuccess => this == DetailStatus.success;
  bool get isFailure => this == DetailStatus.failure;
}

class DetailState {
  final DetailStatus status;
  final List<Trailer> trailers;

  const DetailState({
    this.status = DetailStatus.loading,
    this.trailers = const [],
  });

  DetailState copyWith({
    DetailStatus? status,
    List<Trailer>? trailers
  }) {
    return DetailState(
      status: status ?? this.status,
      trailers: trailers ?? this.trailers 
    );
  }
}
