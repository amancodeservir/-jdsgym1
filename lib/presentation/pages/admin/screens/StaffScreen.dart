import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/data/user_data.dart';

class StaffScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bg_color,
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (userController.staffAndMembers.value == null ||
            userController.staffAndMembers.value!.isEmpty) {
          return const Center(child: Text('No staff found'));
        } else {
          final staffMembers = userController.staffAndMembers.value!
              .where((user) => user.role == 'staff')
              .toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: staffMembers.length,
            itemBuilder: (context, index) {
              final user = staffMembers[index];
              return StaffCard(user: user, userController: userController);
            },
          );
        }
      }),
    );
  }
}

class StaffCard extends StatelessWidget {
  final UserData user;
  final UserController userController;

  const StaffCard({required this.user, required this.userController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                 CircleAvatar(
                radius: 30,
                backgroundImage: user.profilePicture != null&&user.profilePicture.isNotEmpty
                    ? NetworkImage(user.profilePicture!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: AppStyle.heading2Black),
                      const SizedBox(height: 4.0),
                      Text(user.email,
                          style:AppStyle.subTitle),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text('Status: ${user.status}',
              style: AppStyle.heading3Black),

              _buildDueInfoRow('Payment due ', user.dueDate),
            const SizedBox(height: 4.0),
            if (user.status == 'Pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text(
                      'Accept',
                      style: AppStyle.whiteText11,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => userController.updateUserStatus(
                        user.userId, 'Accepted'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text(
                      'Decline',
                      style: AppStyle.whiteText11,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => userController.updateUserStatus(
                        user.userId, 'Rejected'),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Text(
                    user.status,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color:
                          user.status == 'Accepted' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
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
              style: AppStyle.heading3Black,
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