import 'dart:collection';

class Grid {
  final String? id;
  final List<List<String>> grid;
  final End start;
  final End end;

  final List<Points> directions = [
    Points(1, 0),
    Points(0, 1),
    Points(-1, 0),
    Points(0, -1),
    Points(1, 1),
    Points(1, -1),
    Points(-1, 1),
    Points(-1, -1),
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
  List<Points> findShortestPath() {
    Queue<Map<String, dynamic>> queue = Queue();
    Set<Points> visited = {};

    Points startPoint = Points(start.x!, start.y!);
    Points endPoint = Points(end.x!, end.y!);

    queue.add({
      'current': startPoint,
      'path': [startPoint]
    });
    visited.add(startPoint);

    while (queue.isNotEmpty) {
      final Map<String, dynamic> currentNode = queue.removeFirst();
      Points currentPoint = currentNode['current'];
      List<Points> currentPath = currentNode['path'];

      if (currentPoint == endPoint) {
        return currentPath;
      }

      for (final direction in directions) {
        int nx = currentPoint.x + direction.x;
        int ny = currentPoint.y + direction.y;

        if (isValid(nx, ny)) {
          Points nextPoint = Points(nx, ny);

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

  List<Map<String, dynamic>> toResultJson(List<Map<String, dynamic>>? shortestPaths) {
    try {
      if (shortestPaths == null || shortestPaths.isEmpty) {
        throw Exception("Shortest paths data is null or empty");
      }

      return shortestPaths.map((pathMap) {
        final id = pathMap['id'] as String?;
        final points = pathMap['shortestPath'] as List<Points>?;

        if (id == null || points == null) {
          throw Exception("Invalid data structure in shortestPaths");
        }

        final pathString = points.map((point) => '(${point.x},${point.y})').join('->');
        final steps = points
            .map((point) => {
                  "x": point.x.toString(),
                  "y": point.y.toString(),
                })
            .toList();

        return {
          "id": id,
          "result": {
            "steps": steps,
            "path": pathString,
          }
        };
      }).toList();
    } catch (e, stackTrace) {
      print("Error occurred in toResultJson: $e");
      print("Stack trace: $stackTrace");

      return [];
    }
  }
}

class Points {
  final int x;
  final int y;

  Points(this.x, this.y);

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      json['x'] as int,
      json['y'] as int,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Points && x == other.x && y == other.y);

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
