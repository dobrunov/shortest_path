import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/path_model.dart';
import 'data_base_service.dart';

class ApiService {
  final DataBaseService dataBaseService;

  ApiService({required this.dataBaseService});

  Future<dynamic> getData() async {
    final url = await dataBaseService.getSavedUrl();

    if (url != null) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return PathModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch tasks. Status code: ${response.statusCode}');
      }
    }
  }

  Future<dynamic> putData() async {
    // final url = await dataBaseService.getSavedUrl();
    //
    // if (url != null) {
    //   final response = await http.put(Uri.parse(url));
    //
    //   if (response.statusCode == 200) {
    //     return jsonDecode(response.body);
    //   } else {
    //     throw Exception('Failed to fetch tasks. Status code: ${response.statusCode}');
    //   }
    // }
  }

  ///
}
