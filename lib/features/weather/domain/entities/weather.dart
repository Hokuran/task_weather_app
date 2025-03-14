import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final String cityName;

  const Weather({
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.cityName,
  });

  @override
  List<Object> get props =>
      [temperature, condition, icon, humidity, windSpeed, cityName];
}
