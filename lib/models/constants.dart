import 'package:flutter/material.dart';

class Constants {
  final Color primaryColor = const Color(0xff90B2F9);
  final Color secondaryColor = const Color(0xff90B2F9);

  static String getWeatherMappedData(int weatherCode) {
    String weather = '';// create an object with both weather condition name the description
    switch (weatherCode) {
      case 200:
      case 201:
      case 202:
      case 210:
      case 211:
      case 212:
      case 221:
      case 230:
      case 231:
      case 232:
        weather = 'Thunderstorm';
        break;
    }
    return weather;
  }
}
