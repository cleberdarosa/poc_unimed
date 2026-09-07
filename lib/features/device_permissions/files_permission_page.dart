import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/app_bottom_nav.dart';

class FilesPermissionPage extends StatefulWidget {
  const FilesPermissionPage({super.key});

  @override
  State<FilesPermissionPage> createState() => _FilesPermissionPageState();
}

class _FilesPermissionPageState extends State<FilesPermissionPage> {
  //final FilePicker _filePicker = FilePicker();

  PlatformFile? _selectedFile;
  bool _isLoading = false;
  String? _message;

  @override
  void initState() {
    super.initState();

    _log('Página de acesso a arquivos iniciada.');
    _log(
      'O acesso aos documentos será realizado pelo '
      'seletor nativo do sistema operacional.',
    );
  }

  Future<void> _pickFile() async {
    if (_isLoading) {
      _log(
        'Seleção ignorada porque já existe uma '
        'operação em andamento.',
      );
      return;
    }

    _setLoading(true);

    _log('Abrindo o seletor nativo de arquivos.');
    _log('Extensões permitidas: PDF, JPG, JPEG e PNG.');

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: false,
      );

      if (result == null || result.files.isEmpty) {
        _log('Seleção de arquivo cancelada pelo usuário.');

        if (!mounted) {
          return;
        }

        setState(() {
          _message = 'Seleção cancelada.';
        });

        return;
      }

      final selectedFile = result.files.single;

      _log('Arquivo retornado pelo seletor nativo.');
      _log('Nome do arquivo: ${selectedFile.name}.');
      _log(
        'Extensão do arquivo: '
        '${selectedFile.extension ?? 'não identificada'}.',
      );
      _log('Tamanho do arquivo: ${selectedFile.size} bytes.');
      _log(
        'Caminho local disponível: '
        '${selectedFile.path != null}.',
      );

      if (selectedFile.path != null) {
        _log(
          'Caminho temporário do arquivo: '
          '${selectedFile.path}.',
        );
      }

      if (!mounted) {
        _log(
          'A página foi removida antes da atualização '
          'do arquivo selecionado.',
        );
        return;
      }

      setState(() {
        _selectedFile = selectedFile;
        _message = 'Arquivo selecionado com sucesso.';
      });

      _log('Estado da página atualizado com o arquivo selecionado.');
    } catch (error, stackTrace) {
      _logError('Falha ao selecionar arquivo.', error, stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        _message = 'Não foi possível selecionar o arquivo.';
      });
    } finally {
      _setLoading(false);
      _log('Operação do seletor de arquivos finalizada.');
    }
  }

  Future<void> _openSettings() async {
    _log('Solicitada abertura das configurações do aplicativo.');

    try {
      final opened = await openAppSettings();

      _log('Resultado da abertura das configurações: $opened.');

      if (!opened && mounted) {
        setState(() {
          _message = 'Não foi possível abrir as configurações.';
        });
      }
    } catch (error, stackTrace) {
      _logError('Falha ao abrir as configurações.', error, stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        _message = 'Não foi possível abrir as configurações.';
      });
    }
  }

  void _clearSelectedFile() {
    final selectedFile = _selectedFile;

    if (selectedFile == null) {
      _log(
        'Limpeza ignorada porque não existe '
        'arquivo selecionado.',
      );
      return;
    }

    _log(
      'Removendo da página a referência ao arquivo '
      '${selectedFile.name}.',
    );

    setState(() {
      _selectedFile = null;
      _message = 'Seleção removida.';
    });

    _log('Referência do arquivo removida da memória da página.');
  }

  void _goBack() {
    _log('Usuário solicitou retorno para a página anterior.');

    if (context.canPop()) {
      context.pop();
      return;
    }

    _log(
      'Não existe página anterior na pilha. '
      'Navegando para o menu.',
    );

    context.go('/menu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Acesso a arquivos'),
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentItemId: 'menu'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(DS.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _PermissionHeader(
                icon: Icons.folder_open_outlined,
                title: 'Arquivos',
                description:
                    'O seletor nativo permite escolher '
                    'explicitamente um documento do dispositivo. '
                    'A aplicação não solicita acesso irrestrito '
                    'ao armazenamento.',
                status: 'Seletor nativo disponível',
              ),
              const SizedBox(height: DS.spaceLg),
              if (_selectedFile != null) ...[
                _FileCard(file: _selectedFile!, onClear: _clearSelectedFile),
                const SizedBox(height: DS.spaceMd),
              ],
              if (_message != null) ...[
                _MessageCard(message: _message!),
                const SizedBox(height: DS.spaceMd),
              ],
              FilledButton.icon(
                onPressed: _isLoading ? null : _pickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text('Selecionar arquivo'),
              ),
              const SizedBox(height: DS.spaceMd),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _openSettings,
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Abrir configurações do aplicativo'),
              ),
              if (_isLoading) ...[
                const SizedBox(height: DS.spaceLg),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: DS.spaceSm),
                const Center(child: Text('Aguardando seleção...')),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _setLoading(bool value) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = value;
    });

    _log('Estado de carregamento alterado para: $value.');
  }

  void _log(String message) {
    AppLogger.session('[DEVICE][FILES] $message');
  }

  void _logError(String message, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'DEVICE-FILES',
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class _FileCard extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onClear;

  const _FileCard({required this.file, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DS.spaceSm),
        child: ListTile(
          leading: Icon(
            _fileIcon,
            color: AppTheme.primary,
            size: DS.actionIconSize,
          ),
          title: Text(file.name, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: DS.spaceXs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$_extensionLabel • ${_formatSize(file.size)}'),
                const SizedBox(height: DS.spaceXs),
                Text(
                  file.path == null
                      ? 'Caminho local indisponível'
                      : 'Arquivo disponível localmente',
                ),
              ],
            ),
          ),
          trailing: IconButton(
            tooltip: 'Remover seleção',
            onPressed: onClear,
            icon: const Icon(Icons.close),
          ),
        ),
      ),
    );
  }

  String get _extensionLabel {
    final extension = file.extension;

    if (extension == null || extension.isEmpty) {
      return 'ARQUIVO';
    }

    return extension.toUpperCase();
  }

  IconData get _fileIcon {
    final extension = file.extension?.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;

      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;

      default:
        return Icons.description_outlined;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      final kilobytes = bytes / 1024;

      return '${kilobytes.toStringAsFixed(1)} KB';
    }

    final megabytes = bytes / (1024 * 1024);

    return '${megabytes.toStringAsFixed(1)} MB';
  }
}

class _PermissionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String status;

  const _PermissionHeader({
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DS.spaceLg),
        child: Column(
          children: [
            Icon(icon, size: DS.spaceXXl, color: AppTheme.primary),
            const SizedBox(height: DS.spaceMd),
            Text(
              title,
              style: AppTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DS.spaceSm),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: DS.spaceMd),
            Chip(
              avatar: const Icon(
                Icons.check_circle_outline,
                color: AppTheme.primary,
              ),
              label: Text(status),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String message;

  const _MessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DS.spaceMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: AppTheme.primary),
            const SizedBox(width: DS.spaceMd),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
