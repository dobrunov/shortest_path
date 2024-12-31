import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shortest_path/core/services/api_service.dart';

import '../models/grid_model.dart';
import '../services/data_base_service.dart';

class PathRepository {
  final ApiService apiService = GetIt.instance<ApiService>();
  final DataBaseService dataBaseService = GetIt.instance<DataBaseService>();

  Future<List<Map<String, dynamic>>> calculateShortestPath() async {
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

      final grid = Grid(
        field: datum.field!,
        start: datum.start!,
        end: datum.end!,
        id: datum.id,
      );

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
      debugPrint("[allPayloads] - $allPayloads");
    }

    return allPayloads;
  }

  Future<Grid?> takeGrid(id) async {
    debugPrint("[takeGrid Start]");

    Grid? grid;

    final pathModel = await dataBaseService.getSavedPathModel();

    if (pathModel == null || pathModel.error == true) {
      throw Exception('Path model not found or contains error');
    }

    if (pathModel.data == null || pathModel.data!.isEmpty) {
      throw Exception('No data available in path model');
    }

    for (var datum in pathModel.data!) {
      if (datum.field == null || datum.start == null || datum.end == null) {
        throw Exception('Invalid data in path model');
      }

      if (datum.id == id) {
        grid = Grid(
          field: datum.field!,
          start: datum.start!,
          end: datum.end!,
          id: datum.id,
        );

        if (grid.isValid(grid.start.x, grid.start.y)) {
          grid.grid[grid.start.x][grid.start.y] = 'S';
        }
        if (grid.isValid(grid.end.x, grid.end.y)) {
          grid.grid[grid.end.x][grid.end.y] = 'F';
        }
        break;
      }
    }

    return grid;
  }
}
