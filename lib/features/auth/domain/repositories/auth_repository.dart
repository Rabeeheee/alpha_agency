import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/login_request.dart';
import '../entities/token.dart';

/// Abstract authentication repository interface
abstract class AuthRepository {
  /// Authenticate user with credentials
  Future<Either<Failure, Token>> login(LoginRequest request);
  
  /// Refresh authentication token
  Future<Either<Failure, Token>> refreshToken(String refreshToken);
  
  /// Logout user and invalidate tokens
  Future<Either<Failure, void>> logout(String refreshToken);
}