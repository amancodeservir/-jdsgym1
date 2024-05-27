import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';

class ToastController extends GetxController {
  void showSuccessSnackbar(String titleMessage, String successMessage) {
    Get.snackbar(
      titleMessage,
      successMessage,
      backgroundColor:AppColors.primaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showErrorSnackbar(String titleMessage, String errorMessage) {
    Get.snackbar(
      titleMessage,
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
