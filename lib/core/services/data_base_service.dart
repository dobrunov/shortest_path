import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/path_model.dart';
import '../models/points_model.dart';
import '../models/url_model.dart';

class DataBaseService {
  late Box<UrlModel> urlBox;
  late Box<String> pathModelBox;
  late Box<String> shortestPathBox;

  bool isInitialized = false;

  DataBaseService({
    required this.urlBox,
    required this.pathModelBox,
    required this.shortestPathBox,
  });
  //
  // URL --------------------------------------------------------
  //
  Future<void> saveUrlToHive(String url) async {
    final urlModel = UrlModel(url: url);
    await urlBox.put('savedUrl', urlModel);
  }

  Future<String?> getSavedUrl() async {
    final urlModel = urlBox.get('savedUrl');
    return urlModel?.url;
  }

  //
  // Path Model --------------------------------------------------
  //
  Future<void> savePathModelToHive(PathModel pathModel) async {
    final jsonString = jsonEncode(pathModel.toJson());
    await pathModelBox.put('savedPathModel', jsonString);
    debugPrint("savedPathModel - ok");
  }

  Future<PathModel?> getSavedPathModel() async {
    final jsonString = pathModelBox.get('savedPathModel');
    if (jsonString != null) {
      return PathModel.fromJson(jsonDecode(jsonString));
    } else {
      return null;
    }
  }

  //
  // Shortest Path -----------------------------------------------
  //
  Future<void> saveShortestPathToHive(List<Map<String, dynamic>> shortestPaths) async {
    final jsonPathList = shortestPaths.map((path) {
      return {
        'id': path['id'],
        'shortestPath': (path['shortestPath'] as List<Points>).map((point) => point.toJson()).toList(),
      };
    }).toList();

    await shortestPathBox.put('savedShortestPath', jsonEncode(jsonPathList));
  }

  //
  // Get Shortest Path -------------------------------------------
  //
  Future<List<Map<String, dynamic>>?> getSavedShortestPath() async {
    final jsonString = shortestPathBox.get('savedShortestPath');

    if (jsonString != null) {
      final jsonPathList = jsonDecode(jsonString) as List<dynamic>;

      return jsonPathList.map((pathJson) {
        final pathMap = pathJson as Map<String, dynamic>;
        return {
          'id': pathMap['id'],
          'shortestPath': (pathMap['shortestPath'] as List<dynamic>).map((pointJson) {
            return Points.fromJson(pointJson as Map<String, dynamic>);
          }).toList(),
        };
      }).toList();
    } else {
      return null;
    }
  }
}
