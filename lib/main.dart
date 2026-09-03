import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const PocUnimedApp(),
    ),
  );
}

class PocUnimedApp extends StatelessWidget {
  const PocUnimedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'POC Unimed',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRoutes.router,
    );
  }
}
