import 'package:alpha_agency/features/profile/presentation/pages/widgets/update_profile/appbar.dart';
import 'package:alpha_agency/features/profile/presentation/pages/widgets/update_profile/header.dart';
import 'package:alpha_agency/features/profile/presentation/pages/widgets/update_profile/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/update_profile_request.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';


/// Page for updating user profile information
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
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Pre-fills form fields with current profile data
  void _loadCurrentProfile() {
    final state = context.read<ProfileBloc>().state;
    
    if (state is ProfileLoaded) {
      _nameController.text = state.profile.name;
      _emailController.text = state.profile.email;
    } else if (state is ProfileUpdateSuccess) {
      _nameController.text = state.profile.name;
      _emailController.text = state.profile.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      //APP BAR
      appBar: const UpdateProfileAppBar(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //HEADER
                    const UpdateProfileHeader(),
                    const SizedBox(height: 32),
                    //FORM
                    ProfileForm(
                      nameController: _nameController,
                      emailController: _emailController,
                      isLoading: state is ProfileLoading,
                      onUpdate: _handleUpdate,
                    ),
                    if (state is ProfileLoading) 
                      const SizedBox(height: 32),
                    if (state is ProfileLoading) 
                      _buildLoadingIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Handles state changes from ProfileBloc
  void _handleStateChanges(BuildContext context, ProfileState state) {
    if (state is ProfileUpdateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.successColor,
        ),
      );
      
      // Reload profile to ensure UI reflects server data
      context.read<ProfileBloc>().add(LoadUserProfileEvent());
      
      // Navigate back with success indicator after a brief delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } else if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  /// Validates form and triggers profile update
  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      
      final request = UpdateProfileRequest(name: name, email: email);
      context.read<ProfileBloc>().add(UpdateUserProfileEvent(request));
    }
  }

  /// Displays loading indicator during profile update
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
}