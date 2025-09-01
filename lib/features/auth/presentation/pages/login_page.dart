import 'package:alpha_agency/features/auth/presentation/pages/widgets/auth_header.dart';
import 'package:alpha_agency/features/auth/presentation/pages/widgets/custom_button.dart';
import 'package:alpha_agency/features/auth/presentation/pages/widgets/password_textfield.dart';
import 'package:alpha_agency/features/auth/presentation/pages/widgets/username_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/pages/dashboard_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

import 'widgets/loading_indicator.dart';

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
    _usernameController.text = '9999999999'; 
    _passwordController.text = 'Alpha@2025'; 
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getErrorMessage(state.message)),
                backgroundColor: AppColors.errorColor,
                duration: const Duration(seconds: 4),
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
                      //login header
                      const LoginHeader(),
                      const SizedBox(height: 48),
                      //username field
                      UsernameField(controller: _usernameController),
                      const SizedBox(height: 16),
                      //password field
                      PasswordField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onToggleVisibility: _togglePasswordVisibility,
                      ),
                      const SizedBox(height: 32),
                      //login button
                      LoginButton(
                        onPressed: state is AuthLoading ? null : _handleLogin,
                      ),
                      const SizedBox(height: 16),
                      if (state is AuthLoading) const LoadingIndicator(),
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

  String _getErrorMessage(String message) {
    // Map generic error messages to user-friendly ones
    switch (message) {
      case 'invalid_credentials':
        return 'Invalid username or password. Please try again.';
      case 'network_error':
        return 'Network error. Please check your internet connection.';
      case 'server_error':
        return 'Server error. Please try again later.';
      default:
        return message.isEmpty ? 'An error occurred. Please try again.' : message;
    }
  }
}