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
import 'package:share_plus/share_plus.dart';

class StaffMembersScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.black : const Color.fromRGBO(220, 218, 218, 0.384);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (userController.staffAndMembers.value == null ||
                userController.staffAndMembers.value!.isEmpty) {
              return Center(
                child: Text(
                  'No members found',
                  style: TextStyle(color: textColor),
                ),
              );
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
                      isDarkMode: isDarkMode,
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
  final bool isDarkMode;

  const MemberCard({
    required this.user,
    required this.sendRemainder,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.white;
    final shadowColor = isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.1);

    return Container(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 80, top: 8, bottom: 8, right: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: borderColor!),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection(Icons.person, 'Name', user.name,
                              AppStyle.heading2Black.copyWith(color: textColor)),
                          _buildInfoSection(Icons.email, 'Email', user.email,
                              AppStyle.subTitle.copyWith(color: textColor)),
                          _buildInfoSection(
                              Icons.calendar_today,
                              'Due Date',
                              _formatTimestamp(user.dueDate),
                              TextStyle(
                                fontSize: 16,
                                color: user.dueDate.seconds <
                                        Timestamp.now().seconds
                                    ? AppColors.redColor
                                    : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                              )),
                          _buildInfoSection(
                              Icons.done,
                              'Subscription ',
                              '${user.dueDate.seconds < Timestamp.now().seconds ? 'Expired' : 'Active'}',
                              TextStyle(
                                fontSize: 16,
                                color: user.dueDate.seconds <
                                        Timestamp.now().seconds
                                    ? AppColors.redColor
                                    : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.dueDate.compareTo(Timestamp.now()) < 0 &&
                              user.status == 'Accepted')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                      Icon(
                                        Icons.send,
                                        size: 11,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            child: _buildAvatarAndEditButton(
                user.profilePicture, user.name, context, isDarkMode),
            left: 8,
            top: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      IconData icon, String title, String value, TextStyle textStyle) {
    return Row(
      children: [
        if (title != 'Name')
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 18,
          ),
        if (title != 'Name') const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Text(
              value,
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarAndEditButton(
      String profilePicture, String userName, BuildContext context, bool isDarkMode) {
    if (profilePicture.isNotEmpty) {
      return Center(
        child: CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(profilePicture),
        ),
      );
    } else {
      // Display user's first initial on a background circle
      String initial = userName.isNotEmpty ? userName[0].toUpperCase() : '';
      return Center(
        child: CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primaryColor,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH').format(dateTime);
  }

  void sendReminder(
      String userName, String dueDate, String mobileNumber, String email) {
    String message = '''
*Dear $userName*,

Your due date is: $dueDate.

Please pay your fee to extend your subscription.

Download our app: https://play.google.com/store/apps/details?id=com.dfimo.jdsgym
''';

    Share.share(message);
  }
}
