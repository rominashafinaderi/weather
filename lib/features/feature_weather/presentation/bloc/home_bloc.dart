import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheather_app/core/resources/data_state.dart';
import 'package:wheather_app/features/feature_weather/domain/use_cases/get_current_weather_use_case.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/cw_status.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;

  HomeBloc(this.getCurrentWeatherUseCase)
      : super(HomeState(cwStatus: CwLoading())) {
    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));
      DataState dataState = await getCurrentWeatherUseCase(event.cityName);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }
    });
  }
}
