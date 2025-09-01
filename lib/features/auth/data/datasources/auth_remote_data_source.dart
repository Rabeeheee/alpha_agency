import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/refresh_token_response_model.dart';

/// Remote data source for authentication operations
abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RefreshTokenResponseModel> refreshToken(String refreshToken);
  Future<void> logout(String refreshToken);
}

/// Implementation of authentication remote data source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;
  
  AuthRemoteDataSourceImpl(this.client);
  
  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await client.post(
        AppConstants.loginEndpoint,
        data: request.toFormData(),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }
  
  @override
  Future<RefreshTokenResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await client.post(
        AppConstants.refreshTokenEndpoint,
        data: {'refresh': refreshToken},
      );
      return RefreshTokenResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Token refresh failed: ${e.message}');
    }
  }
  
  @override
  Future<void> logout(String refreshToken) async {
    try {
      await client.post(
        AppConstants.logoutEndpoint,
        data: {'refresh': refreshToken},
      );
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.message}');
    }
  }
}