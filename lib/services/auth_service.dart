import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> authorization({
    required String cpf,
    required String senha,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.authorization,
        data: {
          'redirect_uri': ApiConstants.redirectUri,
          'client_id': ApiConstants.clientId,
          'username': cpf,
          'password': senha,
        },
      );

      print('AUTHORIZATION RESPONSE: ${response.data}');

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print('AUTHORIZATION ERROR STATUS: ${e.response?.statusCode}');

      print('AUTHORIZATION ERROR DATA: ${e.response?.data}');

      rethrow;
    } catch (e) {
      print('AUTHORIZATION ERROR: $e');

      rethrow;
    }
  }

  Future<Map<String, dynamic>> accessToken({
    required String code,
    required String authorizationToken,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.accessToken,
        options: Options(
          headers: {
            'x-authorization': ApiConstants.xAuthorization,
            'Authorization': 'Bearer $authorizationToken',
          },
        ),
        data: {'grant_type': 'authorization_code', 'code': code},
      );

      print('TOKEN RESPONSE: ${response.data}');

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print('TOKEN ERROR STATUS: ${e.response?.statusCode}');

      print('TOKEN ERROR DATA: ${e.response?.data}');

      rethrow;
    } catch (e) {
      print('TOKEN ERROR: $e');

      rethrow;
    }
  }

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await _dio.post(
      ApiConstants.accessToken,

      options: Options(
        headers: {'x-authorization': ApiConstants.xAuthorization},
      ),

      data: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
    );

    return Map<String, dynamic>.from(response.data);
  }
}
