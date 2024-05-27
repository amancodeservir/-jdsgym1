// app_routes.dart
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/presentation/pages/admin/admin_dashboard.dart';
import 'package:rkfitness/presentation/pages/members/member_dashboard.dart';
import 'package:rkfitness/presentation/pages/auth/login_screen.dart';
import 'package:rkfitness/presentation/pages/auth/member_signup_screen.dart';
import 'package:rkfitness/presentation/pages/members/screen/childs/edit_profile_screen.dart';
import 'package:rkfitness/presentation/pages/members/screen/childs/feedback_screen.dart';
import 'package:rkfitness/presentation/pages/notification_screen.dart';
import 'package:rkfitness/presentation/pages/onboarding_screen.dart';
import 'package:rkfitness/presentation/pages/option_screen.dart';
import 'package:rkfitness/presentation/pages/phone_auth.dart';
import 'package:rkfitness/presentation/pages/auth/signup_option_screen.dart';
import 'package:rkfitness/presentation/pages/scanner/qr_scanner_screen.dart';
import 'package:rkfitness/presentation/pages/splash_screen.dart';
import 'package:rkfitness/presentation/pages/auth/staff_signup_screen.dart';
import 'package:rkfitness/presentation/pages/staff/staff_dashboard.dart';

class AppRouting {
  static final List<GetPage> getAppRoutes = [
    GetPage(name: AppRoutes.SPLASH, page: () => SplashScreen()),
    GetPage(name: AppRoutes.ONBOARDING, page: () => OnboardingScreen()),
    GetPage(name: AppRoutes.LOGIN, page: () => LoginScreen()),
    GetPage(name: AppRoutes.MEMBERDASHBOARD, page: () => MemberDashboard()),
       GetPage(name: AppRoutes.STAFFDASHBOARD, page: () => StaffDashboard()),
            GetPage(name: AppRoutes.ADMINDASHBOARD, page: () => AdminDashboard()),
    GetPage(name: AppRoutes.OPTION, page: () => OptionScreen()),
    GetPage(name: AppRoutes.SIGNUPOPTION, page: () => SignupOptionScreen()),
    GetPage(name: AppRoutes.MEMBERSIGNUP, page: () => MemberSignupScreen()),
    GetPage(name: AppRoutes.STAFFSIGNUP, page: () => StaffSignupScreen()),
    GetPage(name: AppRoutes.QRSCANNER, page: () => QRScannerScreen()),
    GetPage(name: AppRoutes.EDITPROFILE, page: () => EditProfileScreen()),
    GetPage(name: AppRoutes.FEEDBACK, page: () => FeedbackScreen()),
      GetPage(name: AppRoutes.NOTIFICATIONS, page: () =>  NotificationScreen()),
  ];
}
