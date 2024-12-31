import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_elevated_button.dart';
import '../../core/widgets/custom_progress_indicator.dart';
import '../process/process_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _urlController.addListener(() {
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  void _handleSubmit(HomeController apiController) {
    const validUrl = r'^https:\/\/flutter\.webspark\.dev\/flutter\/api$';

    if (!RegExp(validUrl).hasMatch(_urlController.text)) {
      setState(() {
        _errorMessage = 'Set valid API base URL in order to continue';
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
      apiController.createRequest(_urlController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = GetIt.instance<HomeController>();
    //
    if (homeController.navigateToNextScreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        homeController.resetNavigationFlag();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProcessScreen(),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'API Base URL',
                      labelStyle: const TextStyle(color: Colors.black),
                      errorText: homeController.errorMessage,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      floatingLabelStyle: const TextStyle(color: Colors.blue),
                    ),
                    controller: _urlController,
                  ),
                  if (homeController.isLoading)
                    const Center(
                      child: CustomProgressIndicator(),
                    ),
                  const Spacer(),
                  CustomElevatedButton(
                    label: "Send",
                    onPressed: () {
                      _handleSubmit(homeController);
                    },
                  ),
                ],
              ),
            ),
          ),
          // ValueListenableBuilder<bool>(
          //   valueListenable: homeController.navigateToNextScreenNotifier,
          //   builder: (context, navigateToNext, _) {
          //     if (navigateToNext) {
          //       WidgetsBinding.instance.addPostFrameCallback((_) {
          //         homeController.resetNavigationFlag();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const ProcessScreen(),
          //           ),
          //         );
          //       });
          //     }
          //     return const SizedBox();
          //   },
          // ),

          // Selector<HomeController, bool>(
          //   selector: (_, controller) => homeController.navigateToNextScreen,
          //   builder: (context, navigateToNext, _) {
          //     if (navigateToNext) {
          //       WidgetsBinding.instance.addPostFrameCallback((_) {
          //         homeController.resetNavigationFlag();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const ProcessScreen(),
          //           ),
          //         );
          //       });
          //     }
          //     return const SizedBox();
          //   },
          // ),
        ],
      ),
    );
  }
}
