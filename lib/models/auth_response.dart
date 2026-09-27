class AuthorizationResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final int? passwordExpiration;
  final String code;

  const AuthorizationResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.code,
    this.passwordExpiration,
  });

  factory AuthorizationResponse.fromJson(Map<String, dynamic> json) {
    return AuthorizationResponse(
      accessToken: _requiredString(json, 'access_token'),
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: _requiredInt(json, 'expires_in'),
      passwordExpiration: _optionalInt(json['pwd_expiration']),
      code: _requiredString(json, 'code'),
    );
  }
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  const TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: _requiredString(json, 'access_token'),
      refreshToken: _requiredString(json, 'refresh_token'),
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: _requiredInt(json, 'expires_in'),
    );
  }
}

class AuthSession {
  final String identityAccessToken;
  final String accessToken;
  final String refreshToken;
  final DateTime identityAccessTokenExpiresAt;
  final DateTime accessTokenExpiresAt;
  final String cpf;

  const AuthSession({
    required this.identityAccessToken,
    required this.accessToken,
    required this.refreshToken,
    required this.identityAccessTokenExpiresAt,
    required this.accessTokenExpiresAt,
    required this.cpf,
  });

  bool accessTokenIsValid({Duration tolerance = const Duration(minutes: 2)}) {
    return accessToken.isNotEmpty &&
        accessTokenExpiresAt.isAfter(DateTime.now().add(tolerance));
  }

  bool identityAccessTokenIsValid({
    Duration tolerance = const Duration(minutes: 2),
  }) {
    return identityAccessToken.isNotEmpty &&
        identityAccessTokenExpiresAt.isAfter(DateTime.now().add(tolerance));
  }

  AuthSession copyWith({
    String? identityAccessToken,
    String? accessToken,
    String? refreshToken,
    DateTime? identityAccessTokenExpiresAt,
    DateTime? accessTokenExpiresAt,
    String? cpf,
  }) {
    return AuthSession(
      identityAccessToken: identityAccessToken ?? this.identityAccessToken,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      identityAccessTokenExpiresAt:
          identityAccessTokenExpiresAt ?? this.identityAccessTokenExpiresAt,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      cpf: cpf ?? this.cpf,
    );
  }
}

enum SessionRestoreResult { authenticated, unauthenticated }

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key]?.toString();
  if (value == null || value.isEmpty) {
    throw FormatException('Campo obrigatório ausente: $key');
  }
  return value;
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = _optionalInt(json[key]);
  if (value == null) {
    throw FormatException('Campo numérico obrigatório ausente: $key');
  }
  return value;
}

int? _optionalInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '');
}
