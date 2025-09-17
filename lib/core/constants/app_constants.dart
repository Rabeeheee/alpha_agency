/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://warrantykeeper.thealphagency.com/apis/v1/';
  
  // Default Login Credentials
  static const String defaultUsername = '9999999999';
  static const String defaultPassword = 'Alpha@2025';
  
  // Token Refresh Interval (10 minutes in milliseconds)
  static const int tokenRefreshInterval = 10 * 60 * 1000;
  
  // API Endpoints
  static const String loginEndpoint = 'login';
  static const String refreshTokenEndpoint = 'refresh_token';
  static const String logoutEndpoint = 'logout';
  static const String userInfoEndpoint = 'user_info';
  static const String updateProfileEndpoint = 'update_profile';
  
  // Storage Keys
  static const String accessTokenKey = 'secure_access_token';
  static const String refreshTokenKey = 'secure_refresh_token';

  // Validation Constants
  static const int mobileNumberLength = 10;
  static const int minPasswordLength = 6;
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String invalidCredentialsMessage = 'Invalid mobile number or password. Please check your credentials.';
  static const String unexpectedErrorMessage = 'An unexpected error occurred. Please try again.';
}