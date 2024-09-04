import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      backgroundColor: AppColors.primaryColor,
      color: AppColors.white,
    );
  }
}
