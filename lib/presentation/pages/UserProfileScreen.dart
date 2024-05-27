import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class UserProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final user = userController.selectedUser.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profilePicture != null
                          ? NetworkImage(user.profilePicture!)
                          : AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      user.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text('Role: ${user.role}',
                      style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(height: 8.0),
                  Text('Email: ${user.email}',
                      style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(height: 8.0),
                  Text('Status: ${user.status}',
                      style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(height: 8.0),
                  Text('Due Date: ${user.dueDate}',
                      style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(height: 24.0),
                  if (user.status == 'Pending')
                    Obx(() {
                      final isLoading = userController.isLoading.value;
                      return isLoading
                          ? Center(child: CircularProgressIndicator())
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
                                  onPressed: () =>
                                      userController.updateUserStatus(
                                          user.userId, 'Accepted'),
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
                                          user.userId, 'Rejected'),
                                ),
                              ],
                            );
                    })
                  else
                    Center(
                      child: Text(
                        user.status,
                        style: TextStyle(
                          color: user.status == 'Accepted'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
