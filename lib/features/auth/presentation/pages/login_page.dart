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

/// Login page widget with enhanced validation and error handling
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
    _passwordController.addListener(() {
      setState(() {}); // Rebuild to update password requirements
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Additional validation is handled in the BLoC
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.primaryBlack),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Clear form and navigate to dashboard
            _usernameController.clear();
            _passwordController.clear();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
              (route) => false, // Remove all previous routes
            );
          } else if (state is AuthError) {
            _showErrorDialog(state.message);
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
                      // Login header
                      const LoginHeader(),
                      const SizedBox(height: 48),

                      // Username field
                      UsernameField(controller: _usernameController),
                      const SizedBox(height: 16),

                      // Password field with requirements
                      PasswordField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onToggleVisibility: _togglePasswordVisibility,
                      ),
                      const SizedBox(height: 32),

                      // Login button
                      LoginButton(
                        onPressed: state is AuthLoading ? null : _handleLogin,
                      ),
                      const SizedBox(height: 16),

                      // Loading indicator
                      if (state is AuthLoading) const LoadingIndicator(),

                      // Debug info (remove in production)
                      if (state is AuthError)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
