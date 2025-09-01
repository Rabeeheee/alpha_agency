import '../../domain/entities/update_profile_request.dart';

/// Update profile request data model
class UpdateProfileRequestModel extends UpdateProfileRequest {
  const UpdateProfileRequestModel({
    required super.name,
    required super.email,
  });
  
  /// Convert to form data for API request
  Map<String, dynamic> toFormData() {
    return {
      'name': name,
      'email': email,
    };
  }
  
  /// Create from entity
  factory UpdateProfileRequestModel.fromEntity(UpdateProfileRequest entity) {
    return UpdateProfileRequestModel(
      name: entity.name,
      email: entity.email,
    );
  }
}