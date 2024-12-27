import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:shortest_path/core/models/points_model.dart';

class Grid {
  final String? id;
  List<List<String>> grid;
  final Points start;
  final Points end;

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

    Points startPoint = Points(start.x, start.y);
    Points endPoint = Points(end.x, end.y);

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
      debugPrint("Error occurred in toResultJson: $e");
      debugPrint("Stack trace: $stackTrace");

      return [];
    }
  }
}
