import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/pages/extent_due_date.dart';
import 'package:share_plus/share_plus.dart';

class UserProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final user = userController.selectedUser.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: AppStyle.whiteText18,
          
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.userData.value == null) {
              return const Center(child: Text('User data not available',style: TextStyle(  fontFamily: 'Nexa',fontSize: 14),));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatarAndEditButton(user!.profilePicture,user.name, context),
                      const SizedBox(height: 16.0),
                      _buildSection(Icons.person, 'Name', user.name),
                      _buildSection(Icons.email, 'Email', user.email),
                      _buildSection(Icons.person, 'Role', user.role),
                      _buildSection3(Icons.info, 'Status', user.status),
                      _buildSection2(
                          Icons.payment, 'Payment Due', user.dueDate),
                      if (user.dueDate.compareTo(Timestamp.now()) < 0 &&
                          user.status == 'Accepted')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              icon: const Icon(Icons
                                  .date_range), // Add an appropriate icon here
                              label: const Text(
                                'Extend Due Date',
                                style: AppStyle.whiteText11,
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () => Get.to(() =>
                                  ExtendDueDateScreen(userId: user.userId)),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () => sendReminder(
                                user.name,
                                _formatTimestamp(user.dueDate),
                                user.mobileNumber,
                                user.email,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Send Reminder',
                                    style: AppStyle.whiteText11,
                                  ),
                                  SizedBox(
                                      width:
                                          8.0), // Adjust the space between text and icon
                                  Icon(Icons.send),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24.0),
                      if (user.status == 'Pending' || user.status == 'Rejected')
                        Obx(() {
                          final isLoading = userController.isLoading.value;
                          return isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.check),
                                      label: const Text('Accept',style: TextStyle(fontFamily: 'Nexa',fontSize: 14,fontWeight: FontWeight.bold),),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () => Get.to(() =>
                                          ExtendDueDateScreen(
                                              userId: user.userId)),
                                    ),
                                    const SizedBox(width: 16.0),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.close),
                                      label: const Text('Decline',style: TextStyle(fontFamily: 'Nexa',fontSize: 14,fontWeight: FontWeight.bold),),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () =>
                                          userController.updateUserStatus(
                                              user.userId,
                                              'Rejected',
                                              DateTime.now(),
                                              context),
                                    ),
                                  ],
                                );
                        })
                      else
                        Container()
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


  Widget _buildAvatarAndEditButton(String profilePicture, String userName, BuildContext context ) {
    if (profilePicture.isNotEmpty) {
      return Center(
        child: CircleAvatar(
          radius: 64,
          backgroundImage: NetworkImage(profilePicture),
        ),
      );
    } else {
      // Display user's first initial on a red background circle
      String initial = userName.isNotEmpty ? userName[0].toUpperCase() : '';
      return Center(
        child: CircleAvatar(
          radius: 64,
          backgroundColor: AppColors.primaryColor,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
                fontFamily: 'Nexa',
            ),
          ),
        ),
      );
    }
  }


  Widget _buildSection2(IconData icon, String title, Timestamp value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,  fontFamily: 'Nexa',),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _formatTimestamp(value),
          style: TextStyle(
            fontSize: 16,
            color: value.seconds < Timestamp.now().seconds
                ? AppColors.redColor
                : Colors.grey[700],
                  fontFamily: 'Nexa',
          ),
        ),
        Divider(height: 30, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildSection3(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,  fontFamily: 'Nexa',),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              color: value == 'Pending'
                  ? AppColors.redColor
                  : AppColors.primaryColor,
                    fontFamily: 'Nexa',),
        ),
        Divider(height: 30, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildSection(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,  fontFamily: 'Nexa',),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.grey,  fontFamily: 'Nexa',),
        ),
        Divider(height: 30, color: Colors.grey[400]),
      ],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
  }

  void sendReminder(
      String userName, String dueDate, String mobileNumber, String email) {
    String message = '''
*Dear $userName*,

Your due date is: $dueDate.

Please pay your fee to extend your subscription.

Download our app: https://play.google.com/store/apps/details?id=com.codeservir.rkfitness
''';

    Share.share(message);
  }
}
