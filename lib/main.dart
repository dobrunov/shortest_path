import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter REST API Test Code',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final String apiUrl = 'https://flutter.webspark.dev/flutter/api';
  String result = '';
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        log(response.body);
        if (jsonData['error'] == true) {
          setState(() {
            result = "Error: ${jsonData['message']}";
          });
        } else {
          StringBuffer stringBuffer = StringBuffer();
          stringBuffer.writeln("Data Received:");
          for (var item in jsonData['data']) {
            stringBuffer.writeln("ID: ${item['id']}");
            stringBuffer.writeln("Fields: ${item['field']}");
            stringBuffer.writeln("Start: (${item['start']['x']}, ${item['start']['y']})");
            stringBuffer.writeln("End: (${item['end']['x']}, ${item['end']['y']})");
            stringBuffer.writeln("---");
          }
          setState(() {
            result = stringBuffer.toString();
          });
        }
      } else {
        setState(() {
          result = "Failed to load data: ${response.statusCode}";
        });
      }
    } catch (error) {
      setState(() {
        result = "Error occurred: $error";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API TEST'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : fetchData,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
