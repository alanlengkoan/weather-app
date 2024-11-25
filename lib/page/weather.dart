import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/page/search.dart';

class PageWeather extends StatefulWidget {
  const PageWeather(
      {super.key, this.lat, this.long, this.search, required this.status});

  final String? lat;
  final String? long;
  final String? search;
  final String status;

  @override
  State<PageWeather> createState() => _PageWeatherState();
}

class _PageWeatherState extends State<PageWeather> {
  Map rowData = {};
  late String url;

  loadDataFromApi() async {
    if (widget.status == 'current') {
      url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${widget.lat}&lon=${widget.long}&appid=def5070e1bc539fe3d1cbbec9144091d';
    } else {
      url =
          'https://api.openweathermap.org/data/2.5/weather?q=${widget.search}&appid=def5070e1bc539fe3d1cbbec9144091d';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        rowData = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    showScreen() {
      return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _locationHeader(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            _weatherIcon(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            _currentTemp(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            _extraInfo(),
          ],
        ),
      );
    }

    loading() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C3FF),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageSearch(),
                ),
              )
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: rowData.isEmpty ? loading() : showScreen(),
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      rowData['name'] ?? '',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = DateTime.fromMillisecondsSinceEpoch(rowData['dt'] * 1000);

    return Column(
      children: [
        Text(
          DateFormat('h:mm a').format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ", ${DateFormat("d-m-y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${rowData['weather'][0]['icon']}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          rowData['weather'][0]['description'] ?? '',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${(rowData['main']['temp'] - 273.15).toStringAsFixed(1)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.15,
        width: MediaQuery.sizeOf(context).width * 0.80,
        decoration: BoxDecoration(
          color: const Color(0xFF00AAF0),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Max: ${((rowData['main']['temp_max'] - 273.15).toStringAsFixed(1))}° C",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Min: ${((rowData['main']['temp_min'] - 273.15).toStringAsFixed(1))}° C",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wind: ${((rowData['wind']['speed']).toStringAsFixed(1))}m/s",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Humidity: ${((rowData['main']['humidity']).toStringAsFixed(1))}%",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
