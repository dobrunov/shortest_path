class PathModel {
  final bool? error;
  final String? message;
  final List<Datum>? data;

  PathModel({
    this.error,
    this.message,
    this.data,
  });

  factory PathModel.fromJson(Map<String, dynamic> json) => PathModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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

class Datum {
  final String? id;
  final List<String>? field;
  final End? start;
  final End? end;

  Datum({
    this.id,
    this.field,
    this.start,
    this.end,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        field: json["field"] == null ? [] : List<String>.from(json["field"]!.map((x) => x)),
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        end: json["end"] == null ? null : End.fromJson(json["end"]),
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

class End {
  final int? x;
  final int? y;

  End({
    this.x,
    this.y,
  });

  factory End.fromJson(Map<String, dynamic> json) => End(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };

  @override
  String toString() {
    return 'End(x: $x, y: $y)';
  }
}
