import 'package:flutter/material.dart';

import '../../../widgets/app_logo.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppLogo(),

        SizedBox(height: 24),

        Text(
          'Bem-vindo',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 8),

        Text('Acesse sua conta Unimed Porto Alegre'),
      ],
    );
  }
}
