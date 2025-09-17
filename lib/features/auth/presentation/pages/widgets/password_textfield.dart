import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Password input field widget with enhanced validation
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
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
              return 'Please enter password';
            }
            
            if (value.length < 6) {
              return 'Password should be at least 6 characters long';
            }
            
            // Check for at least one uppercase letter
            if (!RegExp(r'[A-Z]').hasMatch(value)) {
              return 'Password must contain at least one uppercase letter';
            }
            
            // Check for at least one lowercase letter
            if (!RegExp(r'[a-z]').hasMatch(value)) {
              return 'Password must contain at least one lowercase letter';
            }
            
            // Check for at least one digit
            if (!RegExp(r'[0-9]').hasMatch(value)) {
              return 'Password must contain at least one number';
            }
            
            // Check for at least one special character
            if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
              return 'Password must contain at least one special character';
            }
            
            return null;
          },
        ),
        const SizedBox(height: 8),
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     color: AppColors.veryLightGrey,
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border.all(color: AppColors.lightGrey),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       // const Text(
        //       //   'Password Requirements:',
        //       //   style: TextStyle(
        //       //     fontSize: 12,
        //       //     fontWeight: FontWeight.w600,
        //       //     color: AppColors.primaryTextColor,
        //       //   ),
        //       // ),
        //       // const SizedBox(height: 4),
        //       // _buildRequirement('At least 6 characters', controller.text.length >= 6),
        //       // _buildRequirement('One uppercase letter', RegExp(r'[A-Z]').hasMatch(controller.text)),
        //       // _buildRequirement('One lowercase letter', RegExp(r'[a-z]').hasMatch(controller.text)),
        //       // _buildRequirement('One number', RegExp(r'[0-9]').hasMatch(controller.text)),
        //       // _buildRequirement('One special character', RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(controller.text)),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  // Widget _buildRequirement(String text, bool isMet) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 1),
  //     child: Row(
  //       children: [
  //         Icon(
  //           isMet ? Icons.check_circle : Icons.radio_button_unchecked,
  //           size: 14,
  //           color: isMet ? Colors.green : AppColors.mediumGrey,
  //         ),
  //         const SizedBox(width: 6),
  //         Text(
  //           text,
  //           style: TextStyle(
  //             fontSize: 11,
  //             color: isMet ? Colors.green : AppColors.mediumGrey,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}