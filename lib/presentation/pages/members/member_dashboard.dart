import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/presentation/controllers/auth_controller.dart';
import 'package:rkfitness/presentation/controllers/qr_scanner_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/pages/members/screen/member_activity_screen.dart';
import 'package:rkfitness/presentation/pages/members/screen/member_exercise_screen.dart';
import 'package:rkfitness/presentation/pages/members/screen/member_home_screen.dart';
import 'package:rkfitness/presentation/pages/members/screen/member_profile_screen.dart';

class MemberDashboard extends StatefulWidget {
  @override
  _MemberDashboardState createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  final UserController userController = Get.find<UserController>();
  final AuthController _authController = AuthController();
  int _currentIndex = 0;
  final QRScannerController controller = Get.put(QRScannerController());

  @override
  void initState() {
    userController.fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          // Show exit confirmation dialog
          return await _showExitConfirmationDialog();
        } else {
          // Navigate to home screen
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.fill,
                  height: 40,
                  width: 100,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.QRSCANNER);
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                size: 28,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
              Get.toNamed(AppRoutes.NOTIFICATIONS);
              },
              icon: const Icon(
                Icons.notifications_outlined,
                size: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  MemberHomeScreen(),
                  MemberExerciseScreen(),
                  MemberActivityScreen(),
                  MemberProfileScreen(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Exercise',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
