import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_constant.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/config/app_routing.dart';
import 'package:rkfitness/presentation/controllers/auth_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyC_5L7WYoQvmMz9M2bAeCd9U0u-lbZ6-Ek',
            appId: '1:87003555730:android:053dd630ad5e90feb4034b',
            messagingSenderId: '87003555730',
            projectId: 'rkfitness-78b0c',
            storageBucket: "rkfitness-78b0c.appspot.com"));
    await FirebaseAppCheck.instance.activate();
  } else if (GetPlatform.isWeb) {
    await Firebase.initializeApp();
  }
  Get.put(AuthController());
  Get.put(UserController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        hintColor: AppColors.accentColor,
        textTheme: const TextTheme(
       
        ), 
      ),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppRouting.getAppRoutes, 
    );
  }
}
