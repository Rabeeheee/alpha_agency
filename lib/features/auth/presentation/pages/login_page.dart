import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../profile/presentation/pages/dashboard_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Login page widget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill with default credentials
    _usernameController.text = AppConstants.defaultUsername;
    _passwordController.text = AppConstants.defaultPassword;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to dashboard on successful login
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Logo/Title
                      _buildHeader(),
                      const SizedBox(height: 48),

                      // Username Field
                      _buildUsernameField(),
                      const SizedBox(height: 16),

                      // Password Field
                      _buildPasswordField(),
                      const SizedBox(height: 32),

                      // Login Button
                      _buildLoginButton(state),

                      const SizedBox(height: 16),

                      // Loading Indicator
                      if (state is AuthLoading) _buildLoadingIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryBlack,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.primaryWhite,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to your account',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build username input field
  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: AppColors.primaryTextColor),
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: const TextStyle(color: AppColors.secondaryTextColor),
        prefixIcon: const Icon(Icons.phone, color: AppColors.mediumGrey),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter username';
        }
        return null;
      },
    );
  }

  /// Build password input field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: AppColors.primaryTextColor),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: AppColors.secondaryTextColor),
        prefixIcon: const Icon(Icons.lock, color: AppColors.mediumGrey),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: AppColors.mediumGrey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
    );
  }

  /// Build login button
  Widget _buildLoginButton(AuthState state) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: state is AuthLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlack,
          foregroundColor: AppColors.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlack),
      ),
    );
  }

  // Handle login button press
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }
}
