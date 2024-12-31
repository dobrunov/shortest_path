import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  late Grid grid;

  @override
  void initState() {
    super.initState();
    _getScreenData();
  }

  void _getScreenData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resultListController = GetIt.instance<ResultListController>();
      resultListController.getResultsForScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultListController = GetIt.instance<ResultListController>();
    pathData = resultListController.pathData;
    if (resultListController.grid != null) {
      grid = resultListController.grid!;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Result list screen'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            itemCount: pathData?.length ?? 0,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
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
                  ),
                  if (index < (pathData?.length ?? 0) - 1) const Divider(color: Colors.grey, thickness: 0.5),
                ],
              );
            },
          ),
        ));
  }
}
