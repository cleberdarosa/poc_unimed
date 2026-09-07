import 'package:flutter/foundation.dart';

import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  bool isAuthenticated = false;
  bool isLoading = false;
  String? errorMessage;
  AuthSession? session;

  String? get accessToken => session?.accessToken;
  String? get refreshToken => session?.refreshToken;
  String? get cpf => session?.cpf;

  Future<bool> login({required String cpf, required String senha}) async {
    if (isLoading) return false;

    _setLoading(true);
    errorMessage = null;

    try {
      session = await _repository.login(cpf: cpf, senha: senha);
      isAuthenticated = true;
      return true;
    } catch (error) {
      debugPrint('Erro ao realizar login: $error');
      session = null;
      isAuthenticated = false;
      errorMessage = 'Não foi possível realizar o login.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkLogin() async {
    _setLoading(true);

    try {
      final result = await _repository.restoreSession();
      session = _repository.currentSession;
      isAuthenticated = result == SessionRestoreResult.authenticated;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> refreshSession() async {
    final refreshedSession = await _repository.refreshSession(session: session);

    session = refreshedSession;
    isAuthenticated = refreshedSession != null;
    notifyListeners();
    return isAuthenticated;
  }

  Future<void> logout() async {
    await _repository.logout();
    session = null;
    isAuthenticated = false;
    errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
