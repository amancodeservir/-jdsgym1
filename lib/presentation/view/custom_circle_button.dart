import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';

class CustomCircleButton extends StatelessWidget {
  final ImageProvider imageProvider;
  final VoidCallback onPressed;

  const CustomCircleButton({
    super.key,
    required this.imageProvider,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightGrey,
            border: Border.all(width: 2, color: AppColors.lightGrey)),
        child: Center(
          child: Image(
            image: imageProvider,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
