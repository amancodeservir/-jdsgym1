import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get theme => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(theme);
  }
}
