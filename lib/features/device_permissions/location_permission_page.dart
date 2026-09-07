import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/app_bottom_nav.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  LocationPermission? _permission;
  Position? _position;
  bool? _serviceEnabled;
  bool _isLoading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    _log('Verificando serviço e permissão de localização.');

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      _log('Serviço habilitado: $serviceEnabled; permissão: $permission.');

      if (!mounted) return;
      setState(() {
        _serviceEnabled = serviceEnabled;
        _permission = permission;
      });
    } catch (error, stackTrace) {
      _logError('Falha ao verificar localização.', error, stackTrace);
    }
  }

  Future<void> _requestPermission() async {
    if (_isLoading) return;
    _setLoading(true);
    _log('Solicitando permissão de localização.');

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _log('Serviço de localização está desligado.');
        if (mounted) {
          setState(() {
            _serviceEnabled = false;
            _message = 'Ative a localização do dispositivo para continuar.';
          });
        }
        return;
      }

      final permission = await Geolocator.requestPermission();
      _log('Resultado da solicitação de localização: $permission.');

      if (!mounted) return;
      setState(() {
        _serviceEnabled = true;
        _permission = permission;
        _message =
            permission == LocationPermission.whileInUse ||
                permission == LocationPermission.always
            ? 'Acesso à localização autorizado.'
            : permission == LocationPermission.deniedForever
            ? 'A permissão foi bloqueada. Abra as configurações para autorizar.'
            : 'Acesso à localização não autorizado.';
      });
    } catch (error, stackTrace) {
      _logError('Falha ao solicitar localização.', error, stackTrace);
      if (mounted) {
        setState(() => _message = 'Não foi possível solicitar a localização.');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _getCurrentPosition() async {
    if (_isLoading) return;
    _setLoading(true);
    _log('Solicitando posição atual do dispositivo.');

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _log('Posição não solicitada porque o serviço está desligado.');
        if (mounted) {
          setState(() {
            _serviceEnabled = false;
            _message = 'O serviço de localização está desligado.';
          });
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _log('Posição não solicitada. Permissão atual: $permission.');
        if (mounted) {
          setState(() {
            _permission = permission;
            _message = 'A localização não está autorizada.';
          });
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      _log(
        'Posição obtida. Latitude: ${position.latitude}; '
        'longitude: ${position.longitude}; precisão: ${position.accuracy} m.',
      );

      if (!mounted) return;
      setState(() {
        _serviceEnabled = true;
        _permission = permission;
        _position = position;
        _message = 'Localização obtida com sucesso.';
      });
    } catch (error, stackTrace) {
      _logError('Falha ao obter posição atual.', error, stackTrace);
      if (mounted) {
        setState(() => _message = 'Não foi possível obter a localização.');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _openAppSettings() async {
    _log('Abrindo configurações do aplicativo.');
    final opened = await permissions.openAppSettings();
    _log('Resultado da abertura das configurações: $opened.');
  }

  Future<void> _openLocationSettings() async {
    _log('Abrindo configurações de localização do dispositivo.');
    final opened = await Geolocator.openLocationSettings();
    _log('Resultado da abertura das configurações de localização: $opened.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Acesso à localização'),
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
                icon: Icons.location_on_outlined,
                title: 'Localização',
                description: 'Autorize a localização durante o uso do aplicativo para testar serviços próximos.',
                status: _statusLabel,
              ),
              const SizedBox(height: DS.spaceLg),
              if (_position != null) ...[
                _PositionCard(position: _position!),
                const SizedBox(height: DS.spaceMd),
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
                onPressed: _isLoading ? null : _getCurrentPosition,
                icon: const Icon(Icons.my_location),
                label: const Text('Obter localização atual'),
              ),
              if (_serviceEnabled == false) ...[
                const SizedBox(height: DS.spaceMd),
                TextButton.icon(
                  onPressed: _openLocationSettings,
                  icon: const Icon(Icons.location_disabled_outlined),
                  label: const Text('Ativar localização do dispositivo'),
                ),
              ],
              if (_permission == LocationPermission.deniedForever) ...[
                const SizedBox(height: DS.spaceMd),
                TextButton.icon(
                  onPressed: _openAppSettings,
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Abrir configurações do aplicativo'),
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
    if (_serviceEnabled == false) return 'Serviço de localização desligado';
    final permission = _permission;
    if (permission == null) return 'Verificando...';
    if (permission == LocationPermission.always) return 'Permitido sempre';
    if (permission == LocationPermission.whileInUse) {
      return 'Permitido durante o uso';
    }
    if (permission == LocationPermission.deniedForever) {
      return 'Bloqueado permanentemente';
    }
    if (permission == LocationPermission.unableToDetermine) {
      return 'Não foi possível determinar';
    }
    return 'Não permitido';
  }

  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  void _log(String message) {
    AppLogger.session('[DEVICE][LOCATION] $message');
  }

  void _logError(String message, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'DEVICE-LOCATION',
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class _PositionCard extends StatelessWidget {
  final Position position;

  const _PositionCard({required this.position});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DS.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latitude: ${position.latitude.toStringAsFixed(6)}'),
            const SizedBox(height: DS.spaceXs),
            Text('Longitude: ${position.longitude.toStringAsFixed(6)}'),
            const SizedBox(height: DS.spaceXs),
            Text('Precisão: ${position.accuracy.toStringAsFixed(1)} metros'),
          ],
        ),
      ),
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
