import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/presentation/home_screen/presentation/home_view.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> signIn() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.offAll(() => const HomeView());
    } catch (e) {
      errorMessage.value = 'Sign-in failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
