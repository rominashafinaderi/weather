
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppBackground{

  static AssetImage getBackGroundImage(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk').format(now);
    //1. ساعات شب (قبل از 6 صبح):
    if(6 > int.parse(formattedDate)){
      return AssetImage('assets/images/sdf.jpg');
      //2. ساعات روز (بین 6 صبح تا 6 عصر):
    }else if(18 > int.parse(formattedDate)){
      return AssetImage('assets/images/sob4.jpg');
    }else{
      //3. ساعات عصر و شب (بعد از 6 عصر تا قبل از نیمه‌شب):
      return AssetImage('assets/images/sdf.jpg');
    }
  }
  static bool isDayTime() {
    DateTime now = DateTime.now();
    int hour = int.parse(DateFormat('kk').format(now));
    return (hour >= 6 && hour < 18);
  }
  static Image setIconForMain(description) {
    if (description == "clear sky") {
      return const Image(
          image: AssetImage(

            'assets/images/icons8-sun-96.png',
          ));
    } else if (description == "few clouds") {
      return Image(image: AssetImage('assets/images/icons8-partly-cloudy-day-80.png'));
    } else if (description.contains("clouds")) {
      return Image(image: AssetImage('assets/images/icons8-clouds-80.png'));
    } else if (description.contains("thunderstorm")) {
      return Image(image: AssetImage('assets/images/icons8-storm-80.png'));
    } else if (description.contains("drizzle")) {
      return Image(image: AssetImage('assets/images/icons8-rain-cloud-80.png'));
    } else if (description.contains("rain")) {
      return Image(image: AssetImage('assets/images/icons8-heavy-rain-80.png'));
    } else if (description.contains("snow")) {
      return Image(image: AssetImage('assets/images/icons8-snow-80.png'));
    } else {
      return Image(image: AssetImage('assets/images/icons8-windy-weather-80.png'));
    }
  }

}