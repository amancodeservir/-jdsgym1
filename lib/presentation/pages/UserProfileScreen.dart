import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
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
        title: const Text('User Profile'),
      ),
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.userData.value == null) {
              return const Center(child: Text('User data not available'));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user!.profilePicture != null &&
                                  user.profilePicture.isNotEmpty
                              ? NetworkImage(user.profilePicture!)
                              : const AssetImage(
                                      'assets/images/default_avatar.png')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          user!.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text(
                          'Role',
                          style: AppStyle.heading2Black,
                        ),
                        subtitle: Text(
                          user.role,
                          style: AppStyle.body,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text(
                          'Email',
                          style: AppStyle.heading2Black,
                        ),
                        subtitle: Text(
                          user.email,
                          style: AppStyle.body,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text(
                          'Status',
                          style: AppStyle.heading2Black,
                        ),
                        subtitle: Text(
                          user.status,
                          style: AppStyle.body,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text(
                          'Due Date',
                          style: AppStyle.heading2Black,
                        ),
                        subtitle: Text(
                          _formatTimestamp(user.dueDate),
                          style: user.dueDate.compareTo(Timestamp.now()) < 0
                              ? AppStyle.redStyle
                              : AppStyle.body,
                        ),
                      ),
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
                                      label: const Text('Accept'),
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
                                      label: const Text('Decline'),
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
