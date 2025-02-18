import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rkfitness/core/config/app_routes.dart';
import 'package:rkfitness/data/user_data.dart';
import 'package:rkfitness/presentation/controllers/snackbar_controller.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class AuthController extends GetxController {
  ToastController toastController = ToastController();
  UserController userController = UserController();
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Rx<GoogleSignInAccount?> googleSignInAccount;
  GoogleSignIn googleSign = GoogleSignIn();
  var isLoading = false.obs;
  var loggedIn = false.obs;
  var loggedOut = false.obs;
  RxInt realTimeNumber = 0.obs;
  var userData = Rxn<UserData>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(auth.currentUser);
    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSign.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
    googleSignInAccount.bindStream(googleSign.onCurrentUserChanged);
    ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  _setInitialScreen(User? user) async {
    if (user != null) {
      isLoading(true);
      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((userDoc) {
          if (userDoc.exists) {
            userData.value =
                UserData.fromJson(userDoc.data() as Map<String, dynamic>);
            navigateToScreen(userData);
            print('User data1: ${userData.value?.name}');
            // print('User data1: ${userData.value?.status}');
          } else {
            print('User data not found');
          }
        }, onError: (error) {
          print('Error fetching user data: $error');
          Get.snackbar('Error', 'Failed to fetch user data');
        });
      } catch (e) {
        print('Error setting initial screen: $e');
        Get.snackbar('Error', 'Failed to set initial screen');
      } finally {
        isLoading(false);
      }
    } else if (user == null &&
        (loggedIn.value == false || loggedOut.value == true)) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed(AppRoutes.ONBOARDING);
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed(AppRoutes.ONBOARDING);
      });
    }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    if (googleSignInAccount == null) {
      Get.offAllNamed(AppRoutes.ONBOARDING);
    } else {
      //Get.offAllNamed(AppRoutes.HOME);
    }
  }

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSign.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await auth
            .signInWithCredential(credential)
            .catchError((onErr) => print(onErr));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e.toString());
    }
  }

  void register(String name, String email, String mobileNumber, String password,
      String role, BuildContext context) async {
    final progress = ProgressHUD.of(context);
    try {
      progress?.show();
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        var db = FirebaseFirestore.instance;

        db.collection('users').doc(userCredential.user!.uid).set({
          'userId': userCredential.user!.uid,
          'name': name,
          'email': email,
          'mobileNumber': mobileNumber,
          'profilePicture': '',
          'role': role,
          'dob': '',
          'address': '',
          'status': 'Pending',
          'dueDate': Timestamp.now(),
        }).then((_) {
          _setInitialScreen(auth.currentUser);
          toastController.showSuccessSnackbar(
              'Congratulations!', 'Account created  successfully');
          Get.offNamed(AppRoutes.LOGIN);
          progress?.dismiss();
        }).catchError((error) {
          progress?.dismiss();
          print('Failed to add user data to Firestore: $error');
        });
      });
    } on FirebaseAuthException catch (e) {
      progress?.dismiss();
      print(e.message);
      toastController.showErrorSnackbar('Failed', e.message.toString());
    }
  }

  void login(String email, String password, BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading(false);
      _setInitialScreen(auth.currentUser);
      progress?.dismiss();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      toastController.showErrorSnackbar('Failed', e.message.toString());
      progress?.dismiss();
    }
  }

  void signOut() async {
    isLoading(true);
    await auth.signOut().then((value) {
      isLoading(false);
      Get.offNamed(AppRoutes.ONBOARDING);
    }).catchError((onError) => {isLoading(false)});
  }

  void navigateToScreen(Rxn<UserData> userData) {
    print("Dineshh Role: ${userData.value?.role}");

    if (userData.value != null) {
      if (userData.value!.role == 'admin') {
        Future.delayed(const Duration(seconds: 2), () {
          print("Navigating to Admin Dashboard");
          Get.offNamed(AppRoutes.ADMINDASHBOARD);
        });
      } else if (userData.value!.role == 'member') {
        Future.delayed(const Duration(seconds: 2), () {
          print("Navigating to Member Dashboard");
          Get.offNamed(AppRoutes.MEMBERDASHBOARD);
        });
      } else if (userData.value!.role == 'staff') {
        Future.delayed(const Duration(seconds: 2), () {
          print("Navigating to Staff Dashboard");
          Get.offNamed(AppRoutes.STAFFDASHBOARD);
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          print("Navigating to Home");
          // Get.offNamed(AppRoutes.HOME);
        });
      }
    } else {
      print("User data is null");
    }
  }
}
