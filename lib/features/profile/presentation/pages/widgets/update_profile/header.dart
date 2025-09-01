import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Header section for the update profile page
class UpdateProfileHeader extends StatelessWidget {
  const UpdateProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.edit, size: 48, color: AppColors.primaryBlack),
        SizedBox(height: 16),
        Text(
          'Update Your Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Edit your name and email address',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}