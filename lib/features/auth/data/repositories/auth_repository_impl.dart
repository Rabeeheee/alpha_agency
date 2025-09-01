import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/token_manager.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

/// Implementation of authentication repository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenManager tokenManager;
  
  AuthRepositoryImpl(this.remoteDataSource, this.tokenManager);
  
  @override
  Future<Either<Failure, Token>> login(LoginRequest request) async {
    try {
      final requestModel = LoginRequestModel.fromEntity(request);
      final response = await remoteDataSource.login(requestModel);
      
      // Save tokens to local storage
      await tokenManager.saveTokens(
        response.accessToken,
        response.refreshToken,
      );
      
      return Right(response.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Token>> refreshToken(String refreshToken) async {
    try {
      final response = await remoteDataSource.refreshToken(refreshToken);
      
      // Update stored tokens
      await tokenManager.saveTokens(
        response.accessToken,
        response.refreshToken,
      );
      
      return Right(response.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {
    try {
      await remoteDataSource.logout(refreshToken);
      await tokenManager.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}