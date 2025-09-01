import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

/// Base class for profile states
abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

/// Initial profile state
class ProfileInitial extends ProfileState {}

/// Profile loading state
class ProfileLoading extends ProfileState {}

/// Profile loaded successfully state
class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  
  const ProfileLoaded(this.profile);
  
  @override
  List<Object> get props => [profile];
}

/// Profile update success state
class ProfileUpdateSuccess extends ProfileState {
  final UserProfile profile;
  
  const ProfileUpdateSuccess(this.profile);
  
  @override
  List<Object> get props => [profile];
}

/// Profile error state
class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(this.message);
  
  @override
  List<Object> get props => [message];
}