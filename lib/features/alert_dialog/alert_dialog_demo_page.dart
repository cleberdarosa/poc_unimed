import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../core/utils/app_logger.dart';
import '../../models/app_alert_config_model.dart';
import '../../models/app_alert_result.dart';
import '../../repositories/alert_dialog_repository.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/app_bottom_nav.dart';

class AlertDialogDemoPage extends StatefulWidget {
  const AlertDialogDemoPage({super.key});

  @override
  State<AlertDialogDemoPage> createState() {
    return _AlertDialogDemoPageState();
  }
}

class _AlertDialogDemoPageState extends State<AlertDialogDemoPage> {
  final AlertDialogRepository _repository = AlertDialogRepository.mock();

  bool _isLoading = true;
  String? _errorMessage;
  List<AppAlertConfigModel> _configs = const [];
  AppAlertResult? _lastResult;
  String? _lastModalTitle;

  @override
  void initState() {
    super.initState();

    _log('Página de demonstração iniciada.');
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    _log('Iniciando carregamento dos modais.');

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final configs = await _repository.getAll();

      _log(
        'Configurações recebidas pela página: '
        '${configs.length}.',
      );

      if (!mounted) {
        _log(
          'Página removida antes da atualização '
          'das configurações.',
        );

        return;
      }

      setState(() {
        _configs = configs;
      });
    } catch (error, stackTrace) {
      AppLogger.error(
        'ALERT-DIALOG-DEMO',
        'Falha ao carregar as configurações.',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Não foi possível carregar os modais.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      _log('Carregamento da página finalizado.');
    }
  }

  Future<void> _openAlert(AppAlertConfigModel config) async {
    _log('Solicitada abertura do modal: ${config.id}.');

    final result = await AppAlertDialog.show(context: context, config: config);

    if (!mounted) {
      return;
    }

    setState(() {
      _lastResult = result;
      _lastModalTitle = config.title;
    });

    _log(
      'Resultado recebido pela página. '
      'Modal: ${config.id}; '
      'resultado: ${result.name}.',
    );
  }

  void _goBack() {
    _log('Usuário solicitou retorno.');

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/menu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Modal de aviso'),
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentItemId: 'menu'),
      body: SafeArea(top: false, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(DS.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: DS.spaceXXl,
                color: Colors.red,
              ),
              const SizedBox(height: DS.spaceMd),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: DS.spaceLg),
              FilledButton.icon(
                onPressed: _loadConfigs,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadConfigs,
      child: ListView(
        padding: const EdgeInsets.all(DS.spaceLg),
        children: [
          Text('Modais disponíveis', style: AppTheme.titleLarge),
          const SizedBox(height: DS.spaceSm),
          const Text(
            'Selecione um exemplo para validar '
            'o comportamento do componente.',
          ),
          const SizedBox(height: DS.spaceLg),
          if (_lastResult != null)
            _LastResultCard(modalTitle: _lastModalTitle!, result: _lastResult!),
          if (_lastResult != null) const SizedBox(height: DS.spaceLg),
          for (final config in _configs) ...[
            _AlertDemoCard(config: config, onPressed: () => _openAlert(config)),
            const SizedBox(height: DS.spaceMd),
          ],
        ],
      ),
    );
  }

  void _log(String message) {
    AppLogger.session('[ALERT-DIALOG][DEMO] $message');
  }
}

class _AlertDemoCard extends StatelessWidget {
  final AppAlertConfigModel config;
  final VoidCallback onPressed;

  const _AlertDemoCard({required this.config, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DS.spaceMd),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
              child: Icon(_icon, color: AppTheme.primary),
            ),
            const SizedBox(width: DS.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(config.title, style: AppTheme.actionTitle),
                  const SizedBox(height: DS.spaceXs),
                  Text(
                    _typeLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: DS.spaceXs),
                  Text(
                    config.dismissible
                        ? 'Permite fechamento externo'
                        : 'Exige uma ação do usuário',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: DS.spaceSm),
            FilledButton(onPressed: onPressed, child: const Text('Abrir')),
          ],
        ),
      ),
    );
  }

  String get _typeLabel {
    switch (config.type) {
      case AppAlertType.information:
        return 'Informação';

      case AppAlertType.success:
        return 'Sucesso';

      case AppAlertType.warning:
        return 'Atenção';

      case AppAlertType.error:
        return 'Erro';

      case AppAlertType.confirmation:
        return 'Confirmação';
    }
  }

  IconData get _icon {
    switch (config.type) {
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
}

class _LastResultCard extends StatelessWidget {
  final String modalTitle;
  final AppAlertResult result;

  const _LastResultCard({required this.modalTitle, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(DS.spaceMd),
        child: Row(
          children: [
            const Icon(Icons.history, color: AppTheme.primary),
            const SizedBox(width: DS.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Último resultado', style: AppTheme.actionTitle),
                  const SizedBox(height: DS.spaceXs),
                  Text('$modalTitle: ${result.label}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
