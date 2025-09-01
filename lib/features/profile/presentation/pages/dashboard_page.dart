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
    // Load user profile on page initialization
    context.read<ProfileBloc>().add(LoadUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
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
            return _buildErrorContent(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Dashboard',
        style: TextStyle(
          color: AppColors.primaryWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.primaryBlack,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.primaryWhite),
          onPressed: _handleLogout,
          tooltip: 'Logout',
        ),
      ],
    );
  }

  /// Build main dashboard content
  Widget _buildDashboardContent(profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Section
          _buildWelcomeSection(profile.name),
          const SizedBox(height: 32),
          
          // Profile Card
          _buildProfileCard(profile),
          const SizedBox(height: 32),
          
          // Actions Section
          _buildActionsSection(),
        ],
      ),
    );
  }

  /// Build welcome section
  Widget _buildWelcomeSection(String name) {
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

  /// Build profile information card
  Widget _buildProfileCard(profile) {
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
            
            // Profile Details
            _buildProfileDetail('Name', profile.name),
            const SizedBox(height: 16),
            _buildProfileDetail('Email', profile.email),
            const SizedBox(height: 16),
            _buildProfileDetail('Mobile', profile.mobile),
          ],
        ),
      ),
    );
  }

  /// Build individual profile detail row
  Widget _buildProfileDetail(String label, String value) {
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

  /// Build actions section
  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        
        // Update Profile Button
        _buildActionButton(
          icon: Icons.edit,
          title: 'Update Profile',
          subtitle: 'Edit your name and email',
          onTap: _navigateToUpdateProfile,
        ),
        const SizedBox(height: 12),
        
        // Refresh Button
        _buildActionButton(
          icon: Icons.refresh,
          title: 'Refresh Profile',
          subtitle: 'Reload your profile information',
          onTap: _refreshProfile,
        ),
      ],
    );
  }

  /// Build action button widget
  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: AppColors.primaryWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.lightGrey, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.veryLightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryBlack,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.mediumGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build error content
  Widget _buildErrorContent(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.mediumGrey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlack,
                foregroundColor: AppColors.primaryWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle logout action
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

  /// Navigate to update profile page
  void _navigateToUpdateProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UpdateProfilePage()),
    );
    
    // Refresh profile if update was successful
    if (result == true) {
      _refreshProfile();
    }
  }

  /// Refresh profile data
  void _refreshProfile() {
    context.read<ProfileBloc>().add(LoadUserProfileEvent());
  }
}