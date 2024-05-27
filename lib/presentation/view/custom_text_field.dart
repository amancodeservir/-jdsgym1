import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String placeholder;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Color? focusedBorderColor; // New property for focused border color

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.placeholder,
    required this.prefixIcon,
    this.controller,
    this.obscureText = false,
    required this.keyboardType,
    this.validator,
    this.focusedBorderColor, // Initialize the new property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: AppColors.lightGrey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: AppColors.darkGrey,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: AppColors.lightGrey,
            width: 1.0,
          ),
        ),
        filled: true,
        hintText: placeholder,
        hintStyle: const TextStyle(color: AppColors.lightGrey),
        fillColor: AppColors.white,
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }
}
