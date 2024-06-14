import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rkfitness/core/config/app_routes.dart';
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
    {'title': 'Order Shipped', 'subtitle': 'Your order has been shipped.'},
    {'title': 'Payment Successful', 'subtitle': 'Your payment was successful.'},
    {'title': 'New Message', 'subtitle': 'New message from John Doe.'},
    {
      'title': 'Appointment Confirmed',
      'subtitle': 'Your appointment is confirmed.'
    },
    {'title': 'Special Offer', 'subtitle': 'Special offer just for you!'},
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
        title: const Text('Notifications'),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.notifications,
                                        color: Theme.of(context).primaryColor,
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
                                      trailing: const Icon(Icons.arrow_forward_ios),
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

}