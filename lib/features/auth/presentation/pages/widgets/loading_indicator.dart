import 'package:alpha_agency/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Loading indicator widget
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlack),
      ),
    );
  }
}