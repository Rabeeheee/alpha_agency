import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC for handling profile logic
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  
  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    // Register event handlers
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }
  
  /// Handle loading user profile
  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      final result = await getUserProfileUseCase();
      
      result.fold(
        (failure) {
          print('Profile Load Failure: ${failure.message}');
          emit(ProfileError(failure.message));
        },
        (profile) {
          print('Profile Loaded Successfully: ${profile.toString()}');
          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      print('Exception in _onLoadUserProfile: $e');
      emit(ProfileError('Failed to load profile: $e'));
    }
  }
  
  /// Handle updating user profile
  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      final result = await updateProfileUseCase(event.request);
      
      result.fold(
        (failure) {
          print('Profile Update Failure: ${failure.message}');
          emit(ProfileError(failure.message));
        },
        (profile) {
          print('Profile Updated Successfully: ${profile.toString()}');
          emit(ProfileUpdateSuccess(profile));
          // Don't immediately trigger reload since the update already fetches latest data
        },
      );
    } catch (e) {
      print('Exception in _onUpdateUserProfile: $e');
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}