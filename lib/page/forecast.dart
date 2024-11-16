import 'package:flutter/material.dart';

class PageForecast extends StatefulWidget {
  const PageForecast({super.key});

  @override
  State<PageForecast> createState() => _PageForecastState();
}

class _PageForecastState extends State<PageForecast> {
  @override
  Widget build(BuildContext context) {
    showScreen() {
      return const Text('Forecast');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast'),
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