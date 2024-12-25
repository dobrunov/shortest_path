import 'package:flutter/material.dart';

import '../result_detail/result_detail_screen.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> results = ["Result 1", "Result 2"];

    /// TODO: Get results from data base if server = ok
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index]),
            onTap: () {
              String shortestPath = "A -> B -> C";
              List<List<String>> grid = [
                ['S', '.', '.', 'X'],
                ['.', 'X', '.', '.'],
                ['.', '.', 'X', 'E'],
              ];
              List<List<int>> pathCoordinates = [
                [0, 0],
                [1, 1],
                [2, 2]
              ];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultDetailScreen(
                    shortestPath: shortestPath,
                    grid: grid,
                    pathCoordinates: pathCoordinates,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
