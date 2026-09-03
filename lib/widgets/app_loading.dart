import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 220,
      child: LinearProgressIndicator(
        minHeight: 3,
        backgroundColor: Colors.white24,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
