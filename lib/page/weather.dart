import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PageWeather extends StatefulWidget {
  const PageWeather({super.key});

  @override
  State<PageWeather> createState() => _PageWeatherState();
}

class _PageWeatherState extends State<PageWeather> {
  String locationMessage = 'Current location of the User';
  late String lat;
  late String long;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    showScreen() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = value.latitude.toString();
                  long = value.longitude.toString();
                  setState(() {
                    locationMessage = 'Latitude: ${value.latitude}, Longitude: ${value.longitude}';
                  });
                });
              },
              child: Text(locationMessage),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C6758),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: showScreen(),
      ),
    );
  }
}
