import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_profile_model.dart';
import '../models/update_profile_request_model.dart';

/// Remote data source for profile operations
abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateProfile(UpdateProfileRequestModel request);
}

/// Implementation of profile remote data source
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient client;
  
  ProfileRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await client.get(AppConstants.userInfoEndpoint);
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get user profile: ${e.message}');
    }
  }
  
  @override
  Future<UserProfileModel> updateProfile(UpdateProfileRequestModel request) async {
    try {
      final response = await client.post(
        AppConstants.updateProfileEndpoint,
        data: request.toFormData(),
      );
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }
}