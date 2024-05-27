import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/presentation/controllers/auth_controller.dart';
import 'package:rkfitness/presentation/view/custom_button.dart';
import 'package:rkfitness/presentation/view/custom_circle_button.dart';
import 'package:rkfitness/presentation/view/custom_devider.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/logo.png', height: 150),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
                text: 'Sign In',
                onPressed: () {
                  Get.offNamed(AppRoutes.LOGIN);
                }),
            const SizedBox(height: 10),
            CustomButton(
                text: 'Sign Up ',
                onPressed: () {
                  Get.offNamed(AppRoutes.SIGNUPOPTION);
                }),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomDivider(),
                const Text(
                  'OR',
                  style: AppStyle.body,
                ),
                CustomDivider(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCircleButton(
                  imageProvider: const AssetImage("assets/facebook.png"),
                  onPressed: () {
                   
                  },
                ),
                const SizedBox(
                  width: 32,
                ),
                CustomCircleButton(
                  imageProvider: const AssetImage("assets/google.png"),
                  onPressed: () {
                      Get.find<AuthController>().signInWithGoogle();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
