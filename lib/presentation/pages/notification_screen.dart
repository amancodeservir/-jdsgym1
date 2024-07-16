import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/snackbar_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/view/custom_button.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ToastController toastController = ToastController();
  final UserController userController = Get.find<UserController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _image;
  String? profileImageUrl;
  GlobalKey key = GlobalKey();

  // Dummy notification list
  List<Map<String, String>> _notifications = [
    {'title': 'Order Shipped', 
    'subtitle': 'Your order has been shipped.',
    'sender':'Raman'
    },
    {'title': 'Payment Successful', 'subtitle': 'Your payment was successful.',
    'sender':'Raman'},
    {'title': 'New Message', 'subtitle': 'New message from John Doe.',
    'sender':'Dinesh'},
    {
      'title': 'Appointment Confirmed',
      'subtitle': 'Your appointment is confirmed.',
    'sender':'Sharma'
    },
    {'title': 'Special Offer', 'subtitle': 'Special offer just for you!',
    'sender':'Abhishek'},
  ];

  void _handleBackPress() {
    String role = userController.getUserRole();

    switch (role) {
      case 'member':
        Get.offNamed(AppRoutes.MEMBERDASHBOARD);
        break;
      case 'staff':
        Get.offNamed(AppRoutes.STAFFDASHBOARD);
        break;
      case 'admin':
        Get.offNamed(AppRoutes.ADMINDASHBOARD);
        break;

      default:
        Navigator.pop(context);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = userController.userData.value?.name ?? '';
    profileImageUrl = userController.userData.value?.profilePicture ?? '';
    _mobileNumberController.text =
        userController.userData.value?.mobileNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: AppStyle.whiteText18,
        ),
        leading: BackButton(
          color: Colors.white,
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
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: _notifications.isNotEmpty
                          ? ListView.builder(
                              itemCount: _notifications.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        width: 48,
                                        height: 48,
                                        child: _buildAvatar('',  _notifications[index]['sender']!, context),
                                      ),
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _notifications[index]['title']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                          _notifications[index]['subtitle']!),
                                      onTap: () {
                                        // Handle notification tap
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No notifications available',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildAvatar(
      String profilePicture, String userName, BuildContext context) {
    if (_image != null && _image is File) {
      return CircleAvatar(
        radius: 74,
        backgroundImage: FileImage(_image as File),
      );
    } else if (profilePicture.isNotEmpty) {
      return CircleAvatar(
        radius: 74,
        backgroundImage: NetworkImage(profilePicture),
      );
    } else {
      // Display user's first initial on a red background circle
      String initial = userName.isNotEmpty ? userName[0].toUpperCase() : '';
      return CircleAvatar(
        radius: 74,
        backgroundColor: AppColors.primaryColor,
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
