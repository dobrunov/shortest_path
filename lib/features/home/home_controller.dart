import 'package:flutter/cupertino.dart';

import '../../core/models/path_model.dart';
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
      print(result);

      if (result is PathModel) {
        if (result.error == true) {
          errorMessage = result.message;
        } else {
          data = result;
          navigateToNextScreen = true;
        }
      } else {
        errorMessage = 'Unexpected data format received.';
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
