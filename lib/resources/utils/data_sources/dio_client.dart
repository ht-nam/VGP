import 'package:dio/dio.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/data_sources/local.dart';
import 'package:vgp/models/exceptions/api_exception.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(validateStatus: (status) => true));

  DioClient() {
    _dio.interceptors.add(_authInterceptor());
  }

  // Add headers
  Interceptor _interceptors() {
    return InterceptorsWrapper(onRequest: (request, handler) async {
      request.headers
          .addAll({"Content-Type": 'application/x-www-form-urlencoded'});
      return handler.next(request);
    });
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(onRequest: (request, handler) async {
      final token = (await SharedPre.instance)
          .getString(SharedPrefsConstants.ACCESS_TOKEN_KEY);
      request.headers.addAll(
          {"Authorization": 'Bearer $token', "Accept": 'application/json'});
      return handler.next(request);
    });
  }

  // Future<Response<Map<String, dynamic>>> get(String path, {Map<String, dynamic>? queryParameters}) async {
  //   try {
  //     Response<Map<String, dynamic>> response = await _dio.get(path, queryParameters: queryParameters);
  //     return response;
  //   } on Exception catch (exception) {
  //     throw handleError(exception);
  //   }
  // }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response =
          await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on Exception catch (exception) {
      print(exception.toString());
      throw handleError(exception);
    }
  }

  Future<Response<Map<String, dynamic>>> postLogin(String path,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    _dio.options.headers.remove(Headers.contentTypeHeader);
    _dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    try {
      Response<Map<String, dynamic>> response =
          await _dio.post(path, queryParameters: queryParameters, data: data);
      return response;
    } on Exception catch (exception) {
      throw handleError(exception);
    }
  }

  Future<Response<Map<String, dynamic>>> post(String path,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    _dio.options.headers.remove(Headers.contentTypeHeader);
    _dio.options.headers['Content-Type'] = 'application/json';
    try {
      Response<Map<String, dynamic>> response =
          await _dio.post(path, queryParameters: queryParameters, data: data);
      return response;
    } on Exception catch (exception) {
      throw handleError(exception);
    }
  }

  Future<Response<Map<String, dynamic>>> put(String path,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    _dio.options.headers.remove(Headers.contentTypeHeader);
    _dio.options.headers['Content-Type'] = 'application/json';
    // final token = await SharedPre.getItem("access_token");
    // _dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      Response<Map<String, dynamic>> response =
          await _dio.put(path, queryParameters: queryParameters, data: data);
      return response;
    } on Exception catch (exception) {
      throw handleError(exception);
    }
  }

  Future<Response<Map<String, dynamic>>> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    _dio.options.headers.remove(Headers.contentTypeHeader);
    _dio.options.headers['Content-Type'] = 'application/json';
    try {
      Response<Map<String, dynamic>> response =
          await _dio.delete(path, queryParameters: queryParameters);
      return response;
    } on Exception catch (exception) {
      throw handleError(exception);
    }
  }

  ApiException handleError(Exception error) {
    String errorDescription = "";
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioExceptionType.unknown:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioExceptionType.connectionError:
          errorDescription = "Connection to API server failed";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioExceptionType.badResponse:
          errorDescription =
              "Received invalid status code: ${error.response?.statusCode}";
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioExceptionType.badCertificate:
          errorDescription = "Bad certificate";
          break;
        default:
          errorDescription = "Unexpected error occurred";
          break;
      }
    } else {
      errorDescription = "Unexpected error occurred";
    }

    return ApiException(message: errorDescription);
  }
}
