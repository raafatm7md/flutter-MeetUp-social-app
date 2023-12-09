import 'package:flutter/material.dart';
import 'package:social_app/models/weather.dart';

import '../../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  final String lat;
  final String long;
  const WeatherScreen({super.key, required this.lat, required this.long});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Weather weather;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    getWeather(widget.lat, widget.long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather'), centerTitle: true),
      body: loaded == true
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.white,
                        size: 28.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${weather.location!.name!} - ${weather.location!.country!}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 25.0,
                  // ),
                  Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Align(
                          alignment: Alignment(-1.2, 0),
                          child: Image(
                            image: NetworkImage(
                                'https:${weather.current!.condition!.icon!}'),
                            width: 200.0,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.35, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              '${weather.current!.tempC!}°C',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${weather.current!.condition!.text}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  getWeather(String lat, String long) async {
    try {
      weather = await WeatherService(lat: lat, long: long);
      setState(() {
        loaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
