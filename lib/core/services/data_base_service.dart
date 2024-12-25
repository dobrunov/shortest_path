import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/path_model.dart';
import '../models/url_model.dart';

class DataBaseService {
  late Box<String> pathModelBox;
  late Box<UrlModel> urlBox;
  bool isInitialized = false;

  DataBaseService({required this.urlBox, required this.pathModelBox});

  Future<void> saveUrlToHive(String url) async {
    final urlModel = UrlModel(url: url);
    await urlBox.put('savedUrl', urlModel);
  }

  Future<String?> getSavedUrl() async {
    final urlModel = urlBox.get('savedUrl');
    return urlModel?.url;
  }

  Future<void> savePathModelToHive(PathModel pathModel) async {
    final jsonString = jsonEncode(pathModel.toJson());
    await pathModelBox.put('savedPathModel', jsonString);
  }

  Future<PathModel?> getSavedPathModel() async {
    final jsonString = pathModelBox.get('savedPathModel');
    if (jsonString != null) {
      return PathModel.fromJson(jsonDecode(jsonString));
    } else {
      return null;
    }
  }
}
