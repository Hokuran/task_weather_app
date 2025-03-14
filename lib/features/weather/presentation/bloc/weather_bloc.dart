import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;

  WeatherBloc({required this.getWeather}) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
    on<RefreshWeather>(_onRefreshWeather);
  }

  Future<void> _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    final result = await getWeather();
    result.fold(
      (failure) => emit(WeatherError('Failed to fetch weather data')),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }

  Future<void> _onRefreshWeather(RefreshWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    final result = await getWeather();
    result.fold(
      (failure) => emit(WeatherError('Failed to refresh weather data')),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }
}
