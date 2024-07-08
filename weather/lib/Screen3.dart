import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

import 'Screen4.dart';

class Screen3 extends StatefulWidget {
  String? apiUrl;

  Screen3(apiUrl) {
    this.apiUrl = apiUrl;
  }

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String apiUrl = '';
  int _selectedIndex = 0;
  List<String>? forecastDates;
  List<ForecastDay>? forecastDays;
  List<HourData>? hourData;
  final TextEditingController _controller = TextEditingController();
  String apiBaseUrl = "https://api.weatherapi.com/v1";
  String apiKey = "ddf33eaaacb24483b5b40733242304";

  void initState() {
    apiUrl = widget.apiUrl.toString();
    fetchWeatherForecast();
  }

  @override
  Widget build(BuildContext context) {
    DateTime c_now = DateTime.now();
    String cformattedDate = DateFormat('dd MMMM yyyy').format(c_now);
    String cformattedTime = DateFormat('HH:mm').format(c_now);
    String cdayName = DateFormat('EEEE').format(c_now);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'Weather  Forecast',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                letterSpacing: 2),
          ),
        ),
        backgroundColor: Color(0xFF2b2a57),
      ),
      body: FutureBuilder(
        future: fetchForecastData(apiUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2A2A55),
                  Color(0xFF382576),
                  Color(0xFF7E4FAD),
                  Color(0xFFb54ccf)
                ],
                stops: [0.0, 0.3, 0.8, 1.0],
              )),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      snapshot.data!['location']['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${snapshot.data!['location']['region']} - ${snapshot.data!['location']['country']}',
                      style: TextStyle(color: Colors.white54, fontSize: 20),
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.7,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: forecastDays!.map((forecastDay) {
                      DateTime now = DateTime.now();
                      String today = DateFormat('yyyy-MM-dd').format(now);

                      if (forecastDay.date == today) {
                        // Current day's weather
                        String currentTime = DateFormat('HH:00').format(now);
                        HourCondition currentHourCondition =
                            forecastDay.hours.firstWhere(
                          (hour) =>
                              DateFormat('HH:00')
                                  .format(DateTime.parse(hour.time)) ==
                              currentTime,
                          orElse: () => forecastDay.hours[
                              0], // Default to the first hour if not found
                        );

                        return Builder(
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xFF3E2D8F),
                                      Color(0xFF9D52AC),
                                      Color(0xFFffffff),
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text('Date: ${forecastDay.date}', style: TextStyle(fontSize: 20)),
                                    Container(
                                      width: 150,
                                      height: 130,
                                      child: Image.network(
                                        currentHourCondition.conditionIcon,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      '${currentHourCondition.tempC}°',
                                      style: TextStyle(
                                          fontSize: 45,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding:EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        '${currentHourCondition.conditionText}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF382576),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        String avgConditionText = forecastDay.avgConditionText;
                        String avgConditionIcon = forecastDay.avgConditionIcon;
                        // Other days' average weather
                        return Builder(
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xFF3E2D8F),
                                      Color(0xFF9D52AC),
                                      Color(0xFFffffff),
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${forecastDay.date}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF382576),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 130,
                                      child: Image.network(
                                        avgConditionIcon,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      '${forecastDay.avgTempC}°',
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${avgConditionText}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF382576),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }).toList(),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '$cformattedTime',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.amber),
                                  ),
                                ),
                                Text(
                                  '$cdayName',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white54),
                                ),
                                Text(
                                  '$cformattedDate',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                )
                              ],
                            ),

                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  child: Image.asset(
                                    'assets/weather3.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight, // Align text to the right
                                  child: Text(
                                    snapshot.data!['current']['condition']['text'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            flex: 2,
                          )

                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 130,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 0.25,

                      ),
                      items: hourData!.map((hourData) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0,),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${hourData.time}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF382576),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 70,
                                      height: 70,
                                      child: Image.network(hourData.icon, fit: BoxFit.cover,),
                                  ),
                                  Text(
                                    '${hourData.temp}°',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter City Name',
                              labelText: 'City',
                              hintStyle: TextStyle(color: Colors.white54),
                              labelStyle: TextStyle(color: Colors.white54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                // Border radius
                                borderSide: BorderSide(
                                  color: Colors.white, // Border color
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                        // SizedBox(width: 8), // Add some space between TextFormField and button
                        ElevatedButton(
                          onPressed: _onGoPressed,
                          child: Text(
                            'Go',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            // Background color
                            foregroundColor: Colors.white,
                            // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Decrease border radius
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            // Button padding
                            elevation: 5, // Shadow elevation
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    ));
  }

  void _onGoPressed() {
    // Handle button press
    print('Go button pressed with text: ${_controller.text}');
    String apiUrl =
        '$apiBaseUrl/forecast.json?key=$apiKey&q=${_controller.text}&days=7';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen4(apiUrl),
      ),
    );
  }

  Future<void> fetchWeatherForecast() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> forecastDaysData = data['forecast']['forecastday'];

      List<HourData> loadedHourData = [];
      for (var day in forecastDaysData) {
        List<dynamic> hours = day['hour'];
        for (var hour in hours) {
          String fullTime = hour['time'];
          String time = fullTime.split(' ')[1];
          String temp = hour['temp_c'].toString();
          String icon = hour['condition']['icon'];
          loadedHourData.add(HourData(time: time, temp: temp, icon: icon));
        }
      }

      List<ForecastDay> loadedForecastDays = forecastDaysData.map((day) {
        String date = day['date'];
        String avgConditionText = day['day']['condition']['text'];
        String avgConditionIcon = 'https:${day['day']['condition']['icon']}';

        List<HourCondition> hours = (day['hour'] as List<dynamic>).map((hour) {
          return HourCondition(
            time: hour['time'],
            tempC: hour['temp_c'],
            conditionText: hour['condition']['text'],
            conditionIcon: 'https:${hour['condition']['icon']}',
          );
        }).toList();

        return ForecastDay(
          date: date,
          avgTempC: day['day']['avgtemp_c'].toString(),
          avgConditionText: avgConditionText,
          avgConditionIcon: avgConditionIcon,
          hours: hours,
        );
      }).toList();

      setState(() {
        forecastDays = loadedForecastDays;
        hourData = loadedHourData;
      });
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}

Future<Map<String, dynamic>> fetchForecastData(String apiUrl) async {
  var res = await http.get(
    Uri.parse(apiUrl),
  );
  return jsonDecode(res.body);
}

class ForecastDay {
  final String date;
  final String avgTempC;
  final String avgConditionText;
  final String avgConditionIcon;
  final List<HourCondition> hours;

  ForecastDay({
    required this.date,
    required this.avgTempC,
    required this.avgConditionText,
    required this.avgConditionIcon,
    required this.hours,
  });
}

class HourCondition {
  final String time;
  final double tempC;
  final String conditionText;
  final String conditionIcon;

  HourCondition({
    required this.time,
    required this.tempC,
    required this.conditionText,
    required this.conditionIcon,
  });
}

class HourData {
  final String time;
  final String temp;
  final String icon;

  HourData({required this.time, required this.temp, required this.icon});

  factory HourData.fromJson(Map<String, dynamic> json) {
    return HourData(
      time: json['time'],
      temp: json['temp_c'].toString(),
      icon: json['condition']['icon'],
    );
  }
}

