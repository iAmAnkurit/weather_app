import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/constants.dart';
import 'package:weather_app/ui/detail_page.dart';

import '../widgets/weather_item.dart';

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
  // https://api.openweathermap.org/data/2.5/weather?q=Delhi&appid=780c62c65436448fdd34d69bb9d7b895&lang=en'
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

      imageUrl =
          Constants.getWeatherMappedData(_weather?.weatherConditionCode ?? 0);
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

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6FC)],
  ).createShader(const Rect.fromLTWH(
    0.0,
    0.0,
    200.0,
    70.0,
  ));

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
                    'assets/dp.png',
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
                        _weather?.weatherMain ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Positioned(
                        top: 20,
                        right: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                temperature.toString(),
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = linearGradient,
                                ),
                              ),
                            ),
                            Text(
                              'o',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherItem(
                      text: 'Wind speed',
                      value: windSpeed,
                      unit: 'km/h',
                      imageUrl: 'assets/windspeed.png',
                    ),
                    weatherItem(
                      text: 'Humidity',
                      value: humidity,
                      unit: '',
                      imageUrl: 'assets/humidity.png',
                    ),
                    weatherItem(
                      text: 'Max temperature',
                      value: maxTemp,
                      unit: '°C',
                      imageUrl: 'assets/max-temp.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    'Next 7 days',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: myConstants.primaryColor),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: consolidateWeatherList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String today = DateTime.now().toString().substring(0, 10);

                      var selectedDay = consolidateWeatherList[index]
                          .date
                          .toString()
                          .substring(0, 10);
                      var weatherImageUrl=Constants.getWeatherMappedData(consolidateWeatherList[index].weatherConditionCode ?? 0);
                      var futureWeatherName =
                          consolidateWeatherList[index].weatherMain.toString();
                      var parseDate = DateTime.parse(
                          consolidateWeatherList[index].date.toString());
                      var newDate =
                          DateFormat('EEE').format(parseDate).substring(0, 3);
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(consolidatedWeatherList: consolidateWeatherList,selectedId: index,location: location,)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          margin: const EdgeInsets.only(
                              right: 20, bottom: 10, top: 10),
                          width: 120,
                          decoration: BoxDecoration(
                            color: selectedDay == today
                                ? myConstants.primaryColor
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: selectedDay == today
                                    ? myConstants.primaryColor
                                    : Colors.black54.withOpacity(0.2),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${consolidateWeatherList[index]
                                        .temperature!
                                        .celsius!
                                        .round()}°C',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: selectedDay == today
                                        ? Colors.white
                                        : myConstants.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Image.asset('assets/$weatherImageUrl.png',width: 80,),
                              Center(
                                child: Text(DateFormat('EEEE, H:m').format(consolidateWeatherList[index].date ?? DateTime.now()),style: TextStyle(fontSize: 12,
                                    color:selectedDay==today?Colors.white:myConstants.primaryColor,fontWeight: FontWeight.w500),),
                              ),

                              Text(newDate,style: TextStyle(fontSize: 17,
                              color:selectedDay==today?Colors.white:myConstants.primaryColor,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
