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
    // Schedule the asynchronous call to the controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProcessController>(context, listen: false);
      controller.performCalculations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProcessController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Process Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isProcessing)
              const CircularProgressIndicator()
            else if (controller.canSendToServer)
              ElevatedButton(
                onPressed: () {
                  debugPrint("PRESSED");
                  controller.sendCalculationsToServer();
                },
                child: const Text('Send Result to server'),
              )
            else
              const Text('Waiting to start calculations...'),
            Selector<ProcessController, bool>(
              selector: (_, controller) => controller.navigateToNextScreen,
              builder: (context, navigateToNext, _) {
                if (navigateToNext) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // apiController.resetNavigationFlag();
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
      ),
    );
  }
}
