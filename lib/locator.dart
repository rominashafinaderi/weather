import 'package:get_it/get_it.dart';
import 'package:wheather_app/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:wheather_app/features/feature_weather/data/repository/weather_repository_impl.dart';
import 'package:wheather_app/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:wheather_app/features/feature_weather/domain/use_cases/get_current_weather_use_case.dart';
import 'package:wheather_app/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/home_bloc.dart';

GetIt locator = GetIt.instance;
Future<void> setup() async {
  // provide کردن ApiProvider
  locator.registerSingleton<ApiProvider>(ApiProvider());

  // repository
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));

  // use cases
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));
  locator.registerSingleton<GetForecastWeatherUseCase>(GetForecastWeatherUseCase(locator()));

  // BLoC
  locator.registerSingleton<HomeBloc>(HomeBloc(locator(), locator()));
}

