import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/snackbar_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/view/custom_button.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ToastController toastController = ToastController();
  final UserController userController = Get.find<UserController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _image;
  String? profileImageUrl;

  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController.text = userController.userData.value?.name ?? '';
    profileImageUrl = userController.userData.value?.profilePicture ?? '';
    _mobileNumberController.text =
        userController.userData.value?.mobileNumber ?? '';
    _dobController.text = userController.userData.value?.dob ?? '';
    _addressController.text = userController.userData.value?.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () => _selectImage(context),
                        child: _image != null && _image is File
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(_image as File))
                            : profileImageUrl!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(profileImageUrl!))
                                : const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                        'assets/default_profile_image.jpg'),
                                  ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _mobileNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Mobile Number'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _dobController,
                        decoration:
                            const InputDecoration(labelText: 'Date of Birth'),
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        onPressed: () {
                          _saveChanges(context);
                        },
                        text: 'Save Changes',
                      ),
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

  Widget _buildAvatarAndEditButton(String profilePicture) {
    return Stack(
      children: [
        profilePicture.isNotEmpty
            ? CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(profilePicture))
            : const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/default_avatar.png'),
              ),
        Positioned(
          right: 2,
          bottom: 1,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
                color: AppColors.primaryColor,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.white,
                  size: 16,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _saveChanges(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    final String newName = _nameController.text.trim();
    final String newMobileNumber = _mobileNumberController.text.trim();
    final String newDob = _dobController.text.trim();
    final String newAddress = _addressController.text.trim();
    if (newName.isNotEmpty && newMobileNumber.isNotEmpty) {
      try {
        progress?.show();
        await userController.updateProfileData(
          newName: newName,
          newMobileNumber: newMobileNumber,
          newImage: _image,
          newDob: newDob,
          newAddress: newAddress,
        );
        Get.back();
        toastController.showSuccessSnackbar(
            'Success!', 'Profile update successfully');
        progress?.dismiss();
      } catch (e) {
        print('Error updating profile data: $e');

        toastController.showErrorSnackbar('Error', 'Failed to update profile');
        progress?.dismiss();
      }
    } else {
      toastController.showErrorSnackbar(
          'Error', 'Name and Mobile Number cannot be empty.');
      progress?.dismiss();
    }
  }
}
