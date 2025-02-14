import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hava_durumu/models/weather_model.dart';
import 'package:hava_durumu/services/weither_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weather = [];
  String _city = "Konum alınıyor...";

  // Şehir adını servisten al
  Future<void> _getCityName() async {
    try {
      final city = await WeitherService().getLocation();
      setState(() {
        _city = city;
      });
    } catch (e) {
      setState(() {
        _city = "Konum alınamadı!";
      });
    }
  }

  void _getWeatherData() async {
    _weather = await WeitherService().getWeatherData();
    setState(() {});
  }

  @override
  void initState() {
    _getCityName();
    _getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hava_durumu.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: Text(
                _city,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20.0),
                itemCount: _weather.length,
                itemBuilder: (context, index) {
                  final WeatherModel weather = _weather[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade300,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.network(
                          weather.ikon,
                          width: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "${weather.gun.toUpperCase()}\n${weather.durum.toUpperCase()} ${weather.derece}°",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Min: ${weather.min}°",
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text("Max: ${weather.max}°",
                                    style:
                                        const TextStyle(color: Colors.white70)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Gece: ${weather.gece}°",
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text("Nem: ${weather.nem}%",
                                    style:
                                        const TextStyle(color: Colors.white70)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
