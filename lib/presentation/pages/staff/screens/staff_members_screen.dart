import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/pages/UserProfileScreen.dart';

class StaffMembersScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_color,
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (userController.staffAndMembers.value == null ||
                userController.staffAndMembers.value!.isEmpty) {
              return const Center(child: Text('No members found'));
            } else {
              final members = userController.staffAndMembers.value!
                  .where((user) =>
                      user.role == 'member' && user.status == 'Accepted')
                  .toList();

              print("Filtered Members: $members");
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final user = members[index];
                  return GestureDetector(
                    onTap: () {
                      userController.selectUser(user);
                      Get.to(() => UserProfileScreen());
                    },
                    child: MemberCard(
                      user: user,
                      sendRemainder: () => userController.sendReminder(
                          user.userId, user.dueDate, "reminder", context),
                    ),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final UserData user;
  final VoidCallback sendRemainder;

  const MemberCard({
    required this.user,
    required this.sendRemainder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.profilePicture != null &&
                        user.profilePicture!.isNotEmpty
                    ? NetworkImage(user.profilePicture!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppStyle.heading2Black),
                    const SizedBox(height: 4.0),
                    Text(user.email, style: AppStyle.subTitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text('Status: ${user.status}', style: AppStyle.heading3Black),
          const SizedBox(height: 8.0),
          Text(
              'Subcription: ${user.dueDate.seconds < Timestamp.now().seconds ? 'Expaired' : 'Active'}',
              style: AppStyle.heading3Black),
          _buildDueInfoRow('Payment due:', user.dueDate),
          const SizedBox(height: 4.0),
          if (user.dueDate.seconds < Timestamp.now().seconds)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  label: const Text(
                    'Send Remainder',
                    style: AppStyle.whiteText11,
                  ),
                  icon: const Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  onPressed: sendRemainder,
                ),
              ],
            )
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
}
