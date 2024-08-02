import 'package:wheather_app/core/resources/data_state.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';

abstract class WeatherRepository{
  Future<DataState<CurrentcityEntity>> fetchCurrentWeatherData(String cityName);

}