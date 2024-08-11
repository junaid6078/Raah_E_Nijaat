import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/account/feedback/feedback.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/quran/quranPage.dart';
import 'package:raah_e_nijaat/src/features/create_account/presentation/sign_up/sign_up.dart';
import 'firebase_options.dart';

import 'package:raah_e_nijaat/src/features/app/presentation/pages/fazail/Fazail.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/qaida/Qaida.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/home_screen/presentation/home_view.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/kalam/kalamList.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/signIn', page: () => SignUp()),
        GetPage(name: '/signUp', page: () =>  SignUp()),
        GetPage(name: '/home', page: () => const HomeView()),
        GetPage(name: '/kalamList', page: () => const KalamList()),
        GetPage(name: '/quran', page: () => const QuranHomePage()),
        GetPage(name: '/qaida', page: () => const Qaida()),
        GetPage(name: '/fazail', page: () => const Fazail()),
      ],
    );
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      isLoggedIn.value = user != null;
    });
  }
}
