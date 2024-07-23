import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/ui/WELCOME.dart';

import '../models/constants.dart';
import '../widgets/weather_item.dart';

class DetailPage extends StatefulWidget {
  final List<Weather> consolidatedWeatherList;
  final int selectedId;
  final String location;

  const DetailPage(
      {super.key,
      required this.consolidatedWeatherList,
      required this.selectedId,
      required this.location});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String imageUrl = '';

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
    int selectedIndex = widget.selectedId;
    var weatherStateName =
        widget.consolidatedWeatherList[selectedIndex].weatherDescription;
    imageUrl = Constants.getWeatherMappedData(
        widget.consolidatedWeatherList[selectedIndex].weatherConditionCode ??
            0);
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    return Scaffold(
      backgroundColor: myConstants.primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myConstants.primaryColor,
        title: Text(widget.location),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Welcome()));
              },
              icon: const Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 200,
              width: size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index) {
                  String today = DateTime.now().toString().substring(0, 10);

                  var selectedDay = widget.consolidatedWeatherList[index].date
                      .toString()
                      .substring(0, 10);
                  var weatherImageUrl = Constants.getWeatherMappedData(widget
                          .consolidatedWeatherList[index]
                          .weatherConditionCode ??
                      0);
                  var futureWeatherName = widget
                      .consolidatedWeatherList[index].weatherMain
                      .toString();
                  var parseDate = DateTime.parse(
                      widget.consolidatedWeatherList[index].date.toString());
                  var newDate =
                      DateFormat('EEE').format(parseDate).substring(0, 3);

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 20),
                    width: 120,
                    decoration: BoxDecoration(
                      color: index == widget.selectedId
                          ? Colors.white
                          : const Color(0xff9ebcf9),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: selectedDay == today
                              ? myConstants.primaryColor
                              : Colors.black54.withOpacity(0.3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.consolidatedWeatherList[index].temperature!.celsius!.round()}°C',
                          style: TextStyle(
                              fontSize: 17,
                              color: index == widget.selectedId
                                  ? Colors.blue
                                  : Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        Image.asset(
                          'assets/$weatherImageUrl.png',
                          width: 40,
                        ),
                        Center(
                          child: Text(
                            DateFormat('EEEE, H:m').format(
                                widget.consolidatedWeatherList[index].date ??
                                    DateTime.now()),
                            style: TextStyle(
                                fontSize: 12,
                                color: index == widget.selectedId
                                    ? Colors.blue
                                    : Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          newDate,
                          style: TextStyle(
                              fontSize: 17,
                              color: index == widget.selectedId
                                  ? Colors.blue
                                  : Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: size.height * .55,
                width: size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50))),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 80,
                      right: 20,
                      left: 20,
                      child: Container(
                        width: size.width * .7,
                        height: 350,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xffBBDEFB),Color(0xff82b1ff), Color(0xff82b1ff)]),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  offset: const Offset(0, 25),
                                  blurRadius: 3,
                                  spreadRadius: -10)
                            ]),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -40,
                              left: 20,
                              child: Image.asset(
                                'assets/$imageUrl.png',
                                width: 150,
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 30,
                              child: Text(
                                weatherStateName.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Container(
                                width: size.width * 0.8,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    weatherItem(
                                      text: 'Wind speed',
                                      value: widget
                                          .consolidatedWeatherList[
                                              selectedIndex]
                                          .windSpeed!
                                          .round(),
                                      unit: 'km/h',
                                      imageUrl: 'assets/windspeed.png',
                                    ),
                                    weatherItem(
                                      text: 'Humidity',
                                      value: widget
                                          .consolidatedWeatherList[
                                              selectedIndex]
                                          .humidity!
                                          .round(),
                                      unit: '',
                                      imageUrl: 'assets/humidity.png',
                                    ),
                                    weatherItem(
                                      text: 'Max temperature',
                                      value: widget
                                          .consolidatedWeatherList[
                                              selectedIndex]
                                          .tempMax!
                                          .celsius!
                                          .round(),
                                      unit: '°C',
                                      imageUrl: 'assets/max-temp.png',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: 20,
                                right: 20,
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.consolidatedWeatherList[selectedIndex].temperature!.celsius!.round().toString(),style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader=linearGradient
                                  ),),
                                  Text('o',style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()..shader=linearGradient
                                  ),),
                                ],))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
