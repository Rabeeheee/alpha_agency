import 'package:equatable/equatable.dart';
import '../../domain/entities/update_profile_request.dart';

/// Base class for profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  
  @override
  List<Object> get props => [];
}

/// Event to load user profile
class LoadUserProfileEvent extends ProfileEvent {}

/// Event to update user profile
class UpdateUserProfileEvent extends ProfileEvent {
  final UpdateProfileRequest request;
  
  const UpdateUserProfileEvent(this.request);
  
  @override
  List<Object> get props => [request];
}