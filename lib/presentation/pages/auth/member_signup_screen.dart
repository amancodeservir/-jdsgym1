import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/auth_controller.dart';
import 'package:rkfitness/presentation/pages/term_and_condition.dart';
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

  bool _isAgreed = false; // Track agreement status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 64),
                    Image.asset(
                      'assets/blacklogo.png', // Adjust this path according to your logo asset
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
                    CheckboxListTile(
                      title: Container(
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: RichText(
                                  text: TextSpan(
                                text:
                                    'I have read, understood, and agree to all the ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TermsAndConditions(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              )))),
                      value: _isAgreed,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAgreed = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (!_isAgreed) // Show validation message if not agreed
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'You must agree to the terms and conditions.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (!_isAgreed) {
                            // Show a snackbar or validation message if not agreed
                            Get.snackbar(
                              'Agreement Required',
                              'You must agree to the terms and conditions.',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          authController.register(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _mobileController.text.trim(),
                            _passwordController.text.trim(),
                            'member',
                            context,
                          );
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
