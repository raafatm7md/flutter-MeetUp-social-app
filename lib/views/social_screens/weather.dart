import 'package:flutter/material.dart';
import '../../models/weather.dart';
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
                        color: Colors.deepPurpleAccent,
                        size: 28.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${weather.location!.name!} - ${weather.location!.country!}',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    '${weather.current!.tempC!}°C',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 60.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: NetworkImage(
                            'https:${weather.current!.condition!.icon}'),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        '${weather.current!.condition!.text}',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ],
                  ),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5.0,
                    color: Colors.purple.withOpacity(0.1),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Humidity',
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${weather.current!.humidity}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Wind speed',
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${weather.current!.windKph} km/h',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Cloud pct.',
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${weather.current!.cloud}%',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'UV index',
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${weather.current!.uv}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Expanded(
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5.0,
                      color: Colors.purple.withOpacity(0.1),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${weather.forecast!.forecastday![0].date}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Spacer(),
                                Text(
                                  '${weather.forecast!.forecastday![0].day!.maxtempC}/${weather.forecast!.forecastday![0].day!.mintempC}°C',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              'Sunrise at: ${weather.forecast!.forecastday![0].astro!.sunrise}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Sunset at: ${weather.forecast!.forecastday![0].astro!.sunset}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Rain chance: ${weather.forecast!.forecastday![0].day!.dailyChanceOfRain}%',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) => buildHourData(weather.forecast!.forecastday![0].hour![index]),
                                  separatorBuilder: (context, index) => SizedBox(height: 2.0,),
                                  itemCount: weather.forecast!.forecastday![0].hour!.length
                              ),
                            )
                          ],
                        ),
                      ),
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

  buildHourData(Hour hour) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: NetworkImage(
                    'https:${hour.condition!.icon}'),
                width: 40.0,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(width: 5.0,),
              Text(
                '${hour.time?.substring(11)}',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ],
          ),
          Text(
            '${hour.condition?.text}',
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          Text(
            '${hour.tempC}°C',
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ],
      );
}
