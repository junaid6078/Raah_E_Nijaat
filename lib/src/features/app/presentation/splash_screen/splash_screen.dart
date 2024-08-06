import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../main.dart';
import '../../utils/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    // Navigate based on auth state after the splash screen delay
    Future.delayed(const Duration(seconds: 1), () {
      if (authController.isLoggedIn.value) {
        Get.offNamed('/home');
      } else {
        Get.offNamed('/home');
      }
    });

    return const Scaffold(
      body: ImageBackground(),
    );
  }
}

class ImageBackground extends StatelessWidget {
  const ImageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            image: const DecorationImage(
              image: AssetImage("assets/images/logo.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        // Uncomment this line to show the loading indicator at the bottom
        Container(
          margin: const EdgeInsets.only(bottom: 80),
          alignment: Alignment.bottomCenter,
          child: const CircularProgressIndicator(
            backgroundColor: Colors.green,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
      ],
    );
  }
}