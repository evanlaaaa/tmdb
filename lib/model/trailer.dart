class Trailer {
  final Site site;
  final String key;

  const Trailer({
    required this.site,
    required this.key
  });

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      key: json["key"] ?? "",
      site: Site.values.byName((json["site"] ?? "").toLowerCase())
    );
  }
}

enum Site {
  youtube, vimeo
}

extension SiteX on Site {
  bool get isYoutube => this == Site.youtube;
  bool get isVimeo => this == Site.vimeo;
}