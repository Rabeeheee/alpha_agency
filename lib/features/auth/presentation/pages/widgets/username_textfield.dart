import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Username input field widget
class UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
}