import 'dart:collection';

class Grid {
  final String? id;
  final List<List<String>> grid;
  final End start;
  final End end;

  final List<Point> directions = [
    Point(1, 0),
    Point(0, 1),
    Point(-1, 0),
    Point(0, -1),
    Point(1, 1),
    Point(1, -1),
    Point(-1, 1),
    Point(-1, -1),
  ];

  Grid({
    required this.id,
    required List<String> field,
    required this.start,
    required this.end,
  }) : grid = _parseField(field);

  static List<List<String>> _parseField(List<String> field) {
    return field.map((row) => row.split('')).toList();
  }

  bool isValid(int x, int y) {
    return x >= 0 && x < grid.length && y >= 0 && y < grid[0].length && grid[x][y] == '.';
  }

  /// BFS
  List<Point> findShortestPath() {
    Queue<Map<String, dynamic>> queue = Queue();
    Set<Point> visited = {};

    Point startPoint = Point(start.x!, start.y!);
    Point endPoint = Point(end.x!, end.y!);

    queue.add({
      'current': startPoint,
      'path': [startPoint]
    });
    visited.add(startPoint);

    while (queue.isNotEmpty) {
      final Map<String, dynamic> currentNode = queue.removeFirst();
      Point currentPoint = currentNode['current'];
      List<Point> currentPath = currentNode['path'];

      if (currentPoint == endPoint) {
        return currentPath;
      }

      for (final direction in directions) {
        int nx = currentPoint.x + direction.x;
        int ny = currentPoint.y + direction.y;

        if (isValid(nx, ny)) {
          Point nextPoint = Point(nx, ny);

          if (!visited.contains(nextPoint)) {
            visited.add(nextPoint);
            queue.add({
              'current': nextPoint,
              'path': [...currentPath, nextPoint]
            });
          }
        }
      }
    }

    return [];
  }

  Datum toDatum(List<Point> path) {
    return Datum(
      id: id,
      field: path.map((point) => '(${point.x}, ${point.y})').toList(),
      start: End(x: start.x, y: start.y),
      end: End(x: end.x, y: end.y),
    );
  }
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Point && x == other.x && y == other.y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => '($x, $y)';
}

class End {
  final int? x;
  final int? y;

  End({this.x, this.y});

  factory End.fromJson(Map<String, dynamic> json) => End(
        x: json['x'],
        y: json['y'],
      );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };

  @override
  String toString() => 'End(x: $x, y: $y)';
}

class Datum {
  final String? id;
  final List<String>? field;
  final End? start;
  final End? end;

  Datum({this.id, this.field, this.start, this.end});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['id'],
        field: json['field'] == null ? [] : List<String>.from(json['field']!.map((x) => x)),
        start: json['start'] == null ? null : End.fromJson(json['start']),
        end: json['end'] == null ? null : End.fromJson(json['end']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'field': field == null ? [] : List<dynamic>.from(field!.map((x) => x)),
        'start': start?.toJson(),
        'end': end?.toJson(),
      };

  @override
  String toString() {
    return 'Datum(id: $id, field: $field, start: $start, end: $end)';
  }
}
