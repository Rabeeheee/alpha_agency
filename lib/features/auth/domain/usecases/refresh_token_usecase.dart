import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/token.dart';
import '../repositories/auth_repository.dart';

/// Use case for token refresh
class RefreshTokenUseCase implements UseCase<Token, String> {
  final AuthRepository repository;
  
  RefreshTokenUseCase(this.repository);
  
  @override
  Future<Either<Failure, Token>> call(String params) async {
    return await repository.refreshToken(params);
  }
}