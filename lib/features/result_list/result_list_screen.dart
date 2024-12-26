import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortest_path/features/result_list/result_list_controller.dart';

class ResultListScreen extends StatefulWidget {
  const ResultListScreen({super.key});

  @override
  State<ResultListScreen> createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {
  List<PathData>? pathData;

  @override
  void initState() {
    super.initState();
    _getScreenData();
  }

  void _getScreenData() {
    // Schedule the asynchronous call to the controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ResultListController>(context, listen: false);
      controller.getResultsForScreen();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   pathData = Provider.of<ResultListController>(context).pathData;
  //
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Results')),
  //     body: ListView.builder(
  //       itemCount: pathData?.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           title: Text(pathData![index].pathString.toString()),
  //           onTap: () {
  //             // String shortestPath = "A -> B -> C";
  //             // List<List<String>> grid = [
  //             //   ['S', '.', '.', 'X'],
  //             //   ['.', 'X', '.', '.'],
  //             //   ['.', '.', 'X', 'E'],
  //             // ];
  //             // List<List<int>> pathCoordinates = [
  //             //   [0, 0],
  //             //   [1, 1],
  //             //   [2, 2]
  //             // ];
  //
  //             // Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(
  //             //     builder: (context) => ResultDetailScreen(
  //             //       shortestPath: shortestPath,
  //             //       grid: grid,
  //             //       pathCoordinates: pathCoordinates,
  //             //     ),
  //             //   ),
  //             // );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    pathData = Provider.of<ResultListController>(context).pathData;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: ListView.builder(
        itemCount: pathData?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pathData?[index].pathString ?? 'No Path String'),
            onTap: () {
              //
            },
          );
        },
      ),
    );
  }
}
