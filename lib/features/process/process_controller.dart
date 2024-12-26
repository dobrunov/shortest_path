import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core/models/grid_model.dart';
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
    debugPrint("[Start Calculations in controller]");
    isProcessing = true;
    canSendToServer = false;

    try {
      List<Map<String, dynamic>> result = await repository.calculateShortestPath();

      debugPrint("[SHORTEST PATH IN CONTROLLER] - $result");

      // save to data base
      dataBaseService.saveShortestPathToHive(result);

      canSendToServer = true;
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isProcessing = false;
      notifyListeners();
    }
    log("finish proc");
  }

  sendCalculationsToServer() async {
    navigateToNextScreen = false;
    // calculate payload
    List<Map<String, dynamic>> payload = await repository.calculatePayload();

    // send put request
    navigateToNextScreen = await apiService.sendPathToServer(payload);
    notifyListeners();
  }

  void resetNavigationFlag() {
    canSendToServer = false;
    notifyListeners();
  }
}
