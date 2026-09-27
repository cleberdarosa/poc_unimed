import '../../core/utils/app_logger.dart';
import '../../models/app_alert_config_model.dart';
import 'alert_dialog_data_source.dart';

class ApiAlertDialogDataSource implements AlertDialogDataSource {
  const ApiAlertDialogDataSource();

  @override
  Future<List<AppAlertConfigModel>> getAll() async {
    _log('Solicitada leitura de modais pela API.');

    _log(
      'Operação indisponível porque a API '
      'de configuração de modais ainda não existe.',
    );

    throw UnsupportedError(
      'API de configuração de modais '
      'ainda não disponível.',
    );
  }

  @override
  Future<AppAlertConfigModel?> getById(String id) async {
    _log('Solicitada leitura de modal pela API. ID: $id.');

    _log(
      'Operação indisponível porque a API '
      'de configuração de modais ainda não existe.',
    );

    throw UnsupportedError(
      'API de configuração de modais '
      'ainda não disponível.',
    );
  }

  void _log(String message) {
    AppLogger.session('[ALERT-DIALOG][API] $message');
  }
}
