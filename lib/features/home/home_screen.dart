import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../process/process_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final apiController = Provider.of<HomeController>(context);
    _urlController.text = "https://flutter.webspark.dev/flutter/api";

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Set valid API base URL in order to continue',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'API Base URL',
                      errorText: apiController.errorMessage,
                    ),
                    controller: _urlController,
                  ),
                  const SizedBox(height: 20),
                  if (apiController.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      apiController.createRequest(_urlController.text);
                    },
                    child: const Text("Send"),
                  )
                ],
              ),
            ),
          ),
          Selector<HomeController, bool>(
            selector: (_, controller) => controller.navigateToNextScreen,
            builder: (context, navigateToNext, _) {
              if (navigateToNext) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  apiController.resetNavigationFlag();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProcessScreen(),
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
