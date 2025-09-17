import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Username input field widget with mobile number validation
class UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 10,
      style: const TextStyle(color: AppColors.primaryTextColor),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
      ],
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        labelStyle: const TextStyle(color: AppColors.secondaryTextColor),
        prefixIcon: const Icon(Icons.phone, color: AppColors.mediumGrey),
        counterText: '', // Hide character counter
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlack, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: AppColors.veryLightGrey,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter mobile number';
        }
        
        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Mobile number should contain only digits';
        }
        
        if (value.length != 10) {
          return 'Mobile number should be exactly 10 digits';
        }
        
        return null;
      },
    );
  }
}