import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../app/services/firebase_auth/firebase_Auth.dart';

class SignUpController extends GetxController {
  var isLoading = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void signUp() async {
    isLoading.value = true;

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Basic validation
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        Get.snackbar('Error', 'All fields are required.');
        isLoading.value = false;
        return;
      }

      // Create a new user
      await AuthService().SignUpWithEmailAndPassword(
          context: Get.context!,
          name: name,
          emailAddress: email,
          password: password);
    } catch (e) {
      // Handle sign-up errors
      Get.snackbar('Sign-up error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
