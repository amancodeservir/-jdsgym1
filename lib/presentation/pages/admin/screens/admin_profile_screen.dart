import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/controllers/ThemeController.dart';
import 'package:rkfitness/presentation/controllers/auth_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class AdminProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.userData.value == null) {
              return const Center(child: Text('User data not available',style: AppStyle.body,));
            } else {
              UserData? userData = userController.userData.value;
              return SingleChildScrollView(
                child: _buildProfile(userData, context),
              );
            }
          }),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    final progress = ProgressHUD.of(context);
    progress?.show();
    Future.delayed(const Duration(seconds: 2), () {
      authController.signOut();
      progress?.dismiss();
    });
  }

  Widget _buildProfile(UserData? userData, BuildContext context) {
    if (userData == null) {
      return const Center(child: Text('User data not available',style: AppStyle.body,));
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatarAndEditButton(userData.profilePicture, userData.name,context),
            _buildSection(Icons.person, 'Name', userData.name),
            _buildSection(Icons.email, 'Email', userData.email),
            // _buildSection(Icons.calendar_today, 'Date of Birth', userData.dob),
            _buildSection(Icons.phone, 'Phone Number', userData.mobileNumber),
            _buildSection(Icons.location_on, 'Address', userData.address),
            // _buildSection2(Icons.payment, 'Payment Due', userData.dueDate),
            // _buildSection3(Icons.account_balance_wallet, 'Account Status',
            //     userData.status),

            _buildSwitchTile(
              context: context,
              title: 'Dark Mode',
              icon: Icons.brightness_6,
              value: themeController.isDarkMode,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            ),
            const Divider(height: 30, color: Colors.grey),
            // _buildFeedbackButton(context),

            _buildLogoutButton(context),
          ],
        ),
      );
    }
  }

    Widget _buildAvatar(String profilePicture, String userName, BuildContext context ) {
    if (profilePicture.isNotEmpty) {
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


  Widget _buildAvatarAndEditButton(
      String profilePicture, String userName ,BuildContext context) {
         String initial = userName.isNotEmpty ? userName[0].toUpperCase() : '';
    return Center(
      child: Stack(
        children: [
          _buildAvatar(profilePicture,userName,context),
          // CircleAvatar(
          //   radius: 74,
          //   backgroundImage: profilePicture.isNotEmpty
          //       ? NetworkImage(profilePicture)
          //       : const AssetImage('assets/default_avatar.png')
          //           as ImageProvider,
          // ),
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.EDITPROFILE);
              },
              child: Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 26.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.lightGrey, width: 0.5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.primaryColor
                            : Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryColor
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        Container(
          padding: EdgeInsets.only(left: 32),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.grey,  fontFamily: 'Nexa',),
          ),
        ),
        Divider(height: 30, color: Colors.grey[400]),
      ],
    );
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

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  : AppColors.primaryColor,  fontFamily: 'Nexa',),
        ),
        Divider(height: 30, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(AppRoutes.FEEDBACK);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.feedback, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Send Feedback",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                  fontFamily: 'Nexa',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,  fontFamily: 'Nexa',)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final progress = ProgressHUD.of(context);
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          progress?.show();
          Future.delayed(const Duration(seconds: 2), () {
            authController.signOut();
            progress?.dismiss();
          });
        },
        icon: const Icon(Icons.logout, size: 28, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, color: Colors.white,  fontFamily: 'Nexa',),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
