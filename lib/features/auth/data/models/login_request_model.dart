import '../../domain/entities/login_request.dart';

/// Login request data model
class LoginRequestModel extends LoginRequest {
  const LoginRequestModel({
    required super.username,
    required super.password,
  });
  
  /// Convert to form data for API request
  Map<String, dynamic> toFormData() {
    return {
      'username': username,
      'password': password,
    };
  }
  
  /// Create from entity
  factory LoginRequestModel.fromEntity(LoginRequest entity) {
    return LoginRequestModel(
      username: entity.username,
      password: entity.password,
    );
  }
}