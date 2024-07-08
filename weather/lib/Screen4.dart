import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Screen3.dart';

class Screen4 extends StatefulWidget {
  String? apiUrl;

  Screen4(apiUrl) {
    this.apiUrl = apiUrl;
  }

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  String? _apiUrl;
  String apiBaseUrl = "https://api.weatherapi.com/v1";
  String apiKey = "ddf33eaaacb24483b5b40733242304";
  String infoText = "";
  String city = '';

  void initState() {
    super.initState();
    _apiUrl = widget.apiUrl;
  }
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    // Format the date using intl package
    String formattedDate = DateFormat('dd-MM-yyyy').format(today);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 25,
          backgroundColor: Color(0xFF2b2a57),
        ),
        body: FutureBuilder(
          future: fetchWeatherData(_apiUrl!),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            }else{
              city = snapshot.data!['location']['name'];
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
                    Column(
                      children: [
                        Container(
                          child: Image.asset('assets/weather.png', fit: BoxFit.cover,),
                          height: 130,
                          width: 150,
                        ),
                        Container(
                          child: Text('${snapshot.data!['current']['temp_c'].toString()}\u2103', style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        Container(
                          child: Text('${snapshot.data!['current']['condition']['text'].toString()}', style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            child:Align(
                              alignment: Alignment.center,
                              child:  Text('${snapshot.data!['location']['name'].toString()} - ${snapshot.data!['location']['region'].toString()} - ${snapshot.data!['location']['country'].toString()}',
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,

                              ),
                            ),
                          ),
                        ),
                        ),
                        Container(
                          height: 230,
                          width: 280,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/house2.png'),
                                fit: BoxFit.fill
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF3E2D8F),
                                  Color(0xFF9D52AC),
                                  // Color(0xFFB17EBF),
                                ],
                                stops: [0.0, 0.7],
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white, // Color of the border
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Today', style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(formattedDate, style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.amber
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                              Container(
                                height: 170,
                                child: ListView(
                                  scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
                                  children: <Widget>[
                                    SizedBox(
                                      width: 130,
                                      height: 170,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.only(top: 12, bottom: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0x1AFFFFFF),
                                        ),
                                        child: Column(
                                          children: [
                                            Text('Feels like', style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                            Container(
                                              margin: EdgeInsets.only(top: 8, bottom: 8),
                                              child: Icon(
                                                FontAwesomeIcons.thermometerQuarter,
                                                size: 50,
                                                color: Color(0xFF34266c),

                                              ),
                                            ),
                                            Text('${snapshot.data!['current']['feelslike_c'].toString()}\u2103',style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      height: 170,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.only(top: 12, bottom: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0x1AFFFFFF),
                                        ),
                                        child: Column(
                                          children: [
                                            Text('Humidity', style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                            Container(
                                              margin: EdgeInsets.only(top: 8, bottom: 8),
                                              child: FaIcon(
                                                FontAwesomeIcons.tint,
                                                size: 50,
                                                color: Color(0xFF34266c),

                                              ),
                                            ),
                                            Text('${snapshot.data!['current']['humidity'].toString()}%',style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      height: 170,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.only(top: 12, bottom: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0x1AFFFFFF),
                                        ),
                                        child: Column(
                                          children: [
                                            Text('Wind', style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                            Container(
                                              margin: EdgeInsets.only(top: 8, bottom: 8),
                                              child: FaIcon(
                                                FontAwesomeIcons.wind,
                                                size: 50,
                                                color: Color(0xFF34266c),

                                              ),
                                            ),
                                            Text('${snapshot.data!['current']['wind_kph'].toString()}SW',style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      height: 170,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.only(top: 12, bottom: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0x1AFFFFFF),
                                        ),
                                        child: Column(
                                          children: [
                                            Text('UV Index', style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                            Container(
                                              margin: EdgeInsets.only(top: 8, bottom: 8),
                                              child: FaIcon(
                                                FontAwesomeIcons.solidSun,
                                                size: 50,
                                                color: Color(0xFF34266c),

                                              ),
                                            ),
                                            Text('${snapshot.data!['current']['uv'].toString()}',style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      height: 170,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.only(top: 12, bottom: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0x1AFFFFFF),
                                        ),
                                        child: Column(
                                          children: [
                                            Text('Visibility', style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                            Container(
                                              margin: EdgeInsets.only(top: 8, bottom: 8),
                                              child: FaIcon(
                                                FontAwesomeIcons.eye,
                                                size: 50,
                                                color: Color(0xFF34266c),

                                              ),
                                            ),
                                            Text('${snapshot.data!['current']['vis_km'].toString()}KM',style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      height: 170,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.only(top: 12, bottom: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0x1AFFFFFF),
                                        ),
                                        child: Column(
                                          children: [
                                            Text('Pressure', style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                            Container(
                                              margin: EdgeInsets.only(top: 8, bottom: 8),
                                              child: FaIcon(
                                                FontAwesomeIcons.tachometerAlt,
                                                size: 50,
                                                color: Color(0xFF34266c),

                                              ),
                                            ),
                                            Text('${snapshot.data!['current']['pressure_mb'].toString()}mb',style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),],
                                ),
                              ),

                            ],
                          ),

                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ElevatedButton(
                            onPressed: (){
                              String apiUrl =
                                  '$apiBaseUrl/forecast.json?key=$apiKey&q=${city}&days=7';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Screen3(apiUrl),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF382576),
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 2,
                            ),
                            child: Text("See 7 day Forecast", style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              );
            }
          },
        ),

      ),
    );
  }
}
Future<Map<String, dynamic>> fetchWeatherData(String apiUrl) async {
  print(apiUrl);
  var res = await http.get(
    Uri.parse(apiUrl),
  );
  return jsonDecode(res.body);
}