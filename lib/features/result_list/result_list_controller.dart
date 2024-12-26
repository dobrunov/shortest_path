import 'package:flutter/material.dart';

import '../../core/models/grid_model.dart';
import '../../core/repository/path_repository.dart';
import '../../core/services/api_service.dart';
import '../../core/services/data_base_service.dart';

class ResultListController extends ChangeNotifier {
  final ApiService apiService;
  final PathRepository repository;
  final DataBaseService dataBaseService;

  // bool isProcessing = false;
  // bool canSendToServer = false;
  List<PathData>? pathData;
  // bool navigateToNextScreen = false;

  ResultListController({
    required this.apiService,
    required this.repository,
    required this.dataBaseService,
  });

  getResultsForScreen() async {
    pathData = await parseSavedShortestPath();

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
}

class PathData {
  final String id;
  final List<Points> shortestPath;
  final String pathString;

  PathData({
    required this.id,
    required this.shortestPath,
    required this.pathString,
  });

  factory PathData.fromMap(Map<String, dynamic> map) {
    final shortestPath = (map['shortestPath'] as List<dynamic>).map((pointJson) {
      if (pointJson is Points) {
        return pointJson;
      } else if (pointJson is Map<String, dynamic>) {
        return Points.fromJson(pointJson);
      } else {
        throw Exception('Unexpected type for pointJson: ${pointJson.runtimeType}');
      }
    }).toList();

    final pathString = shortestPath.map((point) => '(${point.x},${point.y})').join('->');

    return PathData(
      id: map['id'] as String,
      shortestPath: shortestPath,
      pathString: pathString,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortestPath': shortestPath.map((point) => point.toJson()).toList(),
      'pathString': pathString,
    };
  }

  @override
  String toString() {
    return 'PathData(id: $id, shortestPath: $shortestPath, pathString: $pathString)';
  }
}
