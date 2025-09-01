import 'package:equatable/equatable.dart';

/// Update profile request entity
class UpdateProfileRequest extends Equatable {
  final String name;
  final String email;
  
  const UpdateProfileRequest({
    required this.name,
    required this.email,
  });
  
  @override
  List<Object> get props => [name, email];
}