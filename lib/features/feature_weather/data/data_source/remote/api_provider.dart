import 'package:dio/dio.dart';
import 'package:wheather_app/core/params/ForecastParams.dart';
import 'package:wheather_app/core/utils/constants.dart';

class ApiProvider {
  Dio _dio = Dio();
  var apiKey = Constants.apiKey1;

//current weather api call
  Future<dynamic> callCurrentWeather(cityName) async {
    var response = await _dio
        .get('${Constants.baseUrl}/data/2.5/weather', queryParameters: {
      'q': cityName,
      'appid': apiKey,
      'units': 'metric',
    });
    print(response.data);
    return response;
  }
  /// 7 days forecast api
  Future<dynamic> sendRequest7DaysForcast(ForecastParams params) async {

    var response = await _dio.get(
        "${Constants.baseUrl}/data/2.5/onecall",
        queryParameters: {
          'lat': params.lat,
          'lon': params.lon,
          'exclude': 'minutely,hourly',
          'appid': apiKey,
          'units': 'metric'
        });

    return response;
  }

}
