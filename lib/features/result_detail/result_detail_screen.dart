import 'package:flutter/material.dart';

class ResultDetailScreen extends StatelessWidget {
  final String shortestPath;
  final List<List<String>> grid;
  final List<List<int>> pathCoordinates;

  const ResultDetailScreen({
    super.key,
    required this.shortestPath,
    required this.grid,
    required this.pathCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result Details')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Shortest Path: $shortestPath',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: grid[0].length,
                childAspectRatio: 1.0,
              ),
              itemCount: grid.length * grid[0].length,
              itemBuilder: (context, index) {
                int row = index ~/ grid[0].length;
                int col = index % grid[0].length;

                Color cellColor;
                if (pathCoordinates.contains([row, col])) {
                  cellColor = const Color(0xFF4CAF50);
                } else if (grid[row][col] == 'S') {
                  cellColor = const Color(0xFF64FFDA);
                } else if (grid[row][col] == 'E') {
                  cellColor = const Color(0xFF009688);
                } else if (grid[row][col] == 'X') {
                  cellColor = const Color(0xFF000000);
                } else {
                  cellColor = const Color(0xFFFFFFFF);
                }

                return Container(
                  decoration: BoxDecoration(
                    color: cellColor,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      '($row.$col)',
                      style: TextStyle(
                        color: cellColor == const Color(0xFF000000) ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
