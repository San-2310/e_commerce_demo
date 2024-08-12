import 'package:e_commerce_demo/controllers/home_controller.dart';
import 'package:e_commerce_demo/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const LandingPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Initialize GetX controller
  final HomeController controller = Get.put(HomeController());

  // Navigation bar items
  final List<BottomNavigationBarItem> navBarItem = [
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/home.png',
        width: 24,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/heart.png',
        width: 24,
      ),
      label: 'Favorites',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/cart.png',
        width: 24,
      ),
      label: 'Cart',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/profile.png',
        width: 24,
      ),
      label: 'Profile',
    ),
  ];

  // Navigation body content
  final List<Widget> navBody = [
    // Scaffold(
    //   backgroundColor: Colors.blue,
    // ),
    HomeScreen(),
    Scaffold(
      backgroundColor: Colors.red,
    ),
    Scaffold(
      backgroundColor: Colors.amber,
    ),
    Scaffold(
      backgroundColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'ShopEase',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 32,
            ),
            onPressed: widget.toggleTheme,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Obx(
        () => navBody.elementAt(controller.currNavIndex.value),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currNavIndex.value,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.background,
          items: navBarItem,
          onTap: (value) {
            controller.currNavIndex.value = value;
          },
        ),
      ),
    );
  }
}
