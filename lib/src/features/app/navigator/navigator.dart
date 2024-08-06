import 'package:flutter/material.dart';

class AppNavigator {
  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
  static void toSplash(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/splash");
  }
  static void toSignIn(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/signIn");
  }
  static void toSignUp(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/signUp");
  }

  static void toHome(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/home");
  }
  static void toKalamList(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/kalamList");
  }
  static void toQuran(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/quran");
  }
  static void toQaida(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/qaida");
  }
  static void toFazail(BuildContext context) {
    close(context);
    Navigator.pushNamed(context, "/fazail");
  }
}
