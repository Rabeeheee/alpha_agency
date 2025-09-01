import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase implements UseCase<void, String> {
  final AuthRepository repository;
  
  LogoutUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.logout(params);
  }
}