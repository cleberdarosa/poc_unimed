import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../core/utils/app_logger.dart';
import '../../models/auth_response.dart';
import '../../repositories/auth_repository.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Duration _minimumSplashDuration = Duration(seconds: 5);

  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    AppLogger.splash(
      'Splash iniciada. Tempo mínimo: '
      '${_minimumSplashDuration.inSeconds} segundos.',
    );

    final minimumTime = Future<void>.delayed(_minimumSplashDuration);

    SessionRestoreResult result;

    try {
      AppLogger.splash('Solicitando restauração da sessão.');
      result = await _authRepository.restoreSession();
      AppLogger.splash('Restauração concluída: $result.');
    } catch (error, stackTrace) {
      AppLogger.error(
        'SPLASH',
        'Erro não tratado durante a restauração.',
        error: error,
        stackTrace: stackTrace,
      );
      await _authRepository.logout();
      result = SessionRestoreResult.unauthenticated;
    }

    AppLogger.splash('Aguardando o tempo mínimo da Splash.');
    await minimumTime;

    if (!mounted) {
      AppLogger.splash('Splash não está mais montada. Navegação cancelada.');
      return;
    }

    switch (result) {
      case SessionRestoreResult.authenticated:
        AppLogger.splash('Sessão autenticada. Navegando para Home.');
        context.go('/home');

      case SessionRestoreResult.unauthenticated:
        AppLogger.splash('Sessão não autenticada. Navegando para Login.');
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
