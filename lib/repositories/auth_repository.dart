import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Future<Map<String, dynamic>> login({
    required String cpf,
    required String senha,
  }) async {
    return await service.authorization(cpf: cpf, senha: senha);
  }
}
