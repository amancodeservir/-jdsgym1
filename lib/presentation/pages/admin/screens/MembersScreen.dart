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
import 'package:rkfitness/presentation/pages/extent_due_date.dart';
import 'package:share_plus/share_plus.dart';

class MembersScreen extends StatelessWidget {
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
                  .where((user) => user.role == 'member')
                  .toList();
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
                      onAccept: () => Get.to(
                          () => ExtendDueDateScreen(userId: user.userId)),
                      onReject: () => userController.updateUserStatus(
                          user.userId, 'Rejected', DateTime.now(), context),
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
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const MemberCard({
    required this.user,
    required this.onAccept,
    required this.onReject,
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
        
          _buildDueInfoRow('Payment due ', user.dueDate),
            Text('Status: ${user.status}', style: AppStyle.heading3Black),
            const SizedBox(height: 8.0),
          if (user.dueDate.compareTo(Timestamp.now()) < 0 &&
              user.status == 'Accepted')
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.date_range,
                    size: 11,
                  ), // Add an appropriate icon here
                  label: const Text(
                    'Extend Due Date',
                    style: AppStyle.whiteText11,
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () =>
                      Get.to(() => ExtendDueDateScreen(userId: user.userId)),
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
                          width: 8.0), // Adjust the space between text and icon
                      Icon(
                        Icons.send,
                        size: 11,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  onPressed: onAccept,
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
                  onPressed: onReject,
                ),
              ],
            )
          else
          Container()
        ],
      ),
    );
  }

  Widget _buildDueInfoRow(String title, Timestamp value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
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
