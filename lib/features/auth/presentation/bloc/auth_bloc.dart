import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/token_manager.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for handling authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;
  final TokenManager tokenManager;
  
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.refreshTokenUseCase,
    required this.tokenManager,
  }) : super(AuthInitial()) {
    // Register event handlers
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<LogoutEvent>(_onLogout);
  }
  
  /// Handle authentication status check
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Check if tokens exist in storage
      final hasTokens = await tokenManager.hasStoredTokens();
      
      if (!hasTokens) {
        emit(AuthUnauthenticated());
        return;
      }
      
      // Try to refresh token to validate if it's still valid
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken == null) {
        await tokenManager.clearTokens();
        emit(AuthUnauthenticated());
        return;
      }
      
      final result = await refreshTokenUseCase(refreshToken);
      
      result.fold(
        (failure) async {
          // Token is invalid, clear storage and require login
          await tokenManager.clearTokens();
          emit(AuthUnauthenticated());
        },
        (token) {
          // Token is valid, user is authenticated
          emit(AuthAuthenticated());
          _startTokenRefreshTimer();
        },
      );
    } catch (e) {
      // On any error, clear tokens and require login
      await tokenManager.clearTokens();
      emit(AuthUnauthenticated());
    }
  }
  
  /// Handle user login
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // Validate input
    final validationError = _validateLoginInput(event.username, event.password);
    if (validationError != null) {
      emit(AuthError(validationError));
      return;
    }
    
    final loginRequest = LoginRequest(
      username: event.username,
      password: event.password,
    );
    
    try {
      final result = await loginUseCase(loginRequest);
      
      result.fold(
        (failure) => emit(AuthError(_mapFailureToMessage(failure.message))),
        (token) {
          emit(AuthAuthenticated());
          _startTokenRefreshTimer();
        },
      );
    } catch (e) {
      emit(AuthError('An unexpected error occurred. Please try again.'));
    }
  }
  
  /// Handle token refresh
  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken == null) {
        await tokenManager.clearTokens();
        emit(AuthUnauthenticated());
        return;
      }
      
      final result = await refreshTokenUseCase(refreshToken);
      
      result.fold(
        (failure) async {
          await tokenManager.clearTokens();
          emit(AuthUnauthenticated());
        },
        (token) {
          // Token refreshed successfully, continue with current state
          // Don't emit new state unless current state is error
          if (state is AuthError) {
            emit(AuthAuthenticated());
          }
        },
      );
    } catch (e) {
      await tokenManager.clearTokens();
      emit(AuthUnauthenticated());
    }
  }
  
  /// Handle user logout
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken != null) {
        await logoutUseCase(refreshToken);
      }
    } catch (e) {
      // Even if logout API fails, we still clear local tokens
      print('Logout API failed: $e');
    } finally {
      await tokenManager.clearTokens();
      tokenManager.stopTokenRefreshTimer();
      emit(AuthUnauthenticated());
    }
  }
  
  /// Validate login input
  String? _validateLoginInput(String username, String password) {
    // Validate username (mobile number)
    if (username.isEmpty) {
      return 'Please enter mobile number';
    }
    
    // Check if username contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(username)) {
      return 'Mobile number should contain only digits';
    }
    
    // Check if username is exactly 10 digits
    if (username.length != 10) {
      return 'Mobile number should be exactly 10 digits';
    }
    
    // Validate password
    if (password.isEmpty) {
      return 'Please enter password';
    }
    
    if (password.length < 6) {
      return 'Password should be at least 6 characters long';
    }
    
    // Password strength validation (at least one uppercase, one lowercase, one number, one special character)
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
    }
    
    return null;
  }
  
  /// Map failure messages to user-friendly messages
  String _mapFailureToMessage(String failure) {
    if (failure.toLowerCase().contains('network') || failure.toLowerCase().contains('connection')) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (failure.toLowerCase().contains('401') || failure.toLowerCase().contains('unauthorized')) {
      return 'Invalid mobile number or password. Please check your credentials.';
    } else if (failure.toLowerCase().contains('server') || failure.toLowerCase().contains('500')) {
      return 'Server error. Please try again later.';
    } else if (failure.toLowerCase().contains('timeout')) {
      return 'Request timeout. Please check your connection and try again.';
    } else {
      return 'Login failed. Please try again.';
    }
  }
  
  /// Start automatic token refresh timer
  void _startTokenRefreshTimer() {
    tokenManager.startTokenRefreshTimer(() {
      if (!isClosed) {
        add(RefreshTokenEvent());
      }
    });
  }
  
  @override
  Future<void> close() {
    tokenManager.stopTokenRefreshTimer();
    return super.close();
  }
}