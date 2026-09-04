import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/secure_storage_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Duration _minimumSplashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final stopwatch = Stopwatch()..start();

    try {
      final storage = SecureStorageService();

      final refreshToken = await storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await _goToLoginAfterMinimumTime(stopwatch);
        return;
      }

      final response = await AuthService().refreshToken(
        refreshToken: refreshToken,
      );

      await storage.saveAccessToken(response['access_token']);

      await storage.saveRefreshToken(response['refresh_token']);

      if (!mounted) {
        return;
      }

      context.go('/home');
    } catch (_) {
      await SecureStorageService().clear();

      await _goToLoginAfterMinimumTime(stopwatch);
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> _goToLoginAfterMinimumTime(Stopwatch stopwatch) async {
    final remainingTime = _minimumSplashDuration - stopwatch.elapsed;

    if (remainingTime > Duration.zero) {
      await Future<void>.delayed(remainingTime);
    }

    if (!mounted) {
      return;
    }

    context.go('/login');
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
              AppLogo(width: DS.logoWidth),
              SizedBox(height: DS.spaceXXl),
              AppLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
