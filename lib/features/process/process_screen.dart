import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_elevated_button.dart';
import '../../core/widgets/custom_progress_indicator.dart';
import '../result_list/result_list_screen.dart';
import 'process_controller.dart';

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  void _startProcessing() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProcessController>(context, listen: false);
      controller.performCalculations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final processController = GetIt.instance<ProcessController>();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (processController.errorMessage != null)
                      SizedBox(
                        height: 130.0,
                        child: Center(
                          child: Text(
                            processController.errorMessage ?? "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (!processController.isProcessing && processController.canSendToServer && processController.errorMessage == null)
                      const SizedBox(
                        height: 130.0,
                        child: Center(
                          child: Text(
                            "All calculations have finished, you can send your results to the server",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (processController.isProcessing) const CustomProgressIndicator(),
                    //
                    if (processController.showIndicator)
                      Text(
                        "${processController.progress}%",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    //
                    const Spacer(),
                    CustomElevatedButton(
                      label: "Send Result to server",
                      onPressed: processController.isProcessing
                          ? null
                          : () {
                        processController.sendCalculationsToServer();
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Selector<ProcessController, bool>(
            selector: (_, controller) => controller.navigateToNextScreen,
            builder: (context, navigateToNext, _) {
              if (navigateToNext) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResultListScreen(),
                    ),
                  );
                });
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
