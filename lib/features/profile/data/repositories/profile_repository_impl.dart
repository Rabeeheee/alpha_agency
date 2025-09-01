import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/update_profile_request.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart'; 
import '../models/update_profile_request_model.dart';

/// Implementation of profile repository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final response = await remoteDataSource.getUserProfile();
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    try {
      final requestModel = UpdateProfileRequestModel.fromEntity(request);
      final response = await remoteDataSource.updateProfile(requestModel);
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
