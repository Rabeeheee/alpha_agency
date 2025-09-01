import '../../domain/entities/token.dart';

/// Login response data model
class LoginResponseModel extends Token {
  final bool error;
  final String message;
  
  const LoginResponseModel({
    required this.error,
    required this.message,
    required super.accessToken,
    required super.refreshToken,
  });
  
  /// Create from JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['token']['access_token'] ?? '',
      refreshToken: json['token']['refresh_token'] ?? '',
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