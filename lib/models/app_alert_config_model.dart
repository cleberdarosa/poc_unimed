enum AppAlertType {
  information,
  success,
  warning,
  error,
  confirmation;

  static AppAlertType fromJson(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'information':
      case 'info':
        return AppAlertType.information;

      case 'success':
        return AppAlertType.success;

      case 'warning':
      case 'attention':
        return AppAlertType.warning;

      case 'error':
        return AppAlertType.error;

      case 'confirmation':
      case 'confirm':
        return AppAlertType.confirmation;

      default:
        throw FormatException('Tipo de modal inválido: $value');
    }
  }
}

class AppAlertConfigModel {
  final String id;
  final AppAlertType type;
  final String title;
  final String message;
  final String icon;
  final String confirmLabel;
  final String? cancelLabel;
  final bool dismissible;
  final bool enabled;

  const AppAlertConfigModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.dismissible,
    required this.enabled,
  });

  factory AppAlertConfigModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString().trim() ?? '';
    final title = json['title']?.toString().trim() ?? '';
    final message = json['message']?.toString().trim() ?? '';
    final confirmLabel = json['confirmLabel']?.toString().trim() ?? '';

    if (id.isEmpty) {
      throw const FormatException('O campo id do modal é obrigatório.');
    }

    if (title.isEmpty) {
      throw FormatException('O título do modal "$id" é obrigatório.');
    }

    if (message.isEmpty) {
      throw FormatException('A mensagem do modal "$id" é obrigatória.');
    }

    if (confirmLabel.isEmpty) {
      throw FormatException(
        'O texto do botão principal do modal "$id" '
        'é obrigatório.',
      );
    }

    final rawCancelLabel = json['cancelLabel']?.toString().trim();

    return AppAlertConfigModel(
      id: id,
      type: AppAlertType.fromJson(json['type']?.toString()),
      title: title,
      message: message,
      icon: json['icon']?.toString().trim() ?? 'info',
      confirmLabel: confirmLabel,
      cancelLabel: rawCancelLabel == null || rawCancelLabel.isEmpty
          ? null
          : rawCancelLabel,
      dismissible: json['dismissible'] as bool? ?? true,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'message': message,
      'icon': icon,
      'confirmLabel': confirmLabel,
      'cancelLabel': cancelLabel,
      'dismissible': dismissible,
      'enabled': enabled,
    };
  }

  AppAlertConfigModel copyWith({
    String? id,
    AppAlertType? type,
    String? title,
    String? message,
    String? icon,
    String? confirmLabel,
    String? cancelLabel,
    bool? dismissible,
    bool? enabled,
  }) {
    return AppAlertConfigModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      confirmLabel: confirmLabel ?? this.confirmLabel,
      cancelLabel: cancelLabel ?? this.cancelLabel,
      dismissible: dismissible ?? this.dismissible,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  String toString() {
    return 'AppAlertConfigModel('
        'id: $id, '
        'type: ${type.name}, '
        'enabled: $enabled'
        ')';
  }
}
