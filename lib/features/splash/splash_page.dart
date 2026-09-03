import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_logo.dart';

import '../../core/storage/secure_storage_service.dart';
import '../../services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final storage = SecureStorageService();

      final refreshToken = await storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      final response = await AuthService().refreshToken(
        refreshToken: refreshToken,
      );

      await storage.saveAccessToken(response['access_token']);

      await storage.saveRefreshToken(response['refresh_token']);

      if (!mounted) return;

      context.go('/home');
    } catch (_) {
      await SecureStorageService().clear();

      if (!mounted) return;

      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(width: 220),

              SizedBox(height: DS.spaceXXl),

              AppLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
