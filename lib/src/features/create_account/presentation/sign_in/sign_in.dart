
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/navigator/navigator.dart';
import '../../../app/presentation/home_screen/presentation/home_view.dart';
import '../../../app/presentation/home_screen/presentation/widget/reuseable/BackgroundImage.dart';
import '../../../app/utils/colors.dart';
import '../controller/sign_in_controller.dart';
import '../widget/input.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(
            file: 'assets/images/intricate-mosque-building-architecture-night.jpg',
          ),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                height: size.height,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _appBar(),
                    const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Enter your credentials to connect',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Input(
                      controller: controller.emailController,
                      hintText: 'Email',
                      isPassword: false,
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    Input(
                      controller: controller.passwordController,
                      hintText: 'Password',
                      isPassword: true,
                      icon: Icons.password,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.signIn,
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(
                          color: yellowColor,
                        )
                            : Text(
                          'Submit',
                          style: TextStyle(
                            color: yellowColor,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }),
                    Obx(() {
                      if (controller.errorMessage.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      return Container();
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
                        GestureDetector(
                          onTap: () {
                            // Handle Google sign-in
                          },
                          child: SvgPicture.asset(
                            "assets/images/social media icon/google-icon.svg",
                            width: size.width * 0.05,
                            height: size.height * 0.05,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle Facebook sign-in
                          },
                          child: SvgPicture.asset(
                            "assets/images/social media icon/facebook-official.svg",
                            width: size.width * 0.05,
                            height: size.height * 0.05,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.toSignUp(context);
                      },
                      child: Text(
                        "Don't have an account? Register here!",
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
            Get.to(HomeView());
          },
          icon: const Icon(Icons.cancel_outlined),
        ),
      ],
    );
  }
}
