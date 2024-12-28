import 'package:flutter/material.dart';

import '../../core/models/points_model.dart';
import '../../core/repository/path_repository.dart';
import '../../core/services/api_service.dart';
import '../../core/services/data_base_service.dart';

class ProcessController extends ChangeNotifier {
  final ApiService apiService;
  final PathRepository repository;
  final DataBaseService dataBaseService;

  bool isProcessing = false;
  bool canSendToServer = false;
  bool showIndicator = false;
  List<List<Points>>? shortestPath;
  bool navigateToNextScreen = false;
  int progress = 0;
  String? errorMessage;

  ProcessController({
    required this.apiService,
    required this.repository,
    required this.dataBaseService,
  });

  void performCalculations() async {
    debugPrint("[Start Calculations]");
    isProcessing = true;
    canSendToServer = false;
    showIndicator = true;
    errorMessage = null;
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = await repository.calculateShortestPath();
      dataBaseService.saveShortestPathToHive(result);
      debugPrint("[Shortest path] - $result");

      for (int i = 1; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        progress = i;
        notifyListeners();
      }

      canSendToServer = true;
    } catch (e) {
      errorMessage = "Calculation error: $e";
      debugPrint("Error: $e");
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> sendCalculationsToServer() async {
    isProcessing = true;
    navigateToNextScreen = false;
    showIndicator = false;
    errorMessage = null;
    notifyListeners();

    try {
      List<Map<String, dynamic>> payload = await repository.calculatePayload();
      navigateToNextScreen = await apiService.sendPathToServer(payload);
    } catch (e) {
      errorMessage = "$e";
      debugPrint("Error: $e");
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  void resetNavigationFlag() {
    canSendToServer = false;
    errorMessage = null;
    notifyListeners();
  }
}

/// PAYLOAD FOR TEST ERROR WITH STATUS 400 - Message incorrect
// List<Map<String, dynamic>> payload = [
//   {
//     'id': '7d785c38-cd54-4a98-ab57-44e50ae646c1',
//     'result': {
//       'steps': [
//         {'x': 1, 'y': 1},// 2.1
//         {'x': 1, 'y': 2},
//         {'x': 0, 'y': 2}
//       ],
//       'path': '(2,1)->(1,2)->(0,2)'
//     }
//   },
//   {
//     'id': '88746d24-bf68-4dea-a6b6-4a8fefb47eb9',
//     'result': {
//       'steps': [
//         {'x': 0, 'y': 3},
//         {'x': 1, 'y': 2},
//         {'x': 2, 'y': 1},
//         {'x': 3, 'y': 0}
//       ],
//       'path': '(0,3)->(1,2)->(2,1)->(3,0)'
//     }
//   }
// ];
