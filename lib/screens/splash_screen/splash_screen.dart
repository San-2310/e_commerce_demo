import 'dart:async'; // Import the Timer class

import 'package:e_commerce_demo/screens/auth_screen/auth_screen.dart';
import 'package:e_commerce_demo/screens/landing_page/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SplashScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to HomePage after 2 seconds
    Timer(Duration(seconds: 3), () {
      if (auth.currentUser == null) {
        Get.offAll(
          () => AuthPage(
            toggleTheme: widget.toggleTheme,
            isDarkMode: widget.isDarkMode,
          ),
        );
      } else {
        Get.offAll(() => LandingPage(
            toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));
      }
      // If user is not logged in, navigate to AuthPage
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => AuthPage(
      //       toggleTheme: widget.toggleTheme,
      //       isDarkMode: widget.isDarkMode,
      //     ),
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/splash.gif"),
            Text(
              'ShopEase', // Display your app name or logo
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
