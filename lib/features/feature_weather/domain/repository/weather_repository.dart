import 'package:wheather_app/core/params/ForecastParams.dart';
import 'package:wheather_app/core/resources/data_state.dart';
import 'package:wheather_app/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/forecase_days_entity.dart';


abstract class WeatherRepository{

  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);

}