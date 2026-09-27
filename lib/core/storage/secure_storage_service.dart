import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/auth_response.dart';

class SecureStorageService {
  static const String _identityAccessTokenKey = 'identity_access_token';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _identityAccessTokenExpiresAtKey =
      'identity_access_token_expires_at';
  static const String _accessTokenExpiresAtKey = 'access_token_expires_at';
  static const String _cpfKey = 'cpf';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveSession(AuthSession session) async {
    await Future.wait([
      saveIdentityAccessToken(session.identityAccessToken),
      saveAccessToken(session.accessToken),
      saveRefreshToken(session.refreshToken),
      saveIdentityAccessTokenExpiresAt(session.identityAccessTokenExpiresAt),
      saveAccessTokenExpiresAt(session.accessTokenExpiresAt),
      saveCpf(session.cpf),
    ]);
  }

  Future<AuthSession?> getSession() async {
    final values = await Future.wait<String?>([
      getIdentityAccessToken(),
      getAccessToken(),
      getRefreshToken(),
      _storage.read(key: _identityAccessTokenExpiresAtKey),
      _storage.read(key: _accessTokenExpiresAtKey),
      getCpf(),
    ]);

    final identityAccessToken = values[0];
    final accessToken = values[1];
    final refreshToken = values[2];
    final identityExpiresAt = DateTime.tryParse(values[3] ?? '');
    final accessExpiresAt = DateTime.tryParse(values[4] ?? '');
    final cpf = values[5];

    if (identityAccessToken == null ||
        identityAccessToken.isEmpty ||
        accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty ||
        identityExpiresAt == null ||
        accessExpiresAt == null ||
        cpf == null ||
        cpf.isEmpty) {
      return null;
    }

    return AuthSession(
      identityAccessToken: identityAccessToken,
      accessToken: accessToken,
      refreshToken: refreshToken,
      identityAccessTokenExpiresAt: identityExpiresAt,
      accessTokenExpiresAt: accessExpiresAt,
      cpf: cpf,
    );
  }

  Future<void> saveIdentityAccessToken(String token) {
    return _storage.write(key: _identityAccessTokenKey, value: token);
  }

  Future<String?> getIdentityAccessToken() {
    return _storage.read(key: _identityAccessTokenKey);
  }

  Future<void> saveAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveIdentityAccessTokenExpiresAt(DateTime value) {
    return _storage.write(
      key: _identityAccessTokenExpiresAtKey,
      value: value.toUtc().toIso8601String(),
    );
  }

  Future<void> saveAccessTokenExpiresAt(DateTime value) {
    return _storage.write(
      key: _accessTokenExpiresAtKey,
      value: value.toUtc().toIso8601String(),
    );
  }

  Future<void> saveCpf(String cpf) {
    return _storage.write(key: _cpfKey, value: cpf);
  }

  Future<String?> getCpf() {
    return _storage.read(key: _cpfKey);
  }

  Future<void> clear() {
    return _storage.deleteAll();
  }
}
