class DataWrapper<P, F> {
  final int? statusCode;
  final String? statusMessage;

  final F data;

  final int? page;
  final int? totalResults;
  final int? totalPages;

  DataWrapper({
    required this.data,
    this.statusCode,
    this.statusMessage,
    this.page,
    this.totalPages,
    this.totalResults
  });

  factory DataWrapper.fromJsonParser(Map<String, dynamic> json, P Function(Map<String, dynamic>) parser, {String? dataKey = "results"}) {
    F data;

    if (json[dataKey] is List) {
      if (P == F) {
        // this happened when the results is in List, but defined a single object parsing format
        // so this fallback will just convert the first object in the list
        data = parser((json[dataKey] as List).first) as F;
      } else {
        data = (json[dataKey] as List).map((e) => parser(e)).toList() as F;
      }
    } else {
      Map<String, dynamic> d = json[dataKey] ?? {};
      if(d.isEmpty) {
        try {
          data = parser(d) as F;
        }
        catch(e) {
          data = [parser(d)] as F;
        }
      }
      else {
        data = parser(d) as F;
      }

    }

    return DataWrapper<P, F>(
      statusCode: json["status_code"],
      statusMessage: json["status_message"],
      data: data,
      page: json["page"],
      totalPages: json["total_pages"],
      totalResults: json["total_results"]
    );
  }

  factory DataWrapper.fromJson(Map<String, dynamic> json, { String? dataKey = "results" }) {
    return DataWrapper<P, F>(
      statusCode: json["status_code"],
      statusMessage: json["status_message"],
      page: json["page"],
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
      data: json[dataKey]
    );
  }

  DataWrapper<P, F> copyWith({
    int? statusCode,
    String? statusMessage,
    F? data,
    int? page,
    int? totalResults,
    int? totalPages
  }) {
    return DataWrapper<P, F>(
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults
    );
  }

  bool get isOk => (this.statusCode ?? 200) == 200;
}