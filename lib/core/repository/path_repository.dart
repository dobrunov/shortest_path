import 'dart:developer';

import 'package:shortest_path/core/services/api_service.dart';

import '../models/grid_model.dart';
import '../services/data_base_service.dart';

class PathRepository {
  final DataBaseService dataBaseService;

  final ApiService apiService;

  PathRepository({required this.dataBaseService, required this.apiService});

  Future<List<Point>> calculateShortestPath() async {
    log("calculateShortestPath");
    final pathModel = await dataBaseService.getSavedPathModel();

    log(pathModel!.data!.first.id.toString());

    if (pathModel == null || pathModel.error == true) {
      throw Exception('Path model not found or contains error');
    }

    final datum = pathModel.data?.first;
    if (datum == null || datum.field == null || datum.start == null || datum.end == null) {
      throw Exception('Invalid data in path model');
    }
    log(pathModel!.data!.first.field.toString());
    print(datum.field.toString());

    final grid = Grid(
      field: datum.field!,
      start: datum.start!,
      end: datum.end!,
      id: datum.id,
    );
    // var shPath = grid.findShortestPath();
    // apiService.sendPathToServer(datum.id.toString(), shPath);

    return grid.findShortestPath();
    // return [];
  }
}
