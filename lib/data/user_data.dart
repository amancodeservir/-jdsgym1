import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final String name;
  final String email;
  final String mobileNumber;
  final String role;
  final String profilePicture;
  final String address;
  final String dob;
  final Timestamp dueDate;
  final String status;

  UserData({
    required this.userId,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.role,
    required this.profilePicture,
    required this.address,
    required this.dob,
    required this.dueDate,
    required this.status,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      role: json['role'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      dueDate: json['dueDate'] ?? Timestamp.now(),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role,
      'profilePicture': profilePicture,
      'address': address,
      'dob': dob,
      'dueDate': dueDate,
      'status': status,
    };
  }
}
