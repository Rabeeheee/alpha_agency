import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final dynamic profile;

  const ProfileCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.primaryBlack,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ProfileDetail(label: 'Name', value: profile.name),
            const SizedBox(height: 16),
            ProfileDetail(label: 'Email', value: profile.email),
            const SizedBox(height: 16),
            ProfileDetail(label: 'Mobile', value: profile.mobile),
          ],
        ),
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetail({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : 'Not provided',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}