import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login_request.dart';
import '../entities/token.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase implements UseCase<Token, LoginRequest> {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  @override
  Future<Either<Failure, Token>> call(LoginRequest params) async {
    return await repository.login(params);
  }
}