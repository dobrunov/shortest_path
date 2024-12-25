import 'package:hive/hive.dart';

import '../models/url_model.dart';

class DataBaseService {
  late Box<UrlModel> urlBox;
  bool isInitialized = false;

  DataBaseService({required this.urlBox});

  Future<void> saveUrlToHive(String url) async {
    final urlModel = UrlModel(url: url);
    await urlBox.put('savedUrl', urlModel);
  }

  Future<String?> getSavedUrl() async {
    final urlModel = urlBox.get('savedUrl');
    return urlModel?.url;
  }
}
