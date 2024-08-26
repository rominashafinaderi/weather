import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wheather_app/core/params/ForecastParams.dart';
import 'package:wheather_app/core/utils/date_converter.dart';
import 'package:wheather_app/core/widgets/app_background.dart';
import 'package:wheather_app/core/widgets/dot_loading_widget.dart';
import 'package:wheather_app/features/feature_weather/data/models/for_cast_city_model.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/forecase_days_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/use_cases/get_suggestion_city_usecase.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:wheather_app/features/feature_weather/presentation/widgets/days_wheather_view.dart';
import 'package:wheather_app/locator.dart';

import '../bloc/cw_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController = TextEditingController();
  bool isConnected = true;

  late final StreamSubscription<InternetStatus> listener;

  GetSuggestionCityUseCase getSuggestionCityUseCase =
      GetSuggestionCityUseCase(locator());

  String cityName = "Tehran";
  final PageController _pageController = PageController();
  final textColor =
      AppBackground.isDayTime() ? Colors.grey.shade800.withOpacity(0.85) : Colors.white;
  final divider =
      AppBackground.isDayTime() ? Colors.grey.shade800 : Colors.white;

  @override
  void initState() {
    super.initState();
    _checkNetworkConnection();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  void _checkNetworkConnection() {
    listener = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.03,
            ),

            /// main UI
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) {
                /// rebuild just when CwStatus Changed
                if (previous.cwStatus == current.cwStatus) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state.cwStatus is CwLoading) {
                  return Expanded(
                     child:  Center(
                        child: Column(children: [
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * 0.3),
                          ),
                          SizedBox(height: 80),
                          if (isConnected) ...[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10,),
                                DotLoadingWidget(size: 60,color: textColor,),
                                SizedBox(height: 30,),
                                Text(
                                  '!...درحال بارگذاری',
                                  style: TextStyle(color: textColor,fontFamily: 'AsliMedium',fontSize: 19),
                                )
                              ],
                            )
                          ] else ...[
                            Text(
                              '!...از اتصال اینترنت خود مطمعن شوید',
                              style: TextStyle(color: textColor,fontFamily: 'AsliMedium',fontSize: 19),
                            )
                          ],
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * 0.2),
                          ),
                        ]),
                     )
                      );
                }

                if (state.cwStatus is CwCompleted) {
                  /// cast
                  final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                  final CurrentCityEntity currentCityEntity =
                      cwCompleted.currentCityEntity;

                  /// create params for api call
                  final ForecastParams forecastParams = ForecastParams(
                      currentCityEntity.coord!.lat!,
                      currentCityEntity.coord!.lon!);

                  /// start load Fw event
                  BlocProvider.of<HomeBloc>(context)
                      .add(LoadFwEvent(forecastParams));

                  /// change Times to Hour --5:55 AM/PM----
                  final sunrise = DateConverter.changeDtToDateTimeHour(
                      currentCityEntity.sys!.sunrise,
                      currentCityEntity.timezone);
                  final sunset = DateConverter.changeDtToDateTimeHour(
                      currentCityEntity.sys!.sunset,
                      currentCityEntity.timezone);

                  return Expanded(
                      child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: SizedBox(
                          width: width,
                          height: 470,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Text(
                                  currentCityEntity.name!,
                                  style:
                                      TextStyle(fontSize: 30, color: textColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  currentCityEntity.weather![0].description!,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.blueGrey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: AppBackground.setIconForMain(
                                    currentCityEntity.weather![0].description!),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "${currentCityEntity.main!.temp!.round()}\u00B0",
                                  style:
                                      TextStyle(fontSize: 50, color: textColor),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /// max temp
                                  Column(
                                    children: [
                                      const Text(
                                        "max",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${currentCityEntity.main!.tempMax!.round()}\u00B0",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      )
                                    ],
                                  ),

                                  /// divider
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10,
                                    ),
                                    child: Container(
                                      color: Colors.blueGrey,
                                      width: 2,
                                      height: 40,
                                    ),
                                  ),

                                  /// min temp
                                  Column(
                                    children: [
                                      const Text(
                                        "min",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${currentCityEntity.main!.tempMin!.round()}\u00B0",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      /// divider
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 30, left: 30, bottom: 20),
                        child: Container(
                          color: Colors.blueGrey,
                          height: 2,
                          width: double.infinity,
                        ),
                      ),

                      /// forecast weather 7 days
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SizedBox(
                          width: double.infinity,
                          height: 110,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Center(
                              child: BlocBuilder<HomeBloc, HomeState>(
                                builder: (BuildContext context, state) {
                                  /// show Loading State for Fw
                                  if (state.fwStatus is FwLoading) {
                                    return DotLoadingWidget(
                                      size: 20,
                                      color: textColor,
                                    );
                                  }

                                  /// show Completed State for Fw
                                  if (state.fwStatus is FwCompleted) {
                                    /// casting
                                    final FwCompleted fwCompleted =
                                        state.fwStatus as FwCompleted;
                                    final ForecastDaysEntity
                                        forecastDaysEntity =
                                        fwCompleted.forecastDaysEntity;
                                    final List<Daily> mainDaily =
                                        forecastDaysEntity.daily!;

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 8,
                                      itemBuilder: (
                                        BuildContext context,
                                        int index,
                                      ) {
                                        return DaysWeatherView(
                                          daily: mainDaily[index],
                                        );
                                      },
                                    );
                                  }

                                  /// show Error State for Fw
                                  if (state.fwStatus is FwError) {
                                    final FwError fwError =
                                        state.fwStatus as FwError;
                                    return Center(
                                      child: Text(
                                        ' بارگذاری نشد${currentCityEntity.name!}آب و هوای مربوط به 7 روز آینده شهر ',
                                        style: TextStyle(
                                            color: textColor,
                                            fontFamily: 'AsliMedium',
                                            fontSize: 11.5),
                                      ),
                                    );
                                  }

                                  /// show Default State for Fw
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// divider
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, right: 30, left: 30, bottom: 20),
                        child: Container(
                          color: Colors.blueGrey,
                          height: 2,
                          width: double.infinity,
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      /// last Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "wind speed",
                                style: TextStyle(
                                  fontSize: height * 0.017,
                                  color: Colors.amber,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "${currentCityEntity.wind!.speed!} m/s",
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              color: Colors.white24,
                              height: 30,
                              width: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Text(
                                  "sunrise",
                                  style: TextStyle(
                                    fontSize: height * 0.017,
                                    color: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    sunrise,
                                    style: TextStyle(
                                      fontSize: height * 0.016,
                                      color:  Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              color: Colors.white24,
                              height: 30,
                              width: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Text(
                                  "sunset",
                                  style: TextStyle(
                                    fontSize: height * 0.017,
                                    color: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    sunset,
                                    style: TextStyle(
                                      fontSize: height * 0.016,
                                      color:  Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              color: Colors.white24,
                              height: 30,
                              width: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Text(
                                  "humidity",
                                  style: TextStyle(
                                    fontSize: height * 0.017,
                                    color: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "${currentCityEntity.main!.humidity!}%",
                                    style: TextStyle(
                                      fontSize: height * 0.016,
                                      color:  Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 30,
                      ),

                    ],
                  ));
                }

                if (state.cwStatus is CwError) {
                  return Center(
                      child: Text(
                    'آب و هوای مربوط به شهر مورد نظر یافت نشد',
                    style: TextStyle(
                        color: textColor,
                        fontFamily: 'AsliMedium',
                        fontSize: 13),
                  ));
                }

                return Container();
              },
            ),
          ],
        ),
        Positioned(
          //padding: EdgeInsets.only(
            right: width * 0.03,
            left: width * 0.03,
            top: height * 0.02,
          //),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blue.shade50,

              ),

              child: TypeAheadField(
                loadingBuilder: (context) => DotLoadingWidget(
                  size: 30,
                  color: Colors.black,
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  enabled: isConnected,
                  onSubmitted: (String prefix) {
                    textEditingController.text = prefix;
                    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(prefix));
                  },
                  controller: textEditingController,
                  style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 20,
                    color: textColor,
                  ),
                  cursorColor: Colors.grey,
                  cursorRadius: const Radius.circular(5.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    hintText: isConnected
                        ? "Enter a City..."
                        : "No internet connection",
                    hintStyle: TextStyle(
                      color: textColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                ),
                suggestionsCallback: (String prefix) {
                  if (isConnected) {
                    return getSuggestionCityUseCase(prefix);
                  }
                  return [];
                },
                itemBuilder: (context, dynamic model) {
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(model.name!),
                    subtitle: Text("${model.region!}, ${model.country!}"),
                  );
                },
                onSuggestionSelected: (dynamic model) {
                  textEditingController.text = model.name!;
                  BlocProvider.of<HomeBloc>(context)
                      .add(LoadCwEvent(model.name!));
                },
              ),
            ),
          ),
        ),
      ],
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
