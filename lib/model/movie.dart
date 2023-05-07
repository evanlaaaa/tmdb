import 'package:tmdb/model/genre.dart';

class Movie {
  final int id;
  final String title;
  final int year;
  final List<int> genres;
  final String overview;
  final String posterUrl;
  final String backdropUrl;

  List<Genre>? mappedGenres;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,

    this.mappedGenres
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"] ?? 0,
      title: json["original_title"] ?? "",
      year: DateTime.parse(json["release_date"] == "" ||  json["release_date"] == null ? "1970-01-01" : json["release_date"]).year,
      genres: (json["genre_ids"] ?? []).cast<int>(),
      overview: json["overview"] ?? "",
      posterUrl: json["poster_path"] ?? "",
      backdropUrl: json["backdrop_path"] ?? ""
    );
  }

  Movie copyWith({
    int? id,
    String? title,
    int? year,
    List<int>? genres,
    String? overview,
    String? posterUrl,
    String? backdropUrl,
    List<Genre>? mappedGenres,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      genres: genres ?? this.genres,
      overview: overview ?? this.overview,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      mappedGenres: mappedGenres ?? this.mappedGenres
    );
  }
}