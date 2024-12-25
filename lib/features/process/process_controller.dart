import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class ProcessController extends ChangeNotifier {
  bool isProcessing = false;
  bool navigateToNextScreen = false;

  ProcessController();

  Future<void> performCalculations() async {
    log("start proc");
    isProcessing = true;
    navigateToNextScreen = false;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 3));

      navigateToNextScreen = true;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isProcessing = false;
      notifyListeners();
    }
    log("finish proc");
  }

  void resetNavigationFlag() {
    navigateToNextScreen = false;
    notifyListeners();
  }
}
