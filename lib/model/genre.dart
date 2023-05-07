class Genre {
  final int id;
  final String name;

  const Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json["id"] ?? 0,
      name: json["name"] ?? ""
    );
  }

  static Map<int, String> convertToMap(List<Genre> genres) {
    return { for (var g in genres) g.id : g.name };
  }
}