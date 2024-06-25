import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();
  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading...';
  int humidity = 0;
  int windSpeed = 0;
  var currentDate = 'Loading...';
  String imageUrl = '';
  int woeId = 2295420; //44418
  String location = 'Bangalore';

  var selectedCities = City.getSelectedCities();

  List<String> cities = ['Bangalore'];

  List<Weather> consolidateWeatherList = [];

  final WeatherFactory _wf = WeatherFactory(OPEN_WEATHER_API_KEY);

  Weather? _weather;

  void getWeatherData(String loc) {
    _wf.currentWeatherByCityName(loc).then((w) {
      setState(() {
        _weather = w;
      });
      temperature = _weather?.temperature?.celsius?.round() ?? 0;
      weatherStateName = _weather?.weatherDescription ?? '';
      humidity = _weather?.humidity?.round() ?? 0;
      windSpeed = _weather?.windSpeed?.round() ?? 0;
      maxTemp = _weather?.tempMax?.celsius?.round() ?? 0;
      currentDate =
          DateFormat('EEEE, d MMMM').format(_weather?.date ?? DateTime.now());
      imageUrl = _weather?.weatherDescription
              ?.toString()
              .replaceAll(' ', '')
              .toLowerCase() ??
          '';
    });
    _wf.fiveDayForecastByCityName(loc).then((w) {
      setState(() {
        consolidateWeatherList = w;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }
    getWeatherData(location);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.black12,
          toolbarHeight: 100,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    'assets/profile.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/pin.png',
                      width: 20,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: location,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cities.map((String location) {
                          return DropdownMenuItem(
                              value: location,
                              child: Text(
                                location,
                              ));
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            location = newVal!;
                            getWeatherData(location);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          elevation: 10,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                currentDate,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: myConstants.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: myConstants.primaryColor.withOpacity(.5),
                        offset: const Offset(0, 25),
                        blurRadius: 10,
                        spreadRadius: -12)
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -40,
                      left: 20,
                      child: imageUrl == ''
                          ? const Text('')
                          : Image.asset(
                              'assets/${imageUrl}.png',
                              width: 150,
                            ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        _weather?.weatherConditionCode.toString()??'',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
