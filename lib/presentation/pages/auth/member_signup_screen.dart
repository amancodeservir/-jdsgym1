import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/auth_controller.dart';
import 'package:rkfitness/presentation/view/custom_text_field.dart';
import 'package:rkfitness/presentation/view/custom_button.dart';

class MemberSignupScreen extends StatefulWidget {
  @override
  _MemberSignupScreenState createState() => _MemberSignupScreenState();
}

class _MemberSignupScreenState extends State<MemberSignupScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 64,
                      ),
                      Image.asset(
                        'assets/logo.png', // Adjust this path according to your logo asset
                        height: 100,
                      ),
                      const SizedBox(height: 20),
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
                      CustomTextField(
                        labelText: 'Password',
                        prefixIcon: Icons.lock,
                        placeholder: 'Enter your password',
                        obscureText: true,
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'Confirm Password',
                        prefixIcon: Icons.lock,
                        placeholder: 'Confirm your password',
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Sign Up',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.register(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _mobileController.text.trim(),
                                _passwordController.text.trim(),
                                'member',
                                context);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Get.offNamed(AppRoutes.LOGIN);
                        },
                        child: const Text('Already have an account? Sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
  }
}
