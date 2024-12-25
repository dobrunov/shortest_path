import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/path_model.dart';
import 'data_base_service.dart';

class ApiService {
  final DataBaseService dataBaseService;

  ApiService({required this.dataBaseService});

  Future<PathModel> getData() async {
    final url = await dataBaseService.getSavedUrl();

    if (url != null) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return PathModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch tasks. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('URL not found in the database.');
    }
  }

  Future<void> sendPathToServer(String id, List<Map<String, String>> steps, String path) async {
    final url = await dataBaseService.getSavedUrl();

    final payload = [
      {
        "id": id,
        "result": {
          "steps": steps,
          "path": path,
        }
      }
    ];

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("Success: ${response.body}");
      } else {
        print("Failed with status: ${response.statusCode}, body: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  ///
}
