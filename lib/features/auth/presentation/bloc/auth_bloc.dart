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
    
    // Start automatic token refresh
    _startTokenRefreshTimer();
  }
  
  /// Handle authentication status check
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final isAuthenticated = await tokenManager.isAuthenticated();
    if (isAuthenticated) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }
  
  /// Handle user login
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final loginRequest = LoginRequest(
      username: event.username,
      password: event.password,
    );
    
    final result = await loginUseCase(loginRequest);
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) {
        emit(AuthAuthenticated());
        _startTokenRefreshTimer();
      },
    );
  }
  
  /// Handle token refresh
  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    final refreshToken = await tokenManager.getRefreshToken();
    if (refreshToken == null) {
      emit(AuthUnauthenticated());
      return;
    }
    
    final result = await refreshTokenUseCase(refreshToken);
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (token) => null, // Token already saved in repository
    );
  }
  
  /// Handle user logout
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final refreshToken = await tokenManager.getRefreshToken();
    if (refreshToken != null) {
      await logoutUseCase(refreshToken);
    }
    
    tokenManager.stopTokenRefreshTimer();
    emit(AuthUnauthenticated());
  }
  
  /// Start automatic token refresh timer
  void _startTokenRefreshTimer() {
    tokenManager.startTokenRefreshTimer(() {
      add(RefreshTokenEvent());
    });
  }
  
  @override
  Future<void> close() {
    tokenManager.stopTokenRefreshTimer();
    return super.close();
  }
}