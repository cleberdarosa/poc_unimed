import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: 'access_token');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: 'access_token');
  }

  Future<void> saveCpf(String cpf) async {
    await _storage.write(key: 'cpf', value: cpf);
  }

  Future<String?> getCpf() async {
    return _storage.read(key: 'cpf');
  }
}
