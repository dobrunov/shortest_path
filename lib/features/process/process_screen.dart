import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final controller = Provider.of<ProcessController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!controller.isProcessing && controller.canSendToServer)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text("All calculations have finished, you can send your results to the server"),
                    ),
                  if (controller.isProcessing)
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: CircularProgressIndicator(
                          color: Colors.blue[200],
                          strokeWidth: 20.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: controller.isProcessing
                  ? null
                  : () {
                      controller.sendCalculationsToServer();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Send Result to server"),
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
