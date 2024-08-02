import 'package:wheather_app/core/resources/data_state.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/repository/weather_repository.dart';

class GetCurrentWeatherUseCase{
final WeatherRepository weatherRepository;
GetCurrentWeatherUseCase(this.weatherRepository);
Future<DataState<CurrentcityEntity>> execute(String cityName){
  return weatherRepository.fetchCurrentWeatherData(cityName);
}
}