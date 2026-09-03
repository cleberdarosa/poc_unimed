import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;

  const AppLogo({super.key, this.width = 220});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png', width: width);
  }
}
