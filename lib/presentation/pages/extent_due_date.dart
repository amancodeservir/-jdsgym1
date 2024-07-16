import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class ExtendDueDateScreen extends StatefulWidget {
  final String userId;

  ExtendDueDateScreen({required this.userId});

  @override
  _ExtendDueDateScreenState createState() => _ExtendDueDateScreenState();
}

class _ExtendDueDateScreenState extends State<ExtendDueDateScreen> {
  final UserController userController = Get.find<UserController>();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Extend Due Date',
          style: AppStyle.whiteText18,
        ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select New Due Date',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Theme(
                          // Wrap CalendarDatePicker with Theme to customize for light/dark mode
                          data: Theme.of(context).copyWith(
                            // Customize colors for light mode
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  primary:
                                      AppColors.primaryColor, // Primary color
                                  onPrimary:
                                      Colors.white, // Text color on primary
                                  surface: Colors.white, // Background color
                                  onSurface:
                                      Colors.black87, // Text color on surface
                                ),
                            // Customize colors for dark mode
                            brightness: Theme.of(context).brightness,
                          ),
                          child: CalendarDatePicker(
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2101),
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () async {
                            final progress = ProgressHUD.of(context);
                            progress?.show();

                            await userController.updateUserStatus(
                              widget.userId,
                              "Accepted",
                              _selectedDate,
                              context,
                            );

                            progress?.dismiss();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Due date extended successfully!',
                                ),
                                backgroundColor: AppColors.primaryColor,
                              ),
                            );
                          },
                          child: Text(
                            'Extend Due Date ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
}
