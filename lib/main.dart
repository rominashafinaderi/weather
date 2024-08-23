import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheather_app/core/widgets/main_wrapper.dart';
import 'package:wheather_app/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:wheather_app/features/feature_weather/presentation/screens/splash_screen.dart';
import 'package:wheather_app/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.grey, // اینجا رنگ مورد نظرتان را وارد کنید
        ),),
    home: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<HomeBloc>()),
      ],
      child: MainWrapper(),
    ),
  ));
}
