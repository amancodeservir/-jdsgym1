import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/utils/firebase_storeage_uploader.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/controllers/snackbar_controller.dart';

class UserController extends GetxController {
  ToastController toastController = ToastController();
  var userData = Rxn<UserData>();
  var attendanceData = Rxn<List<Map<String, dynamic>>>();
  var staffAndMembers = Rxn<List<UserData>>();
  var selectedUser = Rxn<UserData>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchAttendanceData();
    fetchStaffAndMembers();
  }

  Future<void> fetchStaffAndMembers() async {
    isLoading(true);
    try {
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('role', whereIn: ['staff', 'member']).get();

      staffAndMembers.value = userDocs.docs
          .map((doc) => UserData.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      print('Fetched staff and members: ${staffAndMembers.value}');
    } catch (e) {
      print('Error fetching staff and members: $e');
      Get.snackbar('Error', 'Failed to fetch staff and members');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUserStatus(String userId, String status, DateTime dueDate,
      BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'status': status, 'dueDate': dueDate});
      toastController.showSuccessSnackbar(
          'Success!', 'User status updated successfully');
      fetchStaffAndMembers();
      Get.back();
      progress?.dismiss();
    } catch (e) {
      print('Error updating user status: $e');
      toastController.showErrorSnackbar(
          'Failed', 'Failed to update user status');
      progress?.dismiss();
    }
  }

  Future<void> sendReminder(String userId, Timestamp dueDate, String type,
      BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    try {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .add({'userId': userId, 'dueDate': dueDate, 'type': type});
      toastController.showSuccessSnackbar(
          'Success!', 'Reminder sent successfully');
    } catch (e) {
      print('Error sending reminder: $e');
      toastController.showErrorSnackbar('Failed', 'Failed to send reminder');
    } finally {
      progress?.dismiss();
    }
  }

  

  void selectUser(UserData user) {
    selectedUser.value = user;
  }

  Future<void> fetchUserData() async {
    isLoading(true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        print('Dinesh $userDoc');
        if (userDoc.exists) {
          userData.value =
              UserData.fromJson(userDoc.data() as Map<String, dynamic>);
          print('Dinesh ${userData.value}');
        } else {
          print('User data not found');
        }
      } catch (e) {
        print('Error fetching user data: $e');
        Get.snackbar('Error', 'Failed to fetch user data');
      } finally {
        isLoading(false);
      }
    } else {
      print('User not logged in');
      isLoading(false);
    }
  }

  Future<void> fetchAttendanceData() async {
    isLoading(true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot attendanceDocs = await FirebaseFirestore.instance
            .collection('user_attendance')
            .doc(user.uid)
            .collection('attendances')
            .get();
        if (attendanceDocs.docs.isNotEmpty) {
          attendanceData.value = attendanceDocs.docs
              .map((doc) => doc.data())
              .cast<Map<String, dynamic>>()
              .toList();
        } else {
          print('Attendance data not found');
        }
      } catch (e) {
        print('Error fetching attendance data: $e');
        Get.snackbar('Error', 'Failed to fetch attendance data');
      } finally {
        isLoading(false);
      }
    } else {
      print('User not logged in');
      isLoading(false);
    }
  }

  Future<void> updateProfileData({
    required String newName,
    required String newMobileNumber,
    required File? newImage,
    required String? newDob,
    required String? newAddress,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        isLoading(true);
        // Update name and mobile number in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': newName,
          'mobileNumber': newMobileNumber,
          'dob': newDob,
          'address': newAddress
        });

        // Upload new image if provided
        String? profilePictureUrl;
        if (newImage != null) {
          FirebaseStorageUploader uploader = FirebaseStorageUploader();
          profilePictureUrl = await uploader.uploadFile(
            newImage,
            'profile_images/${user.uid}',
          );
        }

        // Update profile picture URL in Firestore
        if (profilePictureUrl != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'profilePicture': profilePictureUrl,
          });
        }

        // Update the local userData value
        UserData updatedUserData = UserData(
            userId: userData.value!.userId,
            name: newName,
            email: user.email ?? '',
            mobileNumber: newMobileNumber,
            role: userData.value!.role,
            profilePicture:
                profilePictureUrl ?? userData.value?.profilePicture ?? '',
            dob: newDob ?? userData.value?.dob ?? '',
            address: newAddress ?? userData.value?.address ?? '',
            status: userData.value!.status,
            dueDate: userData.value!.dueDate);
        updateUserData(updatedUserData);
        // Show a success message
        Get.snackbar('Success', 'Profile updated successfully');
        isLoading(false);
      } catch (e) {
        print('Error updating profile data: $e');
        Get.snackbar('Error', 'Failed to update profile');
        isLoading(false);
      }
    } else {
      isLoading(false);
      print('User not logged in');
      Get.snackbar('Error', 'User not logged in');
    }
  }

  void updateUserData(UserData newData) {
    userData.value = newData;
  }

  Future<void> saveFeedback(
      {required String feedback, required String userId}) async {
    try {
      isLoading(true);
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('feedback').add({
        'userId': userId,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      isLoading(false);
    } catch (e) {
      isLoading(false);
      throw e;
    }
  }

  String getUserRole() {
    return userData.value!.role;
  }
}
