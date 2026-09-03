import 'package:flutter/foundation.dart';

import '../core/storage/secure_storage_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final SecureStorageService _storage = SecureStorageService();

  bool isAuthenticated = false;

  bool isLoading = false;

  String? accessToken;

  String? refreshToken;

  Future<bool> login({required String cpf, required String senha}) async {
    try {
      isLoading = true;
      notifyListeners();

      // API 1 - Authorization
      final authorizationResponse = await _authService.authorization(
        cpf: cpf,
        senha: senha,
      );

      final code = authorizationResponse['code'];

      final authorizationToken = authorizationResponse['access_token'];

      if (code == null || authorizationToken == null) {
        return false;
      }

      // API 2 - Access Token
      final tokenResponse = await _authService.accessToken(
        code: code,
        authorizationToken: authorizationToken,
      );

      accessToken = tokenResponse['access_token'];

      refreshToken = tokenResponse['refresh_token'];

      if (accessToken == null) {
        return false;
      }

      await _storage.saveAccessToken(accessToken!);

      if (refreshToken != null) {
        await _storage.saveRefreshToken(refreshToken!);
      }

      isAuthenticated = true;

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Erro ao realizar login: $e');

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkLogin() async {
    final token = await _storage.getAccessToken();

    isAuthenticated = token != null && token.isNotEmpty;

    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.clear();

    isAuthenticated = false;
    accessToken = null;
    refreshToken = null;

    notifyListeners();
  }
}
