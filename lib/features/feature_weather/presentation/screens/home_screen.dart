import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wheather_app/core/params/ForecastParams.dart';
import 'package:wheather_app/core/widgets/app_background.dart';
import 'package:wheather_app/core/widgets/dot_loading_widget.dart';
import 'package:wheather_app/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/use_cases/get_suggestion_city_usecase.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:wheather_app/locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  GetSuggestionCityUseCase getSuggestionCityUseCase =
  GetSuggestionCityUseCase(locator());
  final String cityName = 'tehran';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: TypeAheadField(
                    loadingBuilder: (context) => DotLoadingWidget(
                      size: 20,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      onSubmitted: (String prefix) {
                        textEditingController.text = prefix;
                        BlocProvider.of<HomeBloc>(context)
                            .add(LoadCwEvent(prefix));
                      },
                      controller: textEditingController,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        hintText: "Enter a City...",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    suggestionsCallback: (String prefix) {
                      return getSuggestionCityUseCase(prefix);
                    },
                    itemBuilder: (context, Data model) {
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(model.name!),
                        subtitle: Text("${model.region!}, ${model.country!}"),
                      );
                    },
                    onSuggestionSelected: (Data model) {
                      textEditingController.text = model.name!;
                      BlocProvider.of<HomeBloc>(context)
                          .add(LoadCwEvent(model.name!));
                    }),
              ),
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) {
                  if (previous.cwStatus == current.cwStatus) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state.cwStatus is CwLoading) {
                    return DotLoadingWidget(size: 40);
                  }
                  if (state.cwStatus is CwError) {
                    final CwError error = state.cwStatus as CwError;
                    print('Error: ${error.message}');
                    return Center(
                      child: Text('Error: ${error.message}'),
                    );
                  }

                  if (state.cwStatus is CwCompleted) {
                    final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                    final CurrentCityEntity currentCityEntity =
                        cwCompleted.currentCityEntity;

                    final ForecastParams forecastParams = ForecastParams(
                        currentCityEntity.coord!.lat!,
                        currentCityEntity.coord!.lon!);

                    BlocProvider.of<HomeBloc>(context)
                        .add(LoadFwEvent(forecastParams));

                    return Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              currentCityEntity.name ?? '',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              currentCityEntity.weather![0].description ?? '',
                              style: TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: AppBackground.setIconForMain(
                                currentCityEntity.weather![0].description ?? '',
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              '${currentCityEntity.main!.temp!.round()}\u00B0',
                              style: TextStyle(fontSize: 50, color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'max',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${currentCityEntity.main!.tempMax!.round()}\u00B0 ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  color: Colors.grey,
                                  width: 2,
                                  height: 40,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'min',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${currentCityEntity.main!.tempMin!.round()}\u00B0 ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ));
  }
}
