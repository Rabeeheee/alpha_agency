import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// App bar for the update profile page
class UpdateProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UpdateProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Update Profile',
        style: TextStyle(
          color: AppColors.primaryWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.primaryBlack,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryWhite),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}