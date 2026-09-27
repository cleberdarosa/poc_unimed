import '../core/utils/app_logger.dart';
import '../models/app_alert_config_model.dart';
import '../services/alert_dialog/alert_dialog_data_source.dart';
import '../services/alert_dialog/asset_alert_dialog_data_source.dart';

class AlertDialogRepository {
  final AlertDialogDataSource dataSource;

  const AlertDialogRepository({required this.dataSource});

  factory AlertDialogRepository.mock() {
    AppLogger.session(
      '[ALERT-DIALOG][REPOSITORY] '
      'Criando Repository com DataSource mockado.',
    );

    return AlertDialogRepository(dataSource: AssetAlertDialogDataSource());
  }

  Future<List<AppAlertConfigModel>> getAll({bool onlyEnabled = true}) async {
    _log(
      'Solicitando todas as configurações. '
      'Somente habilitadas: $onlyEnabled.',
    );

    try {
      final items = await dataSource.getAll();

      final result = onlyEnabled
          ? items.where((item) => item.enabled).toList()
          : List<AppAlertConfigModel>.from(items);

      _log(
        'Configurações retornadas pelo Repository: '
        '${result.length}.',
      );

      return List.unmodifiable(result);
    } catch (error, stackTrace) {
      AppLogger.error(
        'ALERT-DIALOG-REPOSITORY',
        'Falha ao recuperar as configurações.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<AppAlertConfigModel?> getById(
    String id, {
    bool requireEnabled = true,
  }) async {
    _log(
      'Solicitando configuração pelo ID: $id. '
      'Exigir habilitado: $requireEnabled.',
    );

    try {
      final config = await dataSource.getById(id);

      if (config == null) {
        _log('Configuração não encontrada. ID: $id.');

        return null;
      }

      if (requireEnabled && !config.enabled) {
        _log(
          'Configuração encontrada, mas está '
          'desabilitada. ID: $id.',
        );

        return null;
      }

      _log(
        'Configuração disponível. '
        'ID: ${config.id}; '
        'tipo: ${config.type.name}.',
      );

      return config;
    } catch (error, stackTrace) {
      AppLogger.error(
        'ALERT-DIALOG-REPOSITORY',
        'Falha ao recuperar a configuração $id.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  void _log(String message) {
    AppLogger.session('[ALERT-DIALOG][REPOSITORY] $message');
  }
}
