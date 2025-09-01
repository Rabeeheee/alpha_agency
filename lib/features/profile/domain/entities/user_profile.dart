import 'package:equatable/equatable.dart';

/// User profile entity
class UserProfile extends Equatable {
  final String name;
  final String email;
  final String mobile;
  
  const UserProfile({
    required this.name,
    required this.email,
    required this.mobile,
  });
  
  @override
  List<Object> get props => [name, email, mobile];
}