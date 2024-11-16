import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PageWeather extends StatefulWidget {
  const PageWeather({super.key, required this.lat, required this.long});

  final String lat;
  final String long;

  @override
  State<PageWeather> createState() => _PageWeatherState();
}

class _PageWeatherState extends State<PageWeather> {
  Map rowData = {};

  loadDataFromApi() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.lat}&lon=${widget.long}&appid=def5070e1bc539fe3d1cbbec9144091d'));

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
        backgroundColor: const Color(0xFF1C6758),
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
              " ${DateFormat("d-m-y").format(now)}",
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
}
