
import 'package:wheather_app/core/use_case/use_case.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/forecase_days_entity.dart';

import '../../../../core/params/ForecastParams.dart';
import '../../../../core/resources/data_state.dart';

import '../repository/weather_repository.dart';

class GetForecastWeatherUseCase implements UseCase<DataState<ForecastDaysEntity>, ForecastParams>{
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }

}