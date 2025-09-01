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
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}