import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_routes.dart';
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
          title: Container(
            child: Row(
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.fill,
                    height: 64,
                    width: 64,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  _currentIndex == 0
                      ? 'RK FITNESS CLUB'
                      : _getAppBarTitle(_currentIndex),
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.QRSCANNER);
                  },
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16.0),
                IconButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.NOTIFICATIONS);
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            MemberHomeScreen(),
            MemberExerciseScreen(),
            MemberActivityScreen(),
            MemberProfileScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Container _buildBottomNavigationBar() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildNavItem(0, Icons.home, 'Home'),
          ),
          Expanded(
            child: _buildNavItem(1, Icons.fitness_center, 'Exercise'),
          ),
          Expanded(
            child: _buildNavItem(2, Icons.local_activity, 'Activity'),
          ),
          Expanded(
            child: _buildNavItem(3, Icons.person, 'Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Container(
      child: IconButton(
        onPressed: () => _onTabTapped(index),
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _currentIndex == index
                  ? AppColors.primaryColor
                  : AppColors.black1,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentIndex == index
                        ? AppColors.primaryColor
                        : AppColors.black1,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Exercise';
      case 2:
        return 'Activity';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
