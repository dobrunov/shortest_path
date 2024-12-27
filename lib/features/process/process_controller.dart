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
  List<List<Points>>? shortestPath;
  bool navigateToNextScreen = false;

  ProcessController({
    required this.apiService,
    required this.repository,
    required this.dataBaseService,
  });

  void performCalculations() async {
    debugPrint("[Start Calculations]");
    isProcessing = true;
    canSendToServer = false;
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = await repository.calculateShortestPath();
      dataBaseService.saveShortestPathToHive(result);
      debugPrint("[Shortest path] - $result");

      canSendToServer = true;
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      isProcessing = false;
      notifyListeners();
    }
  }

  sendCalculationsToServer() async {
    isProcessing = true;
    navigateToNextScreen = false;
    notifyListeners();

    List<Map<String, dynamic>> payload = await repository.calculatePayload();
    navigateToNextScreen = await apiService.sendPathToServer(payload);
    await Future.delayed(const Duration(seconds: 2));
    isProcessing = false;
    notifyListeners();
  }

  void resetNavigationFlag() {
    canSendToServer = false;
    notifyListeners();
  }
}
