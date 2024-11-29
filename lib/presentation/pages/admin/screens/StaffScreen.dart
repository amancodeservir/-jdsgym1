import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/pages/UserProfileScreen.dart';
import 'package:rkfitness/presentation/pages/extent_due_date.dart';
import 'package:share_plus/share_plus.dart';

class StaffScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                userController.updateSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search staff...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey, // Set the border color here
                    width: 1.0, // Set the border width here
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey, // Set the border color here
                    width: 1.0, // Set the border width here
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        Colors.grey, // Set the border color when focused here
                    width: 1.0, // Set the border width when focused here
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ), // Staff List
          Expanded(
            child: ProgressHUD(
              backgroundColor: Colors.black.withOpacity(0.5),
              indicatorWidget: CustomProgressIndicator(),
              child: Builder(
                builder: (context) => Obx(() {
                  if (userController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userController.staffAndMembers.value == null ||
                      userController.staffAndMembers.value!.isEmpty) {
                    return const Center(
                        child: Text('No staff or members found'));
                  } else {
                    final searchQuery =
                        userController.searchQuery.value.toLowerCase();
                    final staff = userController.staffAndMembers.value!
                        .where((user) => user.role == 'staff')
                        .where((user) =>
                            user.name.toLowerCase().contains(searchQuery))
                        .toList();
                    return ListView.builder(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      itemCount: staff.length,
                      itemBuilder: (context, index) {
                        final user = staff[index];
                        return GestureDetector(
                          onTap: () {
                            userController.selectUser(user);
                            Get.to(() => UserProfileScreen());
                          },
                          child: StaffMemberCard(
                            user: user,
                            onAccept: () => Get.to(
                                () => ExtendDueDateScreen(userId: user.userId)),
                            onReject: () => userController.updateUserStatus(
                                user.userId,
                                'Rejected',
                                DateTime.now(),
                                context),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ),
          ),
        ],
      ),
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
                          SizedBox(
                            height: 4,
                          ),
                          _buildInfoSection(Icons.email, 'Email', user.email,
                              AppStyle.subTitle),
                          SizedBox(
                            height: 4,
                          ),
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
                                fontFamily: 'Nexa',
                              )),
                          SizedBox(
                            height: 4,
                          ),
                          _buildInfoSection(
                              Icons.info,
                              'Status',
                              user.status,
                              TextStyle(
                                color: user.status == 'Accepted'
                                    ? AppColors.greenColor
                                    : AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nexa',
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
                          if (user.status == 'Accepted')
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.date_range,
                                        size: 10,
                                      ),
                                      label: const Text(
                                        'Extend Due',
                                        style: AppStyle.whiteText11,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: AppColors.greenColor,
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
                                            bottom: 8), // Remove padding
                                        minimumSize: Size(0,
                                            0), // Remove minimum size constraints
                                        tapTargetSize: MaterialTapTargetSize
                                            .shrinkWrap, // Reduce tap target size
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8)), // Customize shape if needed
                                      ),
                                      onPressed: () => Get.to(() =>
                                          ExtendDueDateScreen(
                                              userId: user.userId))),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.send,
                                      size: 10,
                                    ),
                                    label: const Text(
                                      'Reminder',
                                      style: AppStyle.whiteText11,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: AppColors.primaryColor,
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8), // Remove padding
                                      minimumSize: Size(0,
                                          0), // Remove minimum size constraints
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, // Reduce tap target size
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8)), // Customize shape if needed
                                    ),
                                    onPressed: () => sendReminder(
                                      user.name,
                                      _formatTimestamp(user.dueDate),
                                      user.mobileNumber,
                                      user.email,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24.0),
                          if (user.status == 'Pending')
                            Obx(() {
                              final isLoading = userController.isLoading.value;
                              return isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Row(
                                      children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.check,
                                            size: 12,
                                          ),
                                          label: const Text(
                                            'Accept',
                                            style: AppStyle.whiteText11,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 8,
                                                bottom: 8), // Remove padding
                                            minimumSize: Size(0,
                                                0), // Remove minimum size constraints
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap, // Reduce tap target size
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8)), // Customize shape if needed
                                          ),
                                          onPressed: onAccept,
                                        ),
                                        const SizedBox(width: 8.0),
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.close,
                                            size: 10,
                                          ),
                                          label: const Text(
                                            'Decline',
                                            style: AppStyle.whiteText11,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 8,
                                                bottom: 8), // Remove padding
                                            minimumSize: Size(0,
                                                0), // Remove minimum size constraints
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap, // Reduce tap target size
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8)), // Customize shape if needed
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
            color: AppColors.lightGrey,
            size: 18,
          ),
        if (title != 'Name') const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Text(
              value.length > 26 ? '${value.substring(0, 26)}...' : value,
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

Download our app: https://play.google.com/store/apps/details?id=com.dfimo.jdsgym
''';

    Share.share(message);
  }
}
