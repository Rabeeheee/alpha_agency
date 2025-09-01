import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Password input field widget
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const PasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.primaryTextColor),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: AppColors.secondaryTextColor),
        prefixIcon: const Icon(Icons.lock, color: AppColors.mediumGrey),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.mediumGrey,
          ),
          onPressed: onToggleVisibility,
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
}