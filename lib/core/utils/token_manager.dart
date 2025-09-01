import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Manages authentication tokens and automatic refresh
class TokenManager {
  Timer? _refreshTimer;
  
  /// Save access and refresh tokens to local storage
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.accessTokenKey, accessToken);
    await prefs.setString(AppConstants.refreshTokenKey, refreshToken);
  }
  
  /// Retrieve access token from local storage
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.accessTokenKey);
  }
  
  /// Retrieve refresh token from local storage
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.refreshTokenKey);
  }
  
  /// Clear all stored tokens
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.accessTokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
    _refreshTimer?.cancel();
  }
  
  /// Check if user is authenticated (has valid access token)
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
  
  /// Start automatic token refresh timer
  void startTokenRefreshTimer(Function() refreshCallback) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: AppConstants.tokenRefreshInterval),
      (timer) => refreshCallback(),
    );
  }
  
  /// Stop token refresh timer
  void stopTokenRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}