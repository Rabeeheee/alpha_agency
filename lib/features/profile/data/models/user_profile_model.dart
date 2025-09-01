import '../../domain/entities/user_profile.dart';

/// User profile data model
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.name,
    required super.email,
    required super.mobile,
  });
  
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
   
    
    String displayName = '';
    
    displayName = _parseString(json['name']) ?? '';
    
    if (displayName.isEmpty) {
      final firstName = _parseString(json['first_name']) ?? '';
      if (firstName.isNotEmpty) {
        displayName = firstName;
      }
    }
    
    if (displayName.isEmpty) {
      displayName = _parseString(json['full_name']) ?? 
                   _parseString(json['user_name']) ?? 
                   _parseString(json['username']) ?? '';
    }
    
    return UserProfileModel(
      name: displayName,
      email: _parseString(json['email']) ?? 
             _parseString(json['email_address']) ?? '',
      mobile: _parseString(json['mobile']) ?? 
              _parseString(json['phone']) ?? 
              _parseString(json['phone_number']) ?? 
              (_parseString(json['user_profile']?['mobile']) ?? '+91 9876543210'), 
    );
  }
  
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.trim().isEmpty ? null : value.trim();
    }
    return value.toString().trim().isEmpty ? null : value.toString().trim();
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': name, 
      'last_name': '', 
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