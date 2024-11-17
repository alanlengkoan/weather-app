import 'package:flutter/material.dart';
import 'package:testing/page/weather.dart';

class PageSearch extends StatefulWidget {
  const PageSearch({super.key});

  @override
  State<PageSearch> createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  TextEditingController controllerSearch = TextEditingController();
  bool _validateSearch = false;

  searchLocation() {
    setState(() {
      _validateSearch = controllerSearch.text.isEmpty;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PageWeather(
          search: controllerSearch.text,
          status: 'search',
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    showScreen() {
      return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controllerSearch,
              decoration: InputDecoration(
                labelText: 'Search',
                border: const OutlineInputBorder(),
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                errorText: _validateSearch ? 'Please enter some text' : null,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C6758),
              ),
              onPressed: () => searchLocation(),
              child: const Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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
