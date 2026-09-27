import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void auth(String message) {
    _log('AUTH', message);
  }

  static void session(String message) {
    _log('SESSION', message);
  }

  static void splash(String message) {
    _log('SPLASH', message);
  }

  static void familia(String message) {
    _log('FAMILIA', message);
  }

  static void home(String message) {
    _log('HOME', message);
  }

  static void error(
    String scope,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[$scope][ERROR] $message');

    if (error != null) {
      debugPrint('[$scope][ERROR] Tipo: ${error.runtimeType}');
    }

    if (stackTrace != null) {
      debugPrintStack(label: '[$scope][STACK]', stackTrace: stackTrace);
    }
  }

  static void _log(String scope, String message) {
    if (kDebugMode) {
      debugPrint('[$scope] $message');
    }
  }
}
