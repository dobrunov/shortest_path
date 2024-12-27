import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(
        width: 70,
        height: 70,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: CircularProgressIndicator(
            color: Colors.blue[200],
            strokeWidth: 10.0,
          ),
        ),
      ),
    );
  }
}
