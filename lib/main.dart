import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'core/models/url_model.dart';
import 'core/repository/path_repository.dart';
import 'core/services/api_service.dart';
import 'core/services/data_base_service.dart';
import 'features/home/home_controller.dart';
import 'features/home/home_screen.dart';
import 'features/process/process_controller.dart';
import 'features/result_list/result_list_controller.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UrlModelAdapter());
  final urlBox = await Hive.openBox<UrlModel>('urlBox');
  final pathModelBox = await Hive.openBox<String>('pathModelBox');
  final shortestPathBox = await Hive.openBox<String>('shortestPathBox');

  runApp(
    MultiProvider(
      providers: [
        Provider<DataBaseService>(create: (_) => DataBaseService(urlBox: urlBox, pathModelBox: pathModelBox, shortestPathBox: shortestPathBox)),
        Provider<ApiService>(
            create: (_) =>
                ApiService(dataBaseService: DataBaseService(urlBox: urlBox, pathModelBox: pathModelBox, shortestPathBox: shortestPathBox))),
        Provider<PathRepository>(
          create: (_) => PathRepository(
              dataBaseService: DataBaseService(urlBox: urlBox, pathModelBox: pathModelBox, shortestPathBox: shortestPathBox),
              apiService: ApiService(dataBaseService: DataBaseService(urlBox: urlBox, pathModelBox: pathModelBox, shortestPathBox: shortestPathBox))),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeController(apiService: context.read<ApiService>(), dataBaseService: context.read<DataBaseService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProcessController(
              apiService: context.read<ApiService>(), repository: context.read<PathRepository>(), dataBaseService: context.read<DataBaseService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ResultListController(repository: context.read<PathRepository>(), dataBaseService: context.read<DataBaseService>()),
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
