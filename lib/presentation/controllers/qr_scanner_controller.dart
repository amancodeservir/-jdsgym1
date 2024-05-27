import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rkfitness/core/config/app_routes.dart';

class QRScannerController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController? qrViewController;
  var showScanner = true.obs;
  var isLoading = false.obs; // Observable variable to track loading state
  bool scanCompleted = false;

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    qrViewController!.scannedDataStream.listen((scanData) async {
      if (!scanCompleted && scanData != null) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userId = user.uid;
          String attendanceStatus = '${scanData.code}';
          bool alreadyCheckedIn = await checkAlreadyCheckedInToday(userId);
          bool alreadyCheckedOut = await checkAlreadyCheckedOutToday(userId);
          if (!alreadyCheckedIn) {
            await saveUserAttendanceToFirestore(userId, attendanceStatus, true);
          } else if (!alreadyCheckedOut) {
            await saveUserAttendanceToFirestore(
                userId, attendanceStatus, false);
            print('Check-out saved for user $userId');
          } else {
            print('User has already checked out today');
          }
        } else {
          print('User not assigned');
        }
      }
    });
  }

  Future<void> saveUserAttendanceToFirestore(
      String userId, String attendanceStatus, bool checkIn) async {
    isLoading(true); // Show loader
    if (userId.isNotEmpty && attendanceStatus.isNotEmpty) {
      try {
        CollectionReference attendanceRef = FirebaseFirestore.instance
            .collection('user_attendance')
            .doc(userId)
            .collection('attendances');

        DocumentReference docRef = attendanceRef.doc(_startOfDay().toString());

        DocumentSnapshot docSnapshot = await docRef.get();

        Map<String, dynamic> dataToUpdate = {
          'date': _startOfDay(),
          'userId': userId,
        };

        if (checkIn) {
          dataToUpdate['checkIn'] = Timestamp.now();
          dataToUpdate['checkOut'] = null;
        } else {
          dataToUpdate['checkOut'] = Timestamp.now();
        }
        if (docSnapshot.exists) {
          await docRef.update(dataToUpdate);
        } else {
          await docRef.set(dataToUpdate);
        }
        scanCompleted = true;
        qrViewController?.dispose();
        Get.offNamed(AppRoutes.MEMBERDASHBOARD);
        showScanner(false);
        isLoading(false); // Hide loader

        if (checkIn) {
          print('Check-in saved for user $userId');
        } else {
          print('Check-out saved for user $userId');
        }
      } catch (e) {
        print('Error saving attendance: $e');
        isLoading(false); // Hide loader if error occurs
      }
    }
  }

  Future<bool> checkAlreadyCheckedInToday(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user_attendance')
        .doc(userId)
        .collection('attendances')
        .where('checkIn', isGreaterThanOrEqualTo: _startOfDay())
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> checkAlreadyCheckedOutToday(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user_attendance')
        .doc(userId)
        .collection('attendances')
        .where('checkOut', isGreaterThanOrEqualTo: _startOfDay())
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Timestamp _startOfDay() {
    DateTime now = DateTime.now();
    return Timestamp.fromDate(DateTime(now.year, now.month, now.day));
  }

  void toggleScanner() {
    showScanner.toggle(); 
    if (!showScanner.value) {
      qrViewController?.pauseCamera(); 
    } else {
      qrViewController?.resumeCamera(); 
    }
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }
}
