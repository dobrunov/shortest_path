import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortest_path/features/result_list/result_list_controller.dart';

import '../../core/models/grid_model.dart';
import '../../core/models/path_model.dart';
import '../result_detail/result_detail_screen.dart';

class ResultListScreen extends StatefulWidget {
  const ResultListScreen({super.key});

  @override
  State<ResultListScreen> createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {
  List<PathData>? pathData;
  late final String id;
  late ResultListController resultListController;
  late Grid grid;

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

  @override
  Widget build(BuildContext context) {
    resultListController = Provider.of<ResultListController>(context);
    pathData = resultListController.pathData;
    if (resultListController.grid != null) {
      grid = resultListController.grid!;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: ListView.builder(
        itemCount: pathData?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pathData?[index].pathString ?? 'No Path String'),
            onTap: () {
              final String itemId = pathData?[index].id ?? "";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultDetailScreen(
                    index: index,
                    id: itemId,
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
