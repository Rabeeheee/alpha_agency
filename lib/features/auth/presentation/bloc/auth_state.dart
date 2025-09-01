import 'package:equatable/equatable.dart';

/// Base class for authentication states
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

/// Initial authentication state
class AuthInitial extends AuthState {}

/// Authentication loading state
class AuthLoading extends AuthState {}

/// Successfully authenticated state
class AuthAuthenticated extends AuthState {}

/// Not authenticated state
class AuthUnauthenticated extends AuthState {}

/// Authentication error state
class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object> get props => [message];
}