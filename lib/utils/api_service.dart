import 'package:dio/dio.dart';
import 'package:tmdb/model/data_wrapper.dart';
import 'package:tmdb/model/response.dart';

enum HttpMethod {
  get('GET'), post('POST'), put('PUT'), patch('PATCH'), delete('DELETE');
  
  final String method;
  const HttpMethod(this.method);
}

class ApiService extends ApiServiceFoundation {
  factory ApiService() => _singleton;

  factory ApiService.initial(String baseUrl) {
    _singleton.dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 2000),
        receiveTimeout: const Duration(milliseconds: 2000),
        contentType: Headers.jsonContentType,
      )
    );

    return _singleton;
  }

  static final ApiService _singleton = ApiService._internal();

  ApiService._internal();
}

abstract class ApiServiceFoundation  {
  Dio? dio;
  CancelToken cancelToken = CancelToken();

  Future<DataWrapper<P, F>> httpGet<P, F>(
    String endpoint,
    {
      Map<String, dynamic>? param,
      P Function(Map<String, dynamic>)? parser,
      void Function(int, int)? onSendProgression,
      void Function(int, int)? onReceiveProgression,

      void Function(HttpResponse)? onCancel,

      String? dataKey
    }
  ) async {
    HttpResponse response = await request(
      endpoint,
      httpMethod: HttpMethod.get,
      param: param,
      onReceiveProgression: onReceiveProgression,
      onSendProgression: onSendProgression,
    );

    DataWrapper<P, F> dataModel;

    if(parser != null) {
      dataModel = DataWrapper<P, F>.fromJsonParser(response.data, parser, dataKey: dataKey);
    }
    else {
      dataModel = DataWrapper<P, F>.fromJson(response.data, dataKey: dataKey);
    }

    return _resultMapping(
      response, 
      onSuccess: () => dataModel, 
      onError: () => throw (dataModel)
    );
  }

  DataWrapper<P, F> _resultMapping<P, F>(
    HttpResponse response, 
    {
      required DataWrapper<P, F> Function() onSuccess, 
      required DataWrapper<P, F> Function() onError
    }
  ) {
    switch(response.httpCode) {
      case 200: return onSuccess();
      case 401: return onError();
      case 404: return onError();
      default: return onError();
    }
  }

  void cancelOngoingRequest() {
    cancelToken.cancel();
    cancelToken = CancelToken();
  }

  Future<HttpResponse> request<P, F>(
    String endpoint,
    { 
      required HttpMethod httpMethod,
      Map<String, dynamic>? param,
      dynamic data,

      void Function(int, int)? onSendProgression,
      void Function(int, int)? onReceiveProgression
    }
  ) async {
    try {
      dio!.options.method = httpMethod.method;

      Response response = await dio!.request(
        endpoint, 
        queryParameters: param,
        data: data,
        onSendProgress: onSendProgression,
        onReceiveProgress: onReceiveProgression,
        cancelToken: cancelToken
      );

      return HttpResponse(
        httpCode: 200,
        httpMessage: response.data["status_message"] ?? "Success", 
        data: response.data
      );
    } on DioError catch (e) {
      if(e.type == DioErrorType.cancel) {
        return const HttpResponse(
          httpCode: 0,
          httpMessage: "Request Cancelled",
          data: {}
        );
      }

      bool isTimeout = [DioErrorType.connectionTimeout, DioErrorType.receiveTimeout, DioErrorType.sendTimeout].contains(e.type);

      if(isTimeout || e.response?.statusCode == 408) {
        return HttpResponse(
          data: e.response?.data, 
          httpMessage: e.message ?? "Request Timeout",
          httpCode: 408
        );
      }

      switch (e.response?.statusCode) {
        case 401:
          return HttpResponse(
            data: e.response?.data, 
            httpMessage: e.response?.data["status_message"] ?? "No Auth",
            httpCode: 401
          );

        case 404:
          return HttpResponse(
            data: e.response?.data, 
            httpMessage: e.response?.data["status_message"] ?? "Not Found",
            httpCode: 404
          );

        default:
          return HttpResponse(
            data: e.response?.data, 
            httpMessage: e.response?.data["status_message"] ?? "Unknown Error",
            httpCode: 500
          );
      }
    }
  }
}