import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

/// Manages authentication tokens and automatic refresh using secure storage
class TokenManager {
  Timer? _refreshTimer;
  static const _storage = FlutterSecureStorage();
  
  /// Save access and refresh tokens to secure storage
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    try {
      await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
      await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
    } catch (e) {
      throw Exception('Failed to save tokens: $e');
    }
  }
  
  /// Retrieve access token from secure storage
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      print('Error reading access token: $e');
      return null;
    }
  }
  
  /// Retrieve refresh token from secure storage
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      print('Error reading refresh token: $e');
      return null;
    }
  }
  
  /// Clear all stored tokens
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
      _refreshTimer?.cancel();
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }
  
  /// Check if user is authenticated (has valid access token)
  Future<bool> isAuthenticated() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking authentication: $e');
      return false;
    }
  }
  
  /// Check if tokens exist (for app restart scenarios)
  Future<bool> hasStoredTokens() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();
      return accessToken != null && refreshToken != null && 
             accessToken.isNotEmpty && refreshToken.isNotEmpty;
    } catch (e) {
      print('Error checking stored tokens: $e');
      return false;
    }
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