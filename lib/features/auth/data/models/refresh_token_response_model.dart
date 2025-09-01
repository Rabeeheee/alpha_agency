import '../../domain/entities/token.dart';

/// Refresh token response data model
class RefreshTokenResponseModel extends Token {
  const RefreshTokenResponseModel({
    required super.accessToken,
    required super.refreshToken,
  });
  
  /// Create from JSON response
  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
    );
  }
  
  /// Convert to entity
  Token toEntity() {
    return Token(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}