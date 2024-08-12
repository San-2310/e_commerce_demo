import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_demo/configs/messages.dart';
import 'package:e_commerce_demo/screens/landing_page/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  // Constructor to initialize toggleTheme and isDarkMode
  AuthController({
    required this.toggleTheme,
    required this.isDarkMode,
  });

  Future<void> login() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        errorMessage("Login Cancelled");
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the signed-in user
      User? user = userCredential.user;

      if (user != null) {
        // Check if the user already exists in Firestore
        DocumentSnapshot userDoc =
            await db.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // Create a new user in Firestore
          await db.collection('users').doc(user.uid).set({
            'id': user.uid,
            'name': googleUser.displayName ?? '',
            'email': googleUser.email,
            'favorites': [],
            'cart': [],
            'boughtItems': [],
            'wishlists': [],
          });
          successMessage("User Created");
        }

        successMessage("Login Success");
      }

      // Navigate to the LandingPage and pass the toggleTheme and isDarkMode
      Get.offAll(
          () => LandingPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode));
    } catch (e) {
      errorMessage("Login Failed");
      print(e);
    }
  }
}
