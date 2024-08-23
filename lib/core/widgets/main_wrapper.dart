import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui'; // برای استفاده از ImageFilter
import 'package:wheather_app/core/widgets/app_background.dart';
import 'package:wheather_app/features/feature_bookmark/presentation/screens/book_mark_screen.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:wheather_app/features/feature_weather/presentation/screens/home_screen.dart';
import 'package:wheather_app/locator.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidget = [HomeScreen(), BookMarkScreen()];
    var height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => locator<HomeBloc>(),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true, // صفحه بره زیر Bottom Navigation Bar
          body: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AppBackground.getBackGroundImage(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0), // تنظیم مقدار بلور
                child: Container(
                ),
              ),
              HomeScreen()
            ],
          ),
        ),
      ),
    );
  }
}
