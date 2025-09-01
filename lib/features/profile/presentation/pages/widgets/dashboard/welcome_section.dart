import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  final String name;

  const WelcomeSection({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back,',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.lightGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name.isNotEmpty ? name : 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryWhite,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Have a great day!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}