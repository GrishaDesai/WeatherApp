import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'Screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String apiBaseUrl = "https://api.weatherapi.com/v1";
  String apiKey = "ddf33eaaacb24483b5b40733242304";
  String infoText = "";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
          Expanded(
            child: Container(
              child: Image.asset('assets/weather.png'),
            ),
          ),
          Expanded(
              child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: 300,
                height: 80,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'Weather',
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Container(
                width: 400,
                height: 90,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'ForeCasts',
                    style: TextStyle(
                        fontSize: 60,
                        color: Colors.amber,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    Position position = await _getCurrentLocation();
                    if (position != null) {
                      String apiUrl =
                          '$apiBaseUrl/current.json?key=$apiKey&q=${position.latitude},${position.longitude}';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Screen2(apiUrl: apiUrl),
                        ),
                      );
                    } else {
                      setState(() {
                        infoText = 'Failed to get current location.';
                      });
                    }
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 55.0),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber),
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    ));
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission is denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      setState(() {
        infoText = "Error getting location: $e";
      });
      // Return a default position in case of any error
      return Position(
        latitude: 0.0,
        longitude: 0.0,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(),
      );
    }
  }
}
