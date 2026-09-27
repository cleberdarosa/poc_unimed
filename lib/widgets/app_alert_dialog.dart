import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/design_system.dart';
import '../core/utils/app_logger.dart';
import '../models/app_alert_config_model.dart';
import '../models/app_alert_result.dart';

class AppAlertDialog {
  AppAlertDialog._();

  static Future<AppAlertResult> show({
    required BuildContext context,
    required AppAlertConfigModel config,
  }) async {
    _log(
      'Solicitada abertura do modal. '
      'ID: ${config.id}; '
      'tipo: ${config.type.name}; '
      'dismissible: ${config.dismissible}.',
    );

    if (!config.enabled) {
      _log(
        'Modal não aberto porque está desabilitado. '
        'ID: ${config.id}.',
      );

      return AppAlertResult.dismissed;
    }

    final stopwatch = Stopwatch()..start();

    try {
      final result = await showDialog<AppAlertResult>(
        context: context,
        barrierDismissible: config.dismissible,
        builder: (dialogContext) {
          return PopScope(
            canPop: config.dismissible,
            child: _AppAlertDialogContent(config: config),
          );
        },
      );

      stopwatch.stop();

      final resolvedResult = result ?? AppAlertResult.dismissed;

      _log(
        'Modal finalizado. '
        'ID: ${config.id}; '
        'resultado: ${resolvedResult.name}; '
        'tempo aberto: '
        '${stopwatch.elapsedMilliseconds} ms.',
      );

      return resolvedResult;
    } catch (error, stackTrace) {
      stopwatch.stop();

      AppLogger.error(
        'ALERT-DIALOG',
        'Falha ao exibir o modal ${config.id}.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  static void _log(String message) {
    AppLogger.session('[ALERT-DIALOG][WIDGET] $message');
  }
}

class _AppAlertDialogContent extends StatelessWidget {
  final AppAlertConfigModel config;

  const _AppAlertDialogContent({required this.config});

  @override
  Widget build(BuildContext context) {
    final visualStyle = _AppAlertVisualStyle.fromType(context, config.type);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DS.radiusLg),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        DS.spaceLg,
        DS.spaceLg,
        DS.spaceLg,
        DS.spaceMd,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: DS.spaceXXl,
              height: DS.spaceXXl,
              decoration: BoxDecoration(
                color: visualStyle.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _resolveIcon(config.icon, config.type),
                color: visualStyle.iconColor,
                size: DS.actionIconSize,
              ),
            ),
            const SizedBox(height: DS.spaceLg),
            Text(
              config.title,
              style: AppTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DS.spaceMd),
            Text(
              config.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        DS.spaceLg,
        0,
        DS.spaceLg,
        DS.spaceLg,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (config.cancelLabel != null)
          OutlinedButton(
            onPressed: () {
              _log(
                'Botão secundário selecionado. '
                'ID: ${config.id}.',
              );

              Navigator.of(context).pop(AppAlertResult.cancelled);
            },
            child: Text(config.cancelLabel!),
          ),
        FilledButton(
          onPressed: () {
            _log(
              'Botão principal selecionado. '
              'ID: ${config.id}.',
            );

            Navigator.of(context).pop(AppAlertResult.confirmed);
          },
          style: FilledButton.styleFrom(
            backgroundColor: visualStyle.actionColor,
            foregroundColor: AppTheme.white,
          ),
          child: Text(config.confirmLabel),
        ),
      ],
    );
  }

  IconData _resolveIcon(String icon, AppAlertType type) {
    switch (icon.trim().toLowerCase()) {
      case 'success':
      case 'check':
        return Icons.check_circle_outline;

      case 'warning':
      case 'attention':
        return Icons.warning_amber_rounded;

      case 'error':
        return Icons.error_outline;

      case 'question':
      case 'confirmation':
        return Icons.help_outline;

      case 'info':
      case 'information':
        return Icons.info_outline;

      default:
        return _defaultIcon(type);
    }
  }

  IconData _defaultIcon(AppAlertType type) {
    switch (type) {
      case AppAlertType.information:
        return Icons.info_outline;

      case AppAlertType.success:
        return Icons.check_circle_outline;

      case AppAlertType.warning:
        return Icons.warning_amber_rounded;

      case AppAlertType.error:
        return Icons.error_outline;

      case AppAlertType.confirmation:
        return Icons.help_outline;
    }
  }

  void _log(String message) {
    AppLogger.session('[ALERT-DIALOG][CONTENT] $message');
  }
}

class _AppAlertVisualStyle {
  final Color iconColor;
  final Color backgroundColor;
  final Color actionColor;

  const _AppAlertVisualStyle({
    required this.iconColor,
    required this.backgroundColor,
    required this.actionColor,
  });

  factory _AppAlertVisualStyle.fromType(
    BuildContext context,
    AppAlertType type,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case AppAlertType.information:
        return _AppAlertVisualStyle(
          iconColor: AppTheme.primary,
          backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
          actionColor: AppTheme.primary,
        );

      case AppAlertType.success:
        return _AppAlertVisualStyle(
          iconColor: AppTheme.primary,
          backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
          actionColor: AppTheme.primary,
        );

      case AppAlertType.warning:
        return _AppAlertVisualStyle(
          iconColor: colorScheme.tertiary,
          backgroundColor: colorScheme.tertiaryContainer,
          actionColor: colorScheme.tertiary,
        );

      case AppAlertType.error:
        return _AppAlertVisualStyle(
          iconColor: colorScheme.error,
          backgroundColor: colorScheme.errorContainer,
          actionColor: colorScheme.error,
        );

      case AppAlertType.confirmation:
        return _AppAlertVisualStyle(
          iconColor: AppTheme.secondary,
          backgroundColor: AppTheme.secondary.withValues(alpha: 0.12),
          actionColor: AppTheme.secondary,
        );
    }
  }
}
