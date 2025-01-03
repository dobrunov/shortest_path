import 'package:shortest_path/core/models/points_model.dart';

class PathModel {
  final bool? error;
  final String? message;
  final List<Task>? data;

  PathModel({
    this.error,
    this.message,
    this.data,
  });

  factory PathModel.fromJson(Map<String, dynamic> json) => PathModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Task>.from(json["data"]!.map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'PathModel(error: $error, message: $message, data: $data)';
  }
}

class Task {
  final String? id;
  final List<String>? field;
  final Points? start;
  final Points? end;

  Task({
    this.id,
    this.field,
    this.start,
    this.end,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        field: json["field"] == null ? [] : List<String>.from(json["field"]!.map((x) => x)),
        start: json["start"] == null ? null : Points.fromJson(json["start"]),
        end: json["end"] == null ? null : Points.fromJson(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "field": field == null ? [] : List<dynamic>.from(field!.map((x) => x)),
        "start": start?.toJson(),
        "end": end?.toJson(),
      };

  @override
  String toString() {
    return 'Datum(id: $id, field: $field, start: $start, end: $end)';
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
