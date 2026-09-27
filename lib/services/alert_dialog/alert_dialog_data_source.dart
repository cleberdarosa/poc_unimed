import '../../models/app_alert_config_model.dart';

abstract interface class AlertDialogDataSource {
  Future<List<AppAlertConfigModel>> getAll();

  Future<AppAlertConfigModel?> getById(String id);
}
