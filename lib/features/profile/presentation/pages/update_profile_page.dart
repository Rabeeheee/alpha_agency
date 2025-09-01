import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/update_profile_request.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

/// Update profile page widget
class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill form with current profile data
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Load current profile data to pre-fill the form
  void _loadCurrentProfile() {
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _nameController.text = state.profile.name;
      _emailController.text = state.profile.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: AppColors.successColor,
              ),
            );
            Navigator.of(context).pop(true); // Return true to indicate success
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Name Field
                    _buildNameField(),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildEmailField(),
                    const SizedBox(height: 32),

                    // Update Button
                    _buildUpdateButton(state),

                    const SizedBox(height: 16),

                    // Loading Indicator
                    if (state is ProfileLoading) _buildLoadingIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
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

  /// Build header section
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
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

  /// Build name input field
  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: AppColors.primaryTextColor),
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            hintStyle: const TextStyle(color: AppColors.lightGrey),
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.mediumGrey),
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
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            filled: true,
            fillColor: AppColors.veryLightGrey,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Build email input field
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: AppColors.primaryTextColor),
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            hintStyle: const TextStyle(color: AppColors.lightGrey),
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.mediumGrey),
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
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            filled: true,
            fillColor: AppColors.veryLightGrey,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Build update button
  Widget _buildUpdateButton(ProfileState state) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: state is ProfileLoading ? null : _handleUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlack,
          foregroundColor: AppColors.primaryWhite,
          disabledBackgroundColor: AppColors.mediumGrey,
          disabledForegroundColor: AppColors.lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state is ProfileLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryWhite),
                ),
              )
            else
              const Icon(Icons.save_outlined, size: 20),
            const SizedBox(width: 8),
            Text(
              state is ProfileLoading ? 'Updating...' : 'Update Profile',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlack),
          ),
          SizedBox(height: 16),
          Text(
            'Updating your profile...',
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle update button press
  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      final request = UpdateProfileRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      context.read<ProfileBloc>().add(UpdateUserProfileEvent(request));
    }
  }
}
