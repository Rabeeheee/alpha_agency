import 'package:alpha_agency/features/profile/presentation/pages/widgets/update_profile/custom_textfield.dart';
import 'package:alpha_agency/features/profile/presentation/pages/widgets/update_profile/update_button.dart';
import 'package:flutter/material.dart';


/// Form widget containing profile input fields and update button
class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onUpdate;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.isLoading,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: nameController,
          label: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          validator: _validateName,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailController,
          label: 'Email Address',
          hintText: 'Enter your email address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),
        const SizedBox(height: 32),
        UpdateButton(
          onPressed: isLoading ? null : onUpdate,
          isLoading: isLoading,
        ),
      ],
    );
  }

  /// Validates the name field
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates the email field
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}