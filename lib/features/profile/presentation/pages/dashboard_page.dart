import 'package:alpha_agency/features/profile/presentation/pages/widgets/dashboard/action_section.dart';
import 'package:alpha_agency/features/profile/presentation/pages/widgets/dashboard/dashboard_appbar.dart';
import 'package:alpha_agency/features/profile/presentation/pages/widgets/dashboard/error_contents.dart';
import 'package:alpha_agency/features/profile/presentation/pages/widgets/dashboard/profile_card.dart';
import 'package:alpha_agency/features/profile/presentation/pages/widgets/dashboard/welcome_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

import 'update_profile_page.dart';

/// Dashboard page widget
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      //APP BAR
      appBar: DashboardAppBar(onLogout: _handleLogout),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: AppColors.successColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlack),
              ),
            );
          } else if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
            final profile = state is ProfileLoaded 
                ? state.profile 
                : (state as ProfileUpdateSuccess).profile;
            return _buildDashboardContent(profile);
          } else if (state is ProfileError) {
            //ERROR HANDLE
            return ErrorContent(
              message: state.message,
              onRetry: _refreshProfile,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboardContent(profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //WELCOME SECTION
          WelcomeSection(name: profile.name),
          const SizedBox(height: 32),
          //PROFILE CARD
          ProfileCard(profile: profile),
          const SizedBox(height: 32),
          //UPDATE AND REFRESH BUTTONS
          ActionsSection(
            onUpdateProfile: _navigateToUpdateProfile,
            onRefresh: _refreshProfile,
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryWhite,
        title: const Text(
          'Logout',
          style: TextStyle(color: AppColors.primaryTextColor),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mediumGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.primaryBlack),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUpdateProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UpdateProfilePage()),
    );
    
    if (result == true) {
      _refreshProfile();
    }
  }

  void _refreshProfile() {
    context.read<ProfileBloc>().add(LoadUserProfileEvent());
  }
}