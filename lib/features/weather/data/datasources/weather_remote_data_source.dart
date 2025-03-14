import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  /// Fetches weather data from OpenWeatherMap API
  /// Throws a [ServerException] for all error codes
  Future<WeatherModel> getWeather();
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;
  final String apiKey =
      '571a7570312fe77c7bd7e5aecfa7ac07'; // Put with your API key
  //final String city = 'Kyiv'; Default city, could be made configurable

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getWeather() async {
    final response = await client.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=49.58&lon=34.55&appid=$apiKey&units=metric'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
