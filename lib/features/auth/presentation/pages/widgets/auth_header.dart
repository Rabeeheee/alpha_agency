import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable authentication header widget with logo and welcome text
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 24),
        _buildWelcomeText(),
        const SizedBox(height: 8),
        _buildSubtitle(),
      ],
    );
  }

  // app logo container
  Widget _buildLogo() {
    return Container(
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
    );
  }

  //welcome title text
  Widget _buildWelcomeText() {
    return const Text(
      'Welcome Back',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  //subtitle text
  Widget _buildSubtitle() {
    return const Text(
      'Sign in to your account',
      style: TextStyle(
        fontSize: 16,
        color: AppColors.secondaryTextColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}