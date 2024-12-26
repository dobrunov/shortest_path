import 'package:flutter/cupertino.dart';

import '../../core/services/api_service.dart';
import '../../core/services/data_base_service.dart';

class HomeController extends ChangeNotifier {
  final ApiService apiService;
  final DataBaseService dataBaseService;

  bool isLoading = false;
  String? errorMessage;
  dynamic data;
  bool navigateToNextScreen = false;

  HomeController({required this.apiService, required this.dataBaseService});

  Future<void> createRequest(String url) async {
    await dataBaseService.saveUrlToHive(url);
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading = true;
    errorMessage = null;
    navigateToNextScreen = false;
    notifyListeners();

    try {
      final result = await apiService.getData();
      debugPrint("Result in home controller - ${result.toString()}");

      dataBaseService.savePathModelToHive(result);

      if (result.error == true) {
        errorMessage = result.message;
      } else {
        data = result;
        navigateToNextScreen = true;
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetNavigationFlag() {
    navigateToNextScreen = false;
    notifyListeners();
  }
}
