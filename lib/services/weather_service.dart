import 'package:dio/dio.dart';
import '../models/weather.dart';

Future<Weather> WeatherService(
    {required String lat, required String long}) async {
  String url =
      'https://api.weatherapi.com/v1/forecast.json?key=\$weatherAPIKey&q=${lat},${long}';
  final dio = Dio();
  final response = await dio.get(url);
  return Weather.fromJson(response.data);
}
