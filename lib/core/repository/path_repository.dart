import 'package:flutter/cupertino.dart';
import 'package:shortest_path/core/services/api_service.dart';

import '../models/grid_model.dart';
import '../services/data_base_service.dart';

class PathRepository {
  final DataBaseService dataBaseService;
  final ApiService apiService;

  PathRepository({required this.dataBaseService, required this.apiService});

  Future<List<Map<String, dynamic>>> calculateShortestPath() async {
    debugPrint("[Calculate Shortest Path Start]");

    debugPrint("[getSavedPathModel]");
    final pathModel = await dataBaseService.getSavedPathModel();
    debugPrint("[pathModel] - ${pathModel.toString()}");

    if (pathModel == null || pathModel.error == true) {
      throw Exception('Path model not found or contains error');
    }

    if (pathModel.data == null || pathModel.data!.isEmpty) {
      throw Exception('No data available in path model');
    }

    List<Map<String, dynamic>> allPathsWithIds = [];

    for (var datum in pathModel.data!) {
      if (datum.field == null || datum.start == null || datum.end == null) {
        throw Exception('Invalid data in path model');
      }

      debugPrint("[Create Grid Object for ${datum.id}]");
      final grid = Grid(
        field: datum.field!,
        start: datum.start!,
        end: datum.end!,
        id: datum.id,
      );

      debugPrint("[Calculate Shortest Path for ${datum.id}]");
      var shPath = grid.findShortestPath();
      debugPrint("[The shortest path has been found for ${datum.id}] - $shPath");

      allPathsWithIds.add({
        'id': datum.id,
        'shortestPath': shPath,
      });
    }

    return allPathsWithIds;
  }

  Future<List<Map<String, dynamic>>> calculatePayload() async {
    debugPrint("[Calculate Payload Start]");

    debugPrint("[getSavedPathModel]");
    final pathModel = await dataBaseService.getSavedPathModel();
    debugPrint("[pathModel] - ${pathModel.toString()}");

    if (pathModel == null || pathModel.error == true) {
      throw Exception('Path model not found or contains error');
    }

    if (pathModel.data == null || pathModel.data!.isEmpty) {
      throw Exception('No data available in path model');
    }

    List<Map<String, dynamic>> allPayloads = [];

    for (var datum in pathModel.data!) {
      if (datum.field == null || datum.start == null || datum.end == null) {
        throw Exception('Invalid data in path model');
      }

      final grid = Grid(
        field: datum.field!,
        start: datum.start!,
        end: datum.end!,
        id: datum.id,
      );

      final List<Map<String, dynamic>>? shortestPath = await dataBaseService.getSavedShortestPath();

      allPayloads = grid.toResultJson(shortestPath);
      debugPrint("[allPayloads - $allPayloads]");
    }

    return allPayloads;
  }
}
