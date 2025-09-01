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
    print('Profile JSON Response: $json'); // Debug log
    
    // Handle name field - server might return it as 'name' or split as first_name/last_name
    String displayName = '';
    
    // First try direct 'name' field
    displayName = _parseString(json['name']) ?? '';
    
    // If no direct name field, try first_name (prioritizing it as the single name)
    if (displayName.isEmpty) {
      final firstName = _parseString(json['first_name']) ?? '';
      if (firstName.isNotEmpty) {
        displayName = firstName;
      }
    }
    
    // If still empty, try other fallback name fields
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
              (_parseString(json['user_profile']?['mobile']) ?? '+91 9876543210'), // Get mobile from nested user_profile if available
    );
  }
  
  /// Helper method to safely parse string values
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
      'first_name': name, // Store single name in first_name field
      'last_name': '', // Keep last_name empty
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