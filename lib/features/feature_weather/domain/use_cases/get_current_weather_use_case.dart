import 'package:wheather_app/core/resources/data_state.dart';
import 'package:wheather_app/core/use_case/use_case.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/repository/weather_repository.dart';

class GetCurrentWeatherUseCase extends UseCase<DataState<CurrentcityEntity>, String>{
  final WeatherRepository weatherRepository;
  GetCurrentWeatherUseCase(this.weatherRepository);

  @override
  Future<DataState<CurrentcityEntity>> call(String param) {
    return weatherRepository.fetchCurrentWeatherData(param);
  }

}