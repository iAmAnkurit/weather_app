import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants=Constants();
  int temperature=0;
  int maxTemp=0;
  String weatherStateName='Loading...';
  int humidity=0;
  int windSpeed=0;

  var currentData='Loading...';
  String imageUrl='';
  int woeId=2295420; //44418
  String location='Bangalore';

  var selectedCities=City.getSelectedCities();
  List<String> cities=['Bangalore'];

  List consolidateWeatherList=[];

  final WeatherFactory _wf=WeatherFactory(OPEN_WEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName(location).then((w){
      setState(() {
        _weather=w;
        print(_weather);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Home Page'),
      ),
      body: _weather==null?
      Center(
        child: CircularProgressIndicator()
      ): Text(_weather?.cloudiness?.toString()??'')
    );
  }
}
