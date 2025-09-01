import 'package:equatable/equatable.dart';

/// Base class for authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object> get props => [];
}

/// Event to check authentication status
class CheckAuthStatusEvent extends AuthEvent {}

/// Event to login user
class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  
  const LoginEvent({
    required this.username,
    required this.password,
  });
  
  @override
  List<Object> get props => [username, password];
}

/// Event to refresh authentication token
class RefreshTokenEvent extends AuthEvent {}

/// Event to logout user
class LogoutEvent extends AuthEvent {}