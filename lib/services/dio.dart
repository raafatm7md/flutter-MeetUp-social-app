import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'http://13.38.95.244/api/',
        receiveDataWhenStatusError: true,
        ));
  }

  static Future<Response> getData(
      {required String url,
      Map<String, dynamic>? query,
      String? token}) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'access_token': token,
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic>? data,
      String? token}) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'access_token': token,
    };
    return await dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData(
      {required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic>? data,
      String? token}) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'access_token': token,
    };
    return await dio.put(url, queryParameters: query, data: data);
  }
}
