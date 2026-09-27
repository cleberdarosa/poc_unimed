import 'package:flutter/foundation.dart';

import '../core/utils/app_logger.dart';
import '../models/familia.dart';
import '../services/familia_service.dart';

class HomeProvider extends ChangeNotifier {
  final FamiliaService _service;

  HomeProvider({FamiliaService? service})
    : _service = service ?? FamiliaService();

  bool isLoading = false;
  bool sessionExpired = false;
  String? errorMessage;
  Familia? titular;
  PlanoFamilia? planoAtivo;

  bool get hasData => titular != null && planoAtivo != null;

  Future<void> loadHome() async {
    if (isLoading) {
      AppLogger.home(
        'Carregamento ignorado porque já existe uma operação em andamento.',
      );
      return;
    }

    AppLogger.home('Iniciando carregamento da Home.');

    _setLoading(true);
    errorMessage = null;
    sessionExpired = false;

    try {
      final response = await _service.getFamilia();
      final rawItems = response['items'];

      if (rawItems is! List || rawItems.isEmpty) {
        throw const FamiliaServiceException(
          'Nenhum beneficiário foi encontrado.',
        );
      }

      AppLogger.home('Beneficiários recebidos: ${rawItems.length}.');

      final firstItem = rawItems.first;

      if (firstItem is! Map<String, dynamic>) {
        throw const FamiliaServiceException(
          'Os dados do beneficiário estão em formato inválido.',
        );
      }

      final loadedTitular = Familia.fromJson(firstItem);

      AppLogger.home(
        'Beneficiário convertido. '
        'Planos encontrados: ${loadedTitular.planos.length}.',
      );

      final activePlans = loadedTitular.planos.where(
        (plan) => plan.statusCarteira.toLowerCase() == 'ativo',
      );

      if (activePlans.isEmpty) {
        throw const FamiliaServiceException(
          'Nenhum plano ativo foi encontrado.',
        );
      }

      titular = loadedTitular;
      planoAtivo = activePlans.first;

      AppLogger.home('Home carregada. Plano ativo encontrado.');
    } on SessionExpiredException catch (error) {
      AppLogger.home('Sessão expirada durante o carregamento.');
      sessionExpired = true;
      titular = null;
      planoAtivo = null;
      errorMessage = error.message;
    } on FamiliaServiceException catch (error) {
      AppLogger.home('Falha conhecida: ${error.message}');
      titular = null;
      planoAtivo = null;
      errorMessage = error.message;
    } catch (error, stackTrace) {
      AppLogger.error(
        'HOME',
        'Erro inesperado ao carregar a Home.',
        error: error,
        stackTrace: stackTrace,
      );
      titular = null;
      planoAtivo = null;
      errorMessage = 'Não foi possível carregar os dados da Home.';
    } finally {
      _setLoading(false);
      AppLogger.home('Carregamento da Home finalizado.');
    }
  }

  Future<void> retry() => loadHome();

  void clear() {
    AppLogger.home('Limpando dados mantidos pelo HomeProvider.');
    titular = null;
    planoAtivo = null;
    errorMessage = null;
    sessionExpired = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
