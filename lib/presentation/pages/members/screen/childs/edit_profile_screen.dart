import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/core/utils/custom_progress_indicator.dart';
import 'package:rkfitness/presentation/controllers/snackbar_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/view/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:rkfitness/presentation/view/custom_text_field.dart';

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
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white,  fontFamily: 'Nexa',), // Adjust the color as needed
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white, // Adjust the color as needed
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Adjust the color as needed
      ),
      body: ProgressHUD(
        backgroundColor: Colors.black.withOpacity(0.5),
        indicatorWidget: CustomProgressIndicator(),
        child: Builder(
          builder: (context) => Obx(() {
            if (userController.userData.value == null) {
              return const Center(child: Text('User data not available' ,style: TextStyle(  fontFamily: 'Nexa'),));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () => _selectImage(context),
                        child: Center(
                          child: Stack(
                            children: [
                              _buildAvatarAndEditButton(profileImageUrl!,
                                  _nameController.text.toString(), context),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 40,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 26.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: AppColors.white,
                                      border: Border.all(
                                          color: AppColors.lightGrey,
                                          width: 0.5),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? AppColors.primaryColor
                                                    : Colors.black,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Change',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? AppColors.primaryColor
                                                  : Colors.black,
                                                    fontFamily: 'Nexa',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Full Name',
                        prefixIcon: Icons.person,
                        placeholder: 'Enter your full name',
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Phone Number',
                        prefixIcon: Icons.phone,
                        placeholder: 'Enter your phone number',
                        controller: _mobileNumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        maxLength: 10,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Date of Birth',
                        prefixIcon: Icons.date_range,
                        placeholder: 'Date of Birth',
                        controller: _dobController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select DOB';
                          } else if (!GetUtils.isEmail(value)) {
                            return 'Please select DOB';
                          }
                          return null;
                        },
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Address',
                        prefixIcon: Icons.location_city,
                        placeholder: ' Address',
                        controller: _addressController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
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

  Widget _buildAvatar(
      String profilePicture, String userName, BuildContext context) {
    if (_image != null && _image is File) {
      return CircleAvatar(
        radius: 74,
        backgroundImage: FileImage(_image as File),
      );
    } else if (profilePicture.isNotEmpty) {
      return CircleAvatar(
        radius: 74,
        backgroundImage: NetworkImage(profilePicture),
      );
    } else {
      // Display user's first initial on a red background circle
      String initial = userName.isNotEmpty ? userName[0].toUpperCase() : '';
      return CircleAvatar(
        radius: 74,
        backgroundColor: AppColors.primaryColor,
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
              fontFamily: 'Nexa',
          ),
        ),
      );
    }
  }

  Widget _buildAvatarAndEditButton(
      String profilePicture, String userName, BuildContext context) {
    String initial = userName.isNotEmpty ? userName[0].toUpperCase() : '';
    return Stack(
      children: [
        _buildAvatar(profilePicture, userName, context),
        Positioned(
          right: 0,
          bottom: 0,
          left: 0,
          child: GestureDetector(
            onTap: () {
              _selectImage(context);
            },
            child: Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 26.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.lightGrey, width: 0.5),
                ),
                child: GestureDetector(
                  onTap: () {
                    _selectImage(context);
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryColor
                              : Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.primaryColor
                                    : Colors.black,
                                      fontFamily: 'Nexa',
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
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
