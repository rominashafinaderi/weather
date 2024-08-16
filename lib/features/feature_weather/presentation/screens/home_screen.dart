import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wheather_app/core/params/ForecastParams.dart';
import 'package:wheather_app/core/widgets/app_background.dart';
import 'package:wheather_app/core/widgets/dot_loading_widget.dart';
import 'package:wheather_app/features/feature_weather/data/models/for_cast_city_model.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/forecase_days_entity.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:wheather_app/features/feature_weather/presentation/widgets/days_wheather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String cityName = 'tehran';
  final PageController _pageController = PageController();

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
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current){
            /// rebuild just when CwStatus Changed
            if(previous.cwStatus == current.cwStatus){
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state.cwStatus is CwLoading) {
              return Expanded(child: DotLoadingWidget());
            }
            if (state.cwStatus is CwError) {
              final CwError error = state.cwStatus as CwError;
              print('Error: ${error.message}');
              return Center(
                child: Text('Error: ${error.message}'),
              );
            }

            if (state.cwStatus is CwCompleted) {
              //cast
              final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
              final CurrentcityEntity currentCityEntity = cwCompleted.currentcityEntity;

              /// create params for api call
              final ForecastParams forecastParams = ForecastParams(currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!);

              /// start load Fw event
              BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(forecastParams));

              return Expanded(
                  child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.2),
                    child: SizedBox(
                      width: width,
                      height: 400,
                      child: PageView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        allowImplicitScrolling: true,
                        controller: _pageController,
                        itemCount: 2,
                        itemBuilder: (context, position) {
                          if (position == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    currentcityEntity.name ?? '',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    currentcityEntity.weather![0].description ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: AppBackground.setIconForMain(
                                      currentcityEntity
                                              .weather![0].description ??
                                          '',
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    '${currentcityEntity.main!.temp!.round()}\u00B0',
                                    style: TextStyle(
                                        fontSize: 50, color: Colors.white),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //max temp
                                    Column(
                                      children: [
                                        Text(
                                          'max',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${currentcityEntity.main!.tempMax!.round()}\u00B0 ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    //divider
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        color: Colors.grey,
                                        width: 2,
                                        height: 40,
                                      ),
                                    ),
                                    //min temp
                                    Column(
                                      children: [
                                        Text(
                                          'min',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${currentcityEntity.main!.tempMin!.round()}\u00B0 ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return Container(
                              color: Colors.amber,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // pageView Indicator
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      // PageController
                      count: 2,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        spacing: 5,
                        activeDotColor: Colors.white,
                      ),
                      // your preferred effect
                      onDotClicked: (index) => _pageController.animateToPage(
                        index,
                        duration: const Duration(microseconds: 500),
                        curve: Curves.bounceOut,
                      ),
                    ),
                  ),

                  /// divider
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      color: Colors.white24,
                      height: 2,
                      width: double.infinity,
                    ),
                  ),

                  /// forecast weather 7 days
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Center(
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (BuildContext context, state) {
                              /// show Loading State for Fw
                              if (state.fwStatus is FwLoading) {
                                return const DotLoadingWidget();
                              }

                              /// show Completed State for Fw
                              if (state.fwStatus is FwCompleted) {
                                /// casting
                                final FwCompleted fwCompleted =
                                    state.fwStatus as FwCompleted;
                                final ForecastDaysEntity forecastDaysEntity =
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
                                  child: Text(fwError.message!),
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
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      color: Colors.white24,
                      height: 2,
                      width: double.infinity,
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                ],
              ));
            }
            return Container();
          },
        ),
      ],
    ));
  }
}
