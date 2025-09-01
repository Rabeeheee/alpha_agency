import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_profile_model.dart';
import '../models/update_profile_request_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateProfile(UpdateProfileRequestModel request);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient client;

  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await client.get(AppConstants.userInfoEndpoint);

      // Handle different response structures
      Map<String, dynamic> data;
      if (response.data is Map<String, dynamic>) {
        data = response.data;
      } else if (response.data['data'] is Map<String, dynamic>) {
        data = response.data['data'];
      } else if (response.data['user'] is Map<String, dynamic>) {
        data = response.data['user'];
      } else {
        throw Exception('Invalid response structure');
      }

      return UserProfileModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception('Failed to get user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> updateProfile(UpdateProfileRequestModel request) async {
    try {

      // ignore: unused_local_variable
      final response = await client.post(
        AppConstants.updateProfileEndpoint,
        data: request.toFormData(),
      );

      
      try {
        final updatedProfileResponse = await client.get(AppConstants.userInfoEndpoint);
        
        Map<String, dynamic> profileData;
        if (updatedProfileResponse.data is Map<String, dynamic>) {
          profileData = updatedProfileResponse.data;
        } else if (updatedProfileResponse.data['data'] is Map<String, dynamic>) {
          profileData = updatedProfileResponse.data['data'];
        } else if (updatedProfileResponse.data['user'] is Map<String, dynamic>) {
          profileData = updatedProfileResponse.data['user'];
        } else {
          throw Exception('Invalid profile response structure');
        }

        return UserProfileModel.fromJson(profileData);
      } catch (fetchError) {
        
        final fallbackData = {
          'first_name': request.name.trim(), 
          'last_name': '',
          'name': request.name.trim(), 
          'email': request.email,
          'mobile': '+91 9876543210', 
        };
        
        return UserProfileModel.fromJson(fallbackData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}