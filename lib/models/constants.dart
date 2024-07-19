import 'package:flutter/material.dart';

class Constants {
  final Color primaryColor = const Color(0xff90B2F9);
  final Color secondaryColor = const Color(0xff90B2F9);

  static String getWeatherMappedData(int weatherCode) {
    String weather =
        ''; // create an object with both weather condition name the description
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
        weather = 'thunderstorm';
        break;
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
        weather = 'showers';
        break;

      case 500:
      case 501:
        weather = 'lightrain';
        break;
      case 502:
      case 503:
      case 504:
      case 511:
      case 520:
      case 521:
      case 522:
      case 531:
        weather = 'heavyrain';
        break;
      case 600:
      case 601:
      case 602:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        weather = 'snow';
        break;
      case 611:
      case 612:
      case 613:
        weather = 'sleet';
        break;
      case 800:
        weather = 'clear';
        break;
      case 801:
      case 802:
        weather = 'lightcloud';
        break;
      case 803:
      case 804:
        weather = 'heavycloud';
        break;
      default:
        weather = 'heavycloud';
        break;
    }
    return weather;
  }
}
