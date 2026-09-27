import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/app_bottom_nav.dart';

class GalleryPermissionPage extends StatefulWidget {
  const GalleryPermissionPage({super.key});

  @override
  State<GalleryPermissionPage> createState() => _GalleryPermissionPageState();
}

class _GalleryPermissionPageState extends State<GalleryPermissionPage> {
  final ImagePicker _imagePicker = ImagePicker();

  PermissionStatus? _permissionStatus;
  XFile? _selectedImage;
  bool _isLoading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    _log('Verificando permissão da galeria.');
    final status = await Permission.photos.status;
    _log('Status atual da galeria: $status.');
    if (mounted) setState(() => _permissionStatus = status);
  }

  Future<void> _requestPermission() async {
    if (_isLoading) return;
    _setLoading(true);
    _log('Solicitando acesso à galeria.');

    try {
      final status = await Permission.photos.request();
      _log('Resultado da solicitação da galeria: $status.');

      if (!mounted) return;
      setState(() {
        _permissionStatus = status;
        _message = status.isGranted || status.isLimited
            ? 'Acesso à galeria disponível.'
            : status.isPermanentlyDenied
            ? 'O acesso foi bloqueado. Abra as configurações para autorizar.'
            : 'Acesso à galeria não autorizado.';
      });
    } catch (error, stackTrace) {
      _logError('Falha ao solicitar acesso à galeria.', error, stackTrace);
      if (mounted) {
        setState(() => _message = 'Não foi possível solicitar a permissão.');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _pickImage() async {
    if (_isLoading) return;
    _setLoading(true);
    _log('Abrindo o seletor nativo de imagens.');

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) {
        _log('Seleção de imagem cancelada.');
        if (mounted) setState(() => _message = 'Seleção cancelada.');
        return;
      }

      final size = await image.length();
      _log('Imagem selecionada. Nome: ${image.name}; tamanho: $size bytes.');

      if (!mounted) return;
      setState(() {
        _selectedImage = image;
        _message = 'Imagem selecionada com sucesso.';
      });
      await _checkPermission();
    } catch (error, stackTrace) {
      _logError('Falha ao selecionar imagem.', error, stackTrace);
      if (mounted) setState(() => _message = 'Falha ao acessar a galeria.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _openSettings() async {
    _log('Abrindo as configurações do aplicativo.');
    final opened = await openAppSettings();
    _log('Resultado da abertura das configurações: $opened.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Acesso à galeria'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentItemId: 'menu'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DS.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PermissionHeader(
                icon: Icons.photo_library_outlined,
                title: 'Galeria',
                description: 'Selecione uma imagem da biblioteca do dispositivo. No iOS, o acesso pode ser limitado a fotos escolhidas pelo usuário.',
                status: _statusLabel,
              ),
              const SizedBox(height: DS.spaceLg),
              if (_selectedImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(DS.radiusLg),
                  child: Image.file(
                    File(_selectedImage!.path),
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: DS.spaceLg),
              ],
              if (_message != null) ...[
                _MessageCard(message: _message!),
                const SizedBox(height: DS.spaceMd),
              ],
              FilledButton.icon(
                onPressed: _isLoading ? null : _requestPermission,
                icon: const Icon(Icons.lock_open_outlined),
                label: const Text('Solicitar acesso'),
              ),
              const SizedBox(height: DS.spaceMd),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _pickImage,
                icon: const Icon(Icons.image_search),
                label: const Text('Selecionar imagem'),
              ),
              if (_permissionStatus?.isPermanentlyDenied ?? false) ...[
                const SizedBox(height: DS.spaceMd),
                TextButton.icon(
                  onPressed: _openSettings,
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Abrir configurações'),
                ),
              ],
              if (_isLoading) ...[
                const SizedBox(height: DS.spaceLg),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String get _statusLabel {
    final status = _permissionStatus;
    if (status == null) return 'Verificando...';
    if (status.isGranted) return 'Permitido';
    if (status.isLimited) return 'Acesso limitado';
    if (status.isPermanentlyDenied) return 'Bloqueado permanentemente';
    if (status.isRestricted) return 'Restrito pelo dispositivo';
    return 'Não permitido ou não exigido pela plataforma';
  }

  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  void _log(String message) {
    AppLogger.session('[DEVICE][GALLERY] $message');
  }

  void _logError(String message, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'DEVICE-GALLERY',
      message,
      error: error,
      stackTrace: stackTrace,
    );
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
            Icon(icon, size: 64, color: AppTheme.primary),
            const SizedBox(height: DS.spaceMd),
            Text(title, style: AppTheme.titleMedium),
            const SizedBox(height: DS.spaceSm),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: DS.spaceMd),
            Chip(label: Text(status)),
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
