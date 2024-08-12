import 'package:e_commerce_demo/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:e_commerce_demo/screens/home_page/home_page.dart';

class AuthPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const AuthPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    //final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    RxBool isLoading = false.obs;
    AuthController authController = Get.put(AuthController(
        toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: h / 3,
            ),
            Obx(
              () => isLoading.value
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to HomePage after authentication is done
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) => LandingPage(
                          //       toggleTheme: widget.toggleTheme,
                          //       isDarkMode: widget.isDarkMode,
                          //     ),
                          //   ),
                          //);
                          isLoading.value = true;
                          authController.login();
                        },
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/google.png",
                                width: 50,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Sign in with Google",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
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
    );
  }
}
