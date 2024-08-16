import 'package:dio/dio.dart';
import 'package:wheather_app/core/params/ForecastParams.dart';
import 'package:wheather_app/core/resources/data_state.dart';
import 'package:wheather_app/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:wheather_app/features/feature_weather/data/models/current_city_model.dart';
import 'package:wheather_app/features/feature_weather/data/models/for_cast_city_model.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/forecase_days_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  ApiProvider apiProvider;

  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentcityEntity>> fetchCurrentWeatherData(
      String cityName) async {
    try {
      print('Attempting to fetch weather data for $cityName');
      Response response = await apiProvider.callCurrentWeather(cityName);
      print('Response received with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Success! Parsing data...');
        CurrentcityEntity currentCityEntity =
        CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityEntity);
      } else {
        print('Failed with status code: ${response.statusCode}');
        return DataFailed('some thing went wrong!.. try again!');
      }
    } catch (e) {
      print('Error occurred: $e');
      return DataFailed('please check your connection..');
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params) async {
    try{
      Response response = await apiProvider.sendRequest7DaysForcast(params);

      if(response.statusCode == 200){
        ForecastDaysEntity forecastDaysEntity = ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      }else{
        return const DataFailed("Something Went Wrong. try again...");
      }
    }catch(e){
      print(e.toString());
      return const DataFailed("please check your connection...");
    }
  }
}
