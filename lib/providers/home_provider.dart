import 'package:flutter/material.dart';

import '../core/storage/secure_storage_service.dart';
import '../models/familia.dart';
import '../services/familia_service.dart';

class HomeProvider extends ChangeNotifier {
  final FamiliaService _service = FamiliaService();
  final SecureStorageService _storage = SecureStorageService();
  bool isLoading = false;
  Familia? titular;
  PlanoFamilia? planoAtivo;

  Future<void> loadHome() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _storage.getAccessToken();

      if (token == null) {
        return;
      }

      final cpf = await _storage.getCpf();

      if (cpf == null) {
        return;
      }

      final response = await _service.getFamilia(cpf: cpf, token: token);

      final familia = (response['items'] as List);

      titular = Familia.fromJson(familia.first);

      planoAtivo = titular!.planos.firstWhere(
        (p) => p.statusCarteira == 'ativo',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
