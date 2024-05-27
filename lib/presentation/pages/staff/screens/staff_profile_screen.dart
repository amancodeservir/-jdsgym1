import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/controllers/auth_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class StaffProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.userData.value == null) {
              return const Center(child: Text('User data not available'));
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

  Widget _buildProfile(UserData? userData, BuildContext context) {
    if (userData == null) {
      return const Center(child: Text('User data not available'));
    } else {
      return Stack(
        children: [
          Positioned(
            right: 10,
            top: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CupertinoButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: const Text(
                  "Send feedback",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.FEEDBACK);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarAndEditButton(userData.profilePicture),
                const SizedBox(height: 20),
                _buildUserName(userData.name),
                const SizedBox(height: 8),
                _buildUserEmail(userData.email),
                Divider(height: 40, color: Colors.grey[400]),
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 12),
                _buildProfileInfoRow('Date of Birth', userData.dob),
                _buildProfileInfoRow('Phone Number', userData.mobileNumber),
                _buildProfileInfoRow('Location', userData.address),
                Divider(height: 40, color: Colors.grey[400]),
                _buildSectionTitle('Payment Information'),
                _buildDueInfoRow('Payment due ', userData.dueDate),
                _buildAccountInfoRow('Account ', userData.status),
                Divider(height: 40, color: Colors.grey[400]),
                _buildLogoutRow(context),
                // Add more profile information rows as needed
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildAvatarAndEditButton(String profilePicture) {
    return Stack(
      children: [
        profilePicture.isNotEmpty
            ? CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(profilePicture))
            : const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/facebook.png'),
              ),
        Positioned(
          right: 2,
          bottom: 1,
          child: GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.EDITPROFILE);
            },
            child: Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
                color: AppColors.primaryColor,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.white,
                  size: 16,
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.EDITPROFILE);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserName(String fullName) {
    return Text(
      fullName,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildUserEmail(String email) {
    return Text(
      email,
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProfileInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueInfoRow(String title, Timestamp value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              _formatTimestamp(value),
              style: TextStyle(
                fontSize: 16,
                color: value.seconds < Timestamp.now().seconds
                    ? AppColors.redColor
                    : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
  }

  Widget _buildAccountInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16,
                  color: value == 'pending'
                      ? AppColors.redColor
                      : AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutRow(BuildContext context) {
    final progress = ProgressHUD.of(context);
    return IconButton(
        onPressed: () {
          progress?.show();

          Future.delayed(const Duration(seconds: 2), () {
            authController.signOut();
            progress?.dismiss();
          });
        },
        icon: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.logout,
                  size: 28,
                )),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
            ),
          ],
        ));
  }
}
