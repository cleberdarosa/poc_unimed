import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 59),
      receiveTimeout: const Duration(seconds: 59),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
