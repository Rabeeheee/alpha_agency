import 'package:alpha_agency/features/auth/presentation/pages/widgets/auth_header.dart';
import 'package:alpha_agency/features/auth/presentation/pages/widgets/custom_button.dart';
import 'package:alpha_agency/features/auth/presentation/pages/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../profile/presentation/pages/dashboard_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';


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
    _initializeDefaultCredentials();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _authStateListener,
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

//DEFAULT CREDENTIALS
  void _initializeDefaultCredentials() {
    _usernameController.text = AppConstants.defaultUsername;
    _passwordController.text = AppConstants.defaultPassword;
  }

  void _disposeControllers() {
    _usernameController.dispose();
    _passwordController.dispose();
  }

  
  void _authStateListener(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      _navigateToDashboard();
    } else if (state is AuthError) {
      _showErrorMessage(state.message);
    }
  }

  /// NavigatION TO dashboard page after successful login
  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  /// Show error message in snackbar
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }

  // main body content
  Widget _buildBody(AuthState state) {
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
                //AUTH HEADER
                const AuthHeader(),
                const SizedBox(height: 48),
                _buildUsernameField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 32),
                _buildLoginButton(state),
                const SizedBox(height: 16),
                if (state is AuthLoading) _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    //CUSTOM TEXT FIELD BUTTON
    return CustomTextField(
      controller: _usernameController,
      labelText: 'Username',
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) => value?.isEmpty == true ? 'Please enter username' : null,
    );
  }

  
  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      labelText: 'Password',
      prefixIcon: Icons.lock,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility : Icons.visibility_off,
          color: AppColors.mediumGrey,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      validator: (value) => value?.isEmpty == true ? 'Please enter password' : null,
    );
  }

  // login button with loading state
  Widget _buildLoginButton(AuthState state) {
    //CUSTOM LOGIN BUTTOM 
    return CustomButton(
      text: 'Login',
      onPressed: state is AuthLoading ? null : _handleLogin,
      height: 56,
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

  /// Handle login form submission
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