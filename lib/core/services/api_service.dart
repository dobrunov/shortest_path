import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../models/path_model.dart';
import '../models/server_response_model.dart';
import 'data_base_service.dart';

class ApiService {
  final DataBaseService dataBaseService = GetIt.instance<DataBaseService>();

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
    debugPrint("Send path to server");
    final String? savedUrl = await dataBaseService.getSavedUrl();

    if (savedUrl == null) {
      throw Exception("Saved URL is null");
    }

    final Uri url = Uri.parse(savedUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint("StatusCode: ${response.statusCode}");

        var parsedJson = json.decode(response.body);
        ServerResponse serverResponse = ServerResponse.fromJson(parsedJson);

        debugPrint("Message: ${serverResponse.message}");
        debugPrint("Data: ${serverResponse.data}");

        return true;
      } else if (response.statusCode == 500) {
        final errorResponse = json.decode(response.body);
        if (errorResponse['error'] == true) {
          debugPrint("Server Error: ${errorResponse['message']}");
          debugPrint("Error details: ${errorResponse['data']}");
          throw Exception(
            "Server error: ${errorResponse['message']}, details: ${errorResponse['data']}",
          );
        } else {
          throw Exception("Unexpected server error format.");
        }
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);

        if (errorResponse['error'] == true) {
          String message = errorResponse['message'] ?? 'Unknown error';
          debugPrint("Error message: $message");

          var data = errorResponse['data'] as List<dynamic>;
          for (var item in data) {
            String id = item['id'];
            bool isCorrect = item['correct'];
            debugPrint("ID: $id, Correct: $isCorrect");
          }

          throw message;
        } else {
          throw Exception("Unexpected error format in response body.");
        }
      } else {
        throw Exception(
          "Status: ${response.statusCode}, body: ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("[catch in api service]: $e");
      throw Exception("$e");
    }
  }

}
