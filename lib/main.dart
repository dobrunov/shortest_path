import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'core/models/url_model.dart';
import 'core/services/api_service.dart';
import 'core/services/data_base_service.dart';
import 'features/home/home_controller.dart';
import 'features/home/home_screen.dart';
import 'features/process/process_controller.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UrlModelAdapter());
  final urlBox = await Hive.openBox<UrlModel>('urlBox');

  runApp(
    MultiProvider(
      providers: [
        Provider<DataBaseService>(create: (_) => DataBaseService(urlBox: urlBox)),
        Provider<ApiService>(create: (_) => ApiService(dataBaseService: DataBaseService(urlBox: urlBox))),
        ChangeNotifierProvider(
          create: (context) => HomeController(apiService: context.read<ApiService>(), dataBaseService: context.read<DataBaseService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProcessController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter REST API Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
