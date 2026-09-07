import 'dart:async';

import '../core/storage/secure_storage_service.dart';
import '../core/utils/app_logger.dart';
import '../models/auth_response.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;
  final SecureStorageService storage;

  AuthSession? _currentSession;
  Future<AuthSession?>? _refreshInProgress;

  AuthRepository({AuthService? service, SecureStorageService? storage})
    : service = service ?? AuthService(),
      storage = storage ?? SecureStorageService();

  AuthSession? get currentSession => _currentSession;

  Future<AuthSession> login({
    required String cpf,
    required String senha,
  }) async {
    AppLogger.session('Iniciando novo login.');

    try {
      final authorization = await service.authorization(cpf: cpf, senha: senha);

      AppLogger.session(
        'Autorização inicial concluída. Solicitando token principal.',
      );

      final token = await service.accessToken(
        code: authorization.code,
        authorizationToken: authorization.accessToken,
      );

      final now = DateTime.now().toUtc();
      final session = AuthSession(
        identityAccessToken: authorization.accessToken,
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        identityAccessTokenExpiresAt: now.add(
          Duration(seconds: authorization.expiresIn),
        ),
        accessTokenExpiresAt: now.add(Duration(seconds: token.expiresIn)),
        cpf: cpf,
      );

      AppLogger.session(
        'Sessão criada. Access token válido até '
        '${session.accessTokenExpiresAt.toLocal()}.',
      );

      await storage.saveSession(session);
      _currentSession = session;

      AppLogger.session('Sessão salva com sucesso no armazenamento seguro.');

      return session;
    } catch (error, stackTrace) {
      AppLogger.error(
        'SESSION',
        'Falha ao criar a sessão durante o login.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<SessionRestoreResult> restoreSession() async {
    AppLogger.session('Iniciando restauração da sessão.');

    try {
      final session = await storage.getSession();

      if (session == null) {
        AppLogger.session(
          'Nenhuma sessão completa encontrada no armazenamento.',
        );
        _currentSession = null;
        return SessionRestoreResult.unauthenticated;
      }

      AppLogger.session('Sessão encontrada no armazenamento seguro.');
      _currentSession = session;

      if (session.accessTokenIsValid()) {
        AppLogger.session(
          'Access token ainda está válido. Refresh não necessário.',
        );
        return SessionRestoreResult.authenticated;
      }

      AppLogger.session(
        'Access token vencido ou próximo do vencimento. '
        'Iniciando refresh.',
      );

      final refreshedSession = await refreshSession(session: session);

      if (refreshedSession == null) {
        AppLogger.session('Não foi possível renovar a sessão.');
        return SessionRestoreResult.unauthenticated;
      }

      AppLogger.session('Sessão renovada com sucesso.');
      return SessionRestoreResult.authenticated;
    } catch (error, stackTrace) {
      AppLogger.error(
        'SESSION',
        'Erro durante a restauração da sessão.',
        error: error,
        stackTrace: stackTrace,
      );
      await logout();
      return SessionRestoreResult.unauthenticated;
    }
  }

  Future<AuthSession?> refreshSession({AuthSession? session}) {
    final runningRefresh = _refreshInProgress;

    if (runningRefresh != null) {
      AppLogger.session(
        'Já existe um refresh em andamento. '
        'Aguardando a mesma operação.',
      );
      return runningRefresh;
    }

    AppLogger.session('Nenhum refresh em andamento. Criando nova operação.');

    final operation = _performRefresh(session);
    _refreshInProgress = operation;

    return operation.whenComplete(() {
      AppLogger.session('Operação de refresh finalizada.');
      _refreshInProgress = null;
    });
  }

  Future<AuthSession?> _performRefresh(AuthSession? providedSession) async {
    try {
      final session =
          providedSession ?? _currentSession ?? await storage.getSession();

      if (session == null) {
        AppLogger.session('Refresh cancelado porque não existe sessão.');
        await logout();
        return null;
      }

      if (!session.identityAccessTokenIsValid()) {
        AppLogger.session(
          'Refresh cancelado porque o token de identidade expirou.',
        );
        await logout();
        return null;
      }

      AppLogger.session('Token de identidade válido. Chamando API de refresh.');

      final token = await service.refreshToken(
        refreshToken: session.refreshToken,
        identityAccessToken: session.identityAccessToken,
      );

      final refreshedSession = session.copyWith(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        accessTokenExpiresAt: DateTime.now().toUtc().add(
          Duration(seconds: token.expiresIn),
        ),
      );

      await storage.saveSession(refreshedSession);
      _currentSession = refreshedSession;

      AppLogger.session(
        'Tokens rotacionados e sessão atualizada. Nova validade: '
        '${refreshedSession.accessTokenExpiresAt.toLocal()}.',
      );

      return refreshedSession;
    } catch (error, stackTrace) {
      AppLogger.error(
        'SESSION',
        'Refresh da sessão falhou.',
        error: error,
        stackTrace: stackTrace,
      );
      await logout();
      return null;
    }
  }

  Future<String?> getValidAccessToken() async {
    AppLogger.session('Solicitado um access token válido.');

    final session = _currentSession ?? await storage.getSession();

    if (session == null) {
      AppLogger.session('Não existe sessão disponível para fornecer o token.');
      return null;
    }

    if (session.accessTokenIsValid()) {
      AppLogger.session('Access token atual está válido.');
      _currentSession = session;
      return session.accessToken;
    }

    AppLogger.session('Access token não está válido. Solicitando refresh.');

    final refreshedSession = await refreshSession(session: session);

    if (refreshedSession == null) {
      AppLogger.session('Não foi possível obter um access token válido.');
      return null;
    }

    AppLogger.session('Novo access token disponível depois do refresh.');
    return refreshedSession.accessToken;
  }

  Future<bool> isAuthenticated() async {
    final result = await restoreSession();
    return result == SessionRestoreResult.authenticated;
  }

  Future<void> logout() async {
    AppLogger.session('Limpando sessão local.');
    _currentSession = null;
    await storage.clear();
    AppLogger.session('Sessão local removida.');
  }
}
