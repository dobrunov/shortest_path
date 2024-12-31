import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/models/url_model.dart';
import 'core/repository/path_repository.dart';
import 'core/services/api_service.dart';
import 'core/services/data_base_service.dart';
import 'features/home/home_controller.dart';
import 'features/process/process_controller.dart';
import 'features/result_list/result_list_controller.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UrlModelAdapter());
  final urlBox = await Hive.openBox<UrlModel>('urlBox');
  final pathModelBox = await Hive.openBox<String>('pathModelBox');
  final shortestPathBox = await Hive.openBox<String>('shortestPathBox');

  sl.registerLazySingleton<DataBaseService>(() => DataBaseService(
    urlBox: urlBox,
    pathModelBox: pathModelBox,
    shortestPathBox: shortestPathBox,
  ));

  sl.registerLazySingleton<ApiService>(() => ApiService());

  sl.registerLazySingleton<PathRepository>(() => PathRepository());

  sl.registerFactory<HomeController>(() => HomeController());

  sl.registerFactory<ProcessController>(() => ProcessController());

  sl.registerFactory<ResultListController>(() => ResultListController());
}
