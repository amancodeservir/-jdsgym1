import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/snackbar_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/view/custom_button.dart';
import 'package:rkfitness/presentation/view/custom_text_field.dart';

class FeedbackScreen extends StatelessWidget {
  ToastController toastController = ToastController();
  final UserController userController = Get.find<UserController>();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
      ),
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.userData.value == null) {
              return const Center(child: Text('User data not available'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _feedbackController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(
                            color: AppColors.darkGrey,
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        hintText: 'Enter your feedback here...',
                        hintStyle: const TextStyle(color: AppColors.lightGrey),
                        fillColor: AppColors.white,
                      ),
                      maxLines: 8,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: () => _sendFeedback(context),
                      text: 'Send',
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  void _sendFeedback(BuildContext context) async {
    final String feedback = _feedbackController.text.trim();
    final progress = ProgressHUD.of(context);
    if (feedback.isNotEmpty) {
      try {
        progress?.show();
        await userController.saveFeedback(
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
