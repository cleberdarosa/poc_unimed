enum AppAlertResult {
  confirmed,
  cancelled,
  dismissed;

  String get label {
    switch (this) {
      case AppAlertResult.confirmed:
        return 'Confirmado';

      case AppAlertResult.cancelled:
        return 'Cancelado';

      case AppAlertResult.dismissed:
        return 'Fechado sem ação';
    }
  }
}
