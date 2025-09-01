import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Header widget for login page
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
}