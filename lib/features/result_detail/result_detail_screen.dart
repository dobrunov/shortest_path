import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/path_model.dart';
import '../result_list/result_list_controller.dart';

class ResultDetailScreen extends StatefulWidget {
  final int index;
  final String id;

  const ResultDetailScreen({super.key, required this.id, required this.index});

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  List<PathData>? pathData;
  List<List<String>> grid = [
    ['.', '.', '.'],
    ['.', '.', '.'],
    ['.', '.', '.'],
  ];
  List<List<int>>? pathCoordinates;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final controller = Provider.of<ResultListController>(context, listen: false);
    await controller.takeGrid(widget.id);
    controller.getPathCoordinates(widget.id);
    setState(() {
      grid = controller.grid?.grid ?? grid;
      pathCoordinates = controller.pathCoordinates;
      pathData = controller.pathData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ResultListController>(context);

    if (controller.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (pathData == null || pathData!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No path data available.')),
      );
    }

    final pathSet = pathCoordinates != null ? pathCoordinates!.map((e) => '${e[0]}_${e[1]}').toSet() : <String>{};
    debugPrint(grid.toString());
    debugPrint(pathSet.toString());

    return Scaffold(
      appBar: AppBar(title: const Text('Result Details')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Shortest Path: ${pathData?[widget.index].pathString}',
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
                if (grid[row][col] == 'S') {
                  cellColor = const Color(0xFF64FFDA); // Start cell color
                } else if (grid[row][col] == 'F') {
                  cellColor = const Color(0xFF009688); // Endpoint color
                } else if (pathSet.contains('${row}_$col')) {
                  cellColor = const Color(0xFF4CAF50); // Path color
                } else if (grid[row][col] == 'X') {
                  cellColor = const Color(0xFF000000); // Obstacle color
                } else {
                  cellColor = const Color(0xFFFFFFFF); // Default cell color
                }

                return Container(
                  decoration: BoxDecoration(
                    color: cellColor,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      '($row, $col)',
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
