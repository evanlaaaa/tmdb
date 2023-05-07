class HttpResponse {
  final Map<String, dynamic> data;
  final int httpCode;
  final String httpMessage;

  const HttpResponse({
    required this.data,
    required this.httpCode,
    required this.httpMessage,
  });
}