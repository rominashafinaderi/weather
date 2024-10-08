
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wheather_app/core/widgets/dot_loading_widget.dart';
import 'package:wheather_app/core/widgets/main_wrapper.dart';
import 'package:wheather_app/features/feature_weather/presentation/screens/home_screen.dart';

import '../../../../core/widgets/app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  Duration screenTimeDuration = Duration(seconds: 2);

  late AnimationController _animationController;
  bool isConnected = true;


  late final StreamSubscription<InternetStatus> listener;

  @override
  void initState() {
    super.initState();

    _checkNetworkConnection();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _animationController.repeat();
  }

  @override
  void dispose() {
    timer?.cancel();

    _animationController.dispose();
    listener.cancel();

    super.dispose();
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
          startTimer();
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
          });
          break;
      }
    });
  }


  startTimer() {
    timer = Timer(screenTimeDuration, _navigate);
  }

  _navigate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>  MainWrapper(),
        ),
      );
    });  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      decoration: BoxDecoration(
        image: DecorationImage(
            image: AppBackground.getBackGroundImage(), fit: BoxFit.cover),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.4),
              ),
              SizedBox(height: 80),
              if (isConnected) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    DotLoadingWidget(size: 60,),
                    SizedBox(height: 30,),
                    Text(
                      '!...درحال بارگذاری',
                      style: TextStyle(color: Colors.white,fontFamily: 'AsliMedium',fontSize: 19),
                    )
                  ],
                )
              ] else ...[
                Text(
                  '!...از اتصال اینترنت خود مطمعن شوید',
                  style: TextStyle(color: Colors.white,fontFamily: 'AsliMedium',fontSize: 19),
                )
              ],
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.2),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
