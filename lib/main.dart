import 'package:alpha_agency/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/constants/app_colors.dart';
import 'core/network/dio_client.dart';
import 'core/utils/token_manager.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/refresh_token_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/pages/dashboard_page.dart';

/// Service locator instance
final GetIt sl = GetIt.instance;

/// Main entry point of the application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _setupDependencyInjection();
  runApp(const MyApp());
}

/// Setup dependency injection container
void _setupDependencyInjection() {
  // Core dependencies
  sl.registerLazySingleton<TokenManager>(() => TokenManager());
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  // Auth feature dependencies
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));

  // Profile feature dependencies
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // BLoC dependencies
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        refreshTokenUseCase: sl(),
        tokenManager: sl(),
      ));
  sl.registerFactory(() => ProfileBloc(
        getUserProfileUseCase: sl(),
        updateProfileUseCase: sl(),
      ));
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(CheckAuthStatusEvent())),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Clean Architecture App',
        debugShowCheckedModeBanner: false,
        theme: _buildAppTheme(),
        home: const AuthenticationWrapper(),
      ),
    );
  }

  /// Build application theme with black and white color scheme
  ThemeData _buildAppTheme() {
  return ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: AppColors.primaryBlack,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlack,
      secondary: AppColors.darkGrey,
      surface: AppColors.surfaceColor,
      onPrimary: AppColors.primaryWhite,
      onSecondary: AppColors.primaryWhite,
      onSurface: AppColors.primaryTextColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.primaryTextColor),
      displayMedium: TextStyle(color: AppColors.primaryTextColor),
      displaySmall: TextStyle(color: AppColors.primaryTextColor),
      headlineLarge: TextStyle(color: AppColors.primaryTextColor),
      headlineMedium: TextStyle(color: AppColors.primaryTextColor),
      headlineSmall: TextStyle(color: AppColors.primaryTextColor),
      titleLarge: TextStyle(color: AppColors.primaryTextColor),
      titleMedium: TextStyle(color: AppColors.primaryTextColor),
      titleSmall: TextStyle(color: AppColors.primaryTextColor),
      bodyLarge: TextStyle(color: AppColors.primaryTextColor),
      bodyMedium: TextStyle(color: AppColors.primaryTextColor),
      bodySmall: TextStyle(color: AppColors.secondaryTextColor),
      labelLarge: TextStyle(color: AppColors.primaryTextColor),
      labelMedium: TextStyle(color: AppColors.secondaryTextColor),
      labelSmall: TextStyle(color: AppColors.secondaryTextColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlack,
      foregroundColor: AppColors.primaryWhite,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: AppColors.primaryWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlack, width: 2),
      ),
      filled: true,
      fillColor: AppColors.veryLightGrey,
    ),

    // ✅ Updated types here
    cardTheme: CardThemeData(
      color: AppColors.primaryWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.lightGrey, width: 1),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.primaryWhite,
      titleTextStyle: TextStyle(
        color: AppColors.primaryTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.secondaryTextColor,
        fontSize: 14,
      ),
      // shape, elevation, etc. can be added if you need them
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.primaryBlack,
      contentTextStyle: TextStyle(color: AppColors.primaryWhite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    useMaterial3: true,
  );
}

}

/// Authentication wrapper to handle initial route based on auth state
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show loading screen while checking auth status
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlack),
              ),
            ),
          );
        }
        
        // Navigate based on authentication state
        if (state is AuthAuthenticated) {
          return const DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}