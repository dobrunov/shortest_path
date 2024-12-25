import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core/models/grid_model.dart';
import '../../core/repository/path_repository.dart';
import '../../core/services/api_service.dart';

class ProcessController extends ChangeNotifier {
  bool isProcessing = false;
  bool canSendToServer = false;

  final PathRepository repository;
  List<Point>? shortestPath;

  ApiService apiService;

  ProcessController({required this.apiService, required this.repository});

  void performCalculations() async {
    log("start proc");
    isProcessing = true;
    canSendToServer = false;

    try {
      List<Point> result = (await repository.calculateShortestPath()).cast<Point>();
      shortestPath = result;

      print("SHORTEST PATH - $result");
      log("SHORTEST PATH - $result");

      /// TODO save to base
      canSendToServer = true;
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isProcessing = false;
      notifyListeners();
    }
    log("finish proc");
  }

  void resetNavigationFlag() {
    canSendToServer = false;
    notifyListeners();
  }
}
