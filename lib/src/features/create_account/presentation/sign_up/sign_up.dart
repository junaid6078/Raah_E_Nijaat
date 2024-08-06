import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/home_screen/presentation/home_view.dart';

import '../../../app/presentation/home_screen/presentation/widget/reuseable/BackgroundImage.dart';
import '../../../app/utils/colors.dart';
import '../controller/sign_up_controller.dart';
import '../sign_in/sign_in.dart';
import '../widget/input.dart';

class SignUp extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const BackgroundImage(
            file:
            'assets/images/intricate-mosque-building-architecture-night.jpg',
          ),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                height: size.height,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _appBar(),
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please fill the details and create an account',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Input(
                      controller: controller.nameController,
                      hintText: 'Enter your name',
                      isPassword: false,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    Input(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      isPassword: false,
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    Input(
                      controller: controller.passwordController,
                      hintText: 'Password',
                      icon: Icons.password,
                      isPassword: true,
                    ),
                    const SizedBox(height: 50),
                    Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: controller.isLoading.value ? null : controller.signUp,
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(color: yellowColor)
                            : Text(
                          'Submit',
                          style: TextStyle(
                            color: yellowColor,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                    Center(
                      child: Text(
                        'Or connect with',
                        style: TextStyle(
                          fontSize: 16,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          "assets/images/social media icon/google-icon.svg",
                          width: size.width * 0.05,
                          height: size.height * 0.05,
                        ),
                        SvgPicture.asset(
                          "assets/images/social media icon/facebook-official.svg",
                          width: size.width * 0.05,
                          height: size.height * 0.05,
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignIn());
                      },
                      child: Text(
                        "Already have an account? Login!",
                        style: TextStyle(
                          fontSize: 16,
                          color: whiteColor,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            Get.to(HomeView()); // Replace with your Home widget
          },
          icon: const Icon(Icons.cancel_outlined),
        ),
      ],
    );
  }
}
