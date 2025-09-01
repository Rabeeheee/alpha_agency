import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// General application failures
class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
}