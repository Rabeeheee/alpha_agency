import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../entities/update_profile_request.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user profile
class UpdateProfileUseCase implements UseCase<UserProfile, UpdateProfileRequest> {
  final ProfileRepository repository;
  
  UpdateProfileUseCase(this.repository);
  
  @override
  Future<Either<Failure, UserProfile>> call(UpdateProfileRequest params) async {
    return await repository.updateProfile(params);
  }
}