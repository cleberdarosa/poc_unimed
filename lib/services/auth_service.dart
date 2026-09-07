import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/utils/app_logger.dart';
import '../models/auth_response.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  Future<AuthorizationResponse> authorization({
    required String cpf,
    required String senha,
  }) async {
    AppLogger.auth('Iniciando autorização na API 1.');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.authorization,
        data: {
          'redirect_uri': ApiConstants.redirectUri,
          'client_id': ApiConstants.clientId,
          'username': cpf,
          'password': senha,
        },
      );

      AppLogger.auth('API 1 concluída. HTTP ${response.statusCode}.');

      final authorization = AuthorizationResponse.fromJson(
        _responseData(response),
      );

      AppLogger.auth(
        'Resposta da API 1 validada. Código de autorização recebido.',
      );

      return authorization;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'AUTH',
        'Falha na autorização da API 1. '
            'HTTP ${error.response?.statusCode}.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (error, stackTrace) {
      AppLogger.error(
        'AUTH',
        'Erro inesperado na autorização da API 1.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<TokenResponse> accessToken({
    required String code,
    required String authorizationToken,
  }) async {
    AppLogger.auth('Iniciando troca do código pelo token principal na API 2.');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.accessToken,
        options: Options(
          headers: {
            'x-authorization': ApiConstants.xAuthorization,
            'Authorization': 'Bearer $authorizationToken',
          },
        ),
        data: {'grant_type': 'authorization_code', 'code': code},
      );

      AppLogger.auth('API 2 concluída. HTTP ${response.statusCode}.');

      final token = TokenResponse.fromJson(_responseData(response));

      AppLogger.auth(
        'Token principal recebido. '
        'Validade informada: ${token.expiresIn} segundos.',
      );

      return token;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'AUTH',
        'Falha ao obter o token principal. '
            'HTTP ${error.response?.statusCode}.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (error, stackTrace) {
      AppLogger.error(
        'AUTH',
        'Erro inesperado ao obter o token principal.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<TokenResponse> refreshToken({
    required String refreshToken,
    required String identityAccessToken,
  }) async {
    AppLogger.auth('Iniciando renovação do token principal.');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.accessToken,
        options: Options(
          headers: {
            'x-authorization': ApiConstants.xAuthorization,
            'Authorization': 'Bearer $identityAccessToken',
          },
        ),
        data: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
      );

      AppLogger.auth('Refresh concluído. HTTP ${response.statusCode}.');

      final token = TokenResponse.fromJson(_responseData(response));

      AppLogger.auth(
        'Novo access token e novo refresh token recebidos. '
        'Validade: ${token.expiresIn} segundos.',
      );

      return token;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'AUTH',
        'Falha ao renovar o token. '
            'HTTP ${error.response?.statusCode}.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (error, stackTrace) {
      AppLogger.error(
        'AUTH',
        'Erro inesperado durante o refresh.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Map<String, dynamic> _responseData(Response<Map<String, dynamic>> response) {
    final data = response.data;

    if (data == null) {
      throw const FormatException('Resposta da API sem conteúdo.');
    }

    return data;
  }
}
