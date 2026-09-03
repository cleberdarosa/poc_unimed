import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

class FamiliaService {
  final Dio _dio = ApiClient.dio;

  Future<dynamic> getFamilia({
    required String cpf,
    required String token,
  }) async {
    final response = await _dio.get(
      '/uniid/beneficiario/v1/beneficiarios/$cpf/familia/agrupados',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
