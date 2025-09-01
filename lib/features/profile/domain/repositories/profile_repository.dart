import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../entities/update_profile_request.dart';

/// Abstract profile repository interface
abstract class ProfileRepository {
  /// Get user profile information
  Future<Either<Failure, UserProfile>> getUserProfile();
  
  /// Update user profile information
  Future<Either<Failure, UserProfile>> updateProfile(UpdateProfileRequest request);
}