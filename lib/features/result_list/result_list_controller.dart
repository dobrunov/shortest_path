import 'package:flutter/material.dart';

import '../../core/models/grid_model.dart';
import '../../core/models/path_model.dart';
import '../../core/repository/path_repository.dart';
import '../../core/services/data_base_service.dart';

class ResultListController extends ChangeNotifier {
  final PathRepository repository;
  final DataBaseService dataBaseService;

  bool isLoading = false;
  List<PathData>? pathData;
  List<List<int>>? pathCoordinates;
  Grid? grid;

  ResultListController({
    required this.repository,
    required this.dataBaseService,
  });

  void getResultsForScreen() async {
    pathData = await parseSavedShortestPath();
    debugPrint("get results for screen - ${pathData.toString()}");

    notifyListeners();
  }

  Future<List<PathData>?> parseSavedShortestPath() async {
    final data = await dataBaseService.getSavedShortestPath();

    if (data != null) {
      return data.map((map) => PathData.fromMap(map)).toList();
    } else {
      return null;
    }
  }

  Future<void> takeGrid(String id) async {
    _startLoading();
    grid = await repository.takeGrid(id);
    _stopLoading();
  }

  void getPathCoordinates(String id) async {
    _startLoading();
    if (pathData != null) {
      pathCoordinates = pathData!.where((path) => path.id == id).expand((path) => path.shortestPath.map((point) => [point.x, point.y])).toList();
    }
    _stopLoading();
  }

  void _startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }
}
