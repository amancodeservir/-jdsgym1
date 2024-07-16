import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/pages/UserProfileScreen.dart';
import 'package:rkfitness/presentation/pages/extent_due_date.dart';
import 'package:share_plus/share_plus.dart';

class AdminHomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (userController.staffAndMembers.value == null ||
            userController.staffAndMembers.value!.isEmpty) {
          return const Center(child: Text('No staff or members found'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: userController.staffAndMembers.value!.length,
            itemBuilder: (context, index) {
              final user = userController.staffAndMembers.value![index];
              return GestureDetector(
                onTap: () {
                  userController.selectUser(user);
                  Get.to(() => UserProfileScreen());
                },
                child: StaffMemberCard(
                  user: user,
                  onAccept: () =>
                      Get.to(() => ExtendDueDateScreen(userId: user.userId)),
                  onReject: () => userController.updateUserStatus(
                      user.userId, 'Rejected', DateTime.now(), context),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

class StaffMemberCard extends StatelessWidget {
  final UserData user;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const StaffMemberCard({
    required this.user,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

     return Container(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 80, top: 8, bottom: 8, right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 1),
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
                              AppStyle.heading2Black),
                          _buildInfoSection(Icons.email, 'Email', user.email,
                              AppStyle.subTitle),
                          _buildInfoSection(
                              Icons.calendar_today,
                              'Due Date',
                              _formatTimestamp(user.dueDate),
                              TextStyle(
                                fontSize: 16,
                                color: user.dueDate.seconds <
                                        Timestamp.now().seconds
                                    ? AppColors.redColor
                                    : Colors.grey[700],
                              )),
                          _buildInfoSection(
                              Icons.info,
                              'Status',
                              user.status,
                              TextStyle(
                                color: user.status == 'Accepted'
                                    ? AppColors.greenColor
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
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
                                ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.date_range,
                                    size: 11,
                                  ), // Add an appropriate icon here
                                  label: const Text(
                                    'Extend Due',
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
                                        'Reminder',
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
                          const SizedBox(height: 24.0),
                          if (user.status == 'Pending')
                            Obx(() {
                              final isLoading = userController.isLoading.value;
                              return isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Row(
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
                                        const SizedBox(width: 8.0),
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
                                    );
                            })
                          else
                            Container()
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
                user!.profilePicture, user.name, context),
            left: 8,
            top: 20,
          ),
          Positioned(
            right: 0,
            top: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: AppColors.primaryColor,
              ),
              child: Text(user.role, style: AppStyle.whiteText11),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      IconData icon, String title, String value, TextStyle textStyle) {
    return Row(
      children: [
        if(title!='Name')
        Icon(icon, color: AppColors.primaryColor,size: 18,),
         if(title!='Name')
        const SizedBox(width: 8),
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
      String profilePicture, String userName, BuildContext context) {
    if (profilePicture.isNotEmpty) {
      return Center(
        child: CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(profilePicture),
        ),
      );
    } else {
      // Display user's first initial on a red background circle
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

  Widget _buildDueInfoRow(String title, Timestamp value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }

  Widget _buildStatusRow(String title, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
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

Download our app: https://play.google.com/store/apps/details?id=com.codeservir.rkfitness
''';

    Share.share(message);
  }
}
