import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_profile_model.dart';
import '../models/update_profile_request_model.dart';

/// Contract for profile remote data source
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
      print('Get Profile Response: ${response.data}'); // Debug log

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
      print('DioException in getUserProfile: ${e.message}');
      print('Response data: ${e.response?.data}');
      throw Exception('Failed to get user profile: ${e.message}');
    } catch (e) {
      print('Exception in getUserProfile: $e');
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> updateProfile(UpdateProfileRequestModel request) async {
    try {
      print('Update Profile Request: ${request.toFormData()}'); // Debug log

      final response = await client.post(
        AppConstants.updateProfileEndpoint,
        data: request.toFormData(),
      );

      print('Update Profile Response: ${response.data}'); // Debug log

      // After update, fetch the latest profile data from the server
      // instead of relying on the update response which might be empty
      try {
        print('Fetching updated profile from server...');
        final updatedProfileResponse = await client.get(AppConstants.userInfoEndpoint);
        print('Updated Profile Response: ${updatedProfileResponse.data}');
        
        // Handle different response structures for the fetched profile
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
        print('Failed to fetch updated profile, creating from request: $fetchError');
        // Fallback: create profile model from request data
        // Since server response has first_name/last_name but we sent name field,
        // we need to handle the mapping properly
        final fallbackData = {
          'first_name': request.name.trim(), // Map name to first_name for the model
          'last_name': '',
          'name': request.name.trim(), // Also include name field for compatibility
          'email': request.email,
          'mobile': '+91 9876543210', // fallback mobile
        };
        
        print('Fallback data: $fallbackData');
        return UserProfileModel.fromJson(fallbackData);
      }
    } on DioException catch (e) {
      print('DioException in updateProfile: ${e.message}');
      print('Response data: ${e.response?.data}');
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      print('Exception in updateProfile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }
}