import '../../domain/entities/user_profile.dart';

/// User profile data model
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.name,
    required super.email,
    required super.mobile,
  });
  
  /// Create from JSON response
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
  
  /// Convert to entity
  UserProfile toEntity() {
    return UserProfile(
      name: name,
      email: email,
      mobile: mobile,
    );
  }
}