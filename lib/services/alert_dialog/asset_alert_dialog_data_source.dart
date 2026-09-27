import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/utils/app_logger.dart';
import '../../models/app_alert_config_model.dart';
import 'alert_dialog_data_source.dart';

class AssetAlertDialogDataSource implements AlertDialogDataSource {
  static const String _assetPath = 'assets/mocks/alert_dialogs.json';

  final AssetBundle assetBundle;

  AssetAlertDialogDataSource({AssetBundle? assetBundle})
    : assetBundle = assetBundle ?? rootBundle;

  @override
  Future<List<AppAlertConfigModel>> getAll() async {
    _log('Iniciando leitura das configurações mockadas.');
    _log('Asset utilizado: $_assetPath.');

    final stopwatch = Stopwatch()..start();

    try {
      final jsonContent = await assetBundle.loadString(_assetPath);

      _log(
        'Arquivo JSON carregado. '
        'Caracteres recebidos: ${jsonContent.length}.',
      );

      final decoded = jsonDecode(jsonContent);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'A raiz do JSON de modais deve ser um objeto.',
        );
      }

      final rawItems = decoded['items'];

      if (rawItems is! List) {
        throw const FormatException(
          'A propriedade "items" deve ser uma lista.',
        );
      }

      _log(
        'Registros encontrados no JSON: '
        '${rawItems.length}.',
      );

      final items = <AppAlertConfigModel>[];

      for (var index = 0; index < rawItems.length; index++) {
        final rawItem = rawItems[index];

        if (rawItem is! Map) {
          throw FormatException(
            'O modal na posição $index '
            'não possui um objeto JSON válido.',
          );
        }

        final json = Map<String, dynamic>.from(rawItem);

        final model = AppAlertConfigModel.fromJson(json);

        items.add(model);

        _log(
          'Modal convertido. '
          'ID: ${model.id}; '
          'tipo: ${model.type.name}; '
          'habilitado: ${model.enabled}.',
        );
      }

      stopwatch.stop();

      _log(
        'Configurações carregadas com sucesso. '
        'Quantidade: ${items.length}; '
        'tempo: ${stopwatch.elapsedMilliseconds} ms.',
      );

      return List.unmodifiable(items);
    } catch (error, stackTrace) {
      stopwatch.stop();

      AppLogger.error(
        'ALERT-DIALOG',
        'Falha ao carregar as configurações mockadas. '
            'Tempo: ${stopwatch.elapsedMilliseconds} ms.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  @override
  Future<AppAlertConfigModel?> getById(String id) async {
    final normalizedId = id.trim();

    _log(
      'Procurando configuração pelo ID: '
      '$normalizedId.',
    );

    if (normalizedId.isEmpty) {
      _log('Busca cancelada porque o ID está vazio.');

      return null;
    }

    final items = await getAll();

    for (final item in items) {
      if (item.id == normalizedId) {
        _log(
          'Configuração encontrada. '
          'ID: ${item.id}; '
          'tipo: ${item.type.name}.',
        );

        return item;
      }
    }

    _log(
      'Nenhuma configuração encontrada '
      'para o ID: $normalizedId.',
    );

    return null;
  }

  void _log(String message) {
    AppLogger.session('[ALERT-DIALOG][ASSET] $message');
  }
}
