import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/snackbar_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/view/custom_button.dart';
import 'package:rkfitness/presentation/view/custom_text_field.dart';

class FeedbackScreen extends StatelessWidget {
  ToastController toastController = ToastController();
  final UserController userController = Get.find<UserController>();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Feedback',
          style: TextStyle(color: Colors.white), // Adjust the color as needed
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white, // Adjust the color as needed
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Adjust the color as needed
      ),
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.userData.value == null) {
              return const Center(child: Text('User data not available'));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        labelText: 'Full Name',
                        prefixIcon: Icons.person,
                        placeholder: 'Enter your full name',
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        placeholder: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'Phone Number',
                        prefixIcon: Icons.phone,
                        placeholder: 'Enter your phone number',
                        controller: _mobileController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        maxLength: 10,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _feedbackController,
                        decoration: InputDecoration(
                            hintText: 'Message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: AppColors.lightGrey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: AppColors.darkGrey,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            hintStyle: AppStyle.placeholderStyle,
                            fillColor: AppColors.inputFillColor,
                            counterText: ''),
                        maxLines: 8,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        onPressed: () => _sendFeedback(context),
                        text: 'Send',
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  void _sendFeedback(BuildContext context) async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _mobileController.text.trim();
    final String feedback = _feedbackController.text.trim();

    final progress = ProgressHUD.of(context);
    if (feedback.isNotEmpty) {
      try {
        progress?.show();
        await userController.saveFeedback(
          name: name,
          email: email,
          phone: phone,
          feedback: feedback,
          userId: userController.userData.value!.userId ?? '',
        );
        Get.back();
        toastController.showSuccessSnackbar(
            'Success!', 'Feedback sent successfully');
      } catch (e) {
        print('Error sending feedback: $e');
        toastController.showErrorSnackbar('Error', 'Failed to send feedback');
        progress?.dismiss();
      }
    } else {
      Get.snackbar('Error', 'Feedback cannot be empty');
    }
  }
}
