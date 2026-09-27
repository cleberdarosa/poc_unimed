import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/utils/app_logger.dart';
import '../repositories/auth_repository.dart';

class FamiliaService {
  final Dio _dio;
  final AuthRepository _authRepository;

  FamiliaService({Dio? dio, AuthRepository? authRepository})
    : _dio = dio ?? ApiClient.dio,
      _authRepository = authRepository ?? AuthRepository();

  Future<Map<String, dynamic>> getFamilia({String? cpf}) async {
    AppLogger.familia('Solicitando token válido para consultar a família.');

    final accessToken = await _authRepository.getValidAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      AppLogger.familia('Consulta cancelada porque não existe token válido.');
      throw const SessionExpiredException();
    }

    AppLogger.familia('Token válido disponível.');

    final sessionCpf =
        cpf ??
        _authRepository.currentSession?.cpf ??
        await _authRepository.storage.getCpf();

    if (sessionCpf == null || sessionCpf.isEmpty) {
      AppLogger.familia('Consulta cancelada porque o CPF não foi encontrado.');
      throw const FamiliaServiceException(
        'CPF não encontrado na sessão do usuário.',
      );
    }

    try {
      AppLogger.familia('Chamando API de família.');

      final response = await _dio.get<Map<String, dynamic>>(
        '/uniid/beneficiario/v1/beneficiarios/'
        '$sessionCpf/familia/agrupados',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      AppLogger.familia(
        'API de família concluída. HTTP ${response.statusCode}.',
      );

      final data = response.data;

      if (data == null) {
        AppLogger.familia('API de família retornou resposta vazia.');
        throw const FamiliaServiceException(
          'A API de família retornou uma resposta vazia.',
        );
      }

      final items = data['items'];
      AppLogger.familia(
        'Resposta recebida. Quantidade de beneficiários: '
        '${items is List ? items.length : 0}.',
      );

      return data;
    } on DioException catch (error, stackTrace) {
      final statusCode = error.response?.statusCode;

      AppLogger.error(
        'FAMILIA',
        'Falha na API de família. HTTP $statusCode.',
        error: error,
        stackTrace: stackTrace,
      );

      if (statusCode == 401) {
        AppLogger.familia('API retornou 401. Limpando a sessão.');
        await _authRepository.logout();
        throw const SessionExpiredException();
      }

      throw FamiliaServiceException(
        'Não foi possível carregar os dados da família.',
        cause: error,
      );
    }
  }
}

class FamiliaServiceException implements Exception {
  final String message;
  final Object? cause;

  const FamiliaServiceException(this.message, {this.cause});

  @override
  String toString() => message;
}

class SessionExpiredException extends FamiliaServiceException {
  const SessionExpiredException()
    : super('Sua sessão expirou. Faça login novamente.');
}
