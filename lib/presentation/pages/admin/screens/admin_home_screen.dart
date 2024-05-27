import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/pages/UserProfileScreen.dart';

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
                  onAccept: () => userController.updateUserStatus(user.userId, 'accepted'),
                  onReject: () => userController.updateUserStatus(user.userId, 'rejected'),
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
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: user.profilePicture != null && user.profilePicture.isNotEmpty
                ? NetworkImage(user.profilePicture!)
                : AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(user.email, style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(height: 8.0),
                if (user.status == 'pending')
                  Obx(() {
                    final isLoading = userController.isLoading.value;
                    return isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text('Accept'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: onAccept,
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.close),
                                label: const Text('Decline'),
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
                  Text(
                    user.status,
                    style: TextStyle(
                      color: user.status == 'accepted' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  user.role,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
