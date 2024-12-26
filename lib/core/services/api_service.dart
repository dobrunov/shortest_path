import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/path_model.dart';
import '../models/server_response_model.dart';
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

  Future<bool> sendPathToServer(var payload) async {
    bool responseSuccess = false;
    debugPrint("send to server");
    final String? savedUrl = await dataBaseService.getSavedUrl();

    if (savedUrl == null) {
      debugPrint("Error: Saved URL is null");
    }

    final Uri url;

    url = Uri.parse(savedUrl!);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        responseSuccess = true;
        debugPrint("StatusCode: ${response.statusCode}");
        var parsedJson = json.decode(response.body);

        ServerResponse serverResponse = ServerResponse.fromJson(parsedJson);

        debugPrint("Error: ${serverResponse.error}");
        debugPrint("Message: ${serverResponse.message}");
        debugPrint("Data: ${serverResponse.data}");
      } else {
        if (response.statusCode == 500) {
          debugPrint("StatusCode: ${response.statusCode}");
          final errorResponse = json.decode(response.body);
          debugPrint("Server Error: ${errorResponse['message']}");
          debugPrint("Error details: ${errorResponse['data']}");
        }

        ///
        debugPrint("Failed with status: ${response.statusCode}, body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return responseSuccess;
  }
}