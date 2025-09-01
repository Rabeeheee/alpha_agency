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
    
    final result = await getUserProfileUseCase();
    
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
  
  /// Handle updating user profile
  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    final result = await updateProfileUseCase(event.request);
    
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileUpdateSuccess(profile)),
    );
  }
}