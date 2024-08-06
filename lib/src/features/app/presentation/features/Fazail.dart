import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/navigator/navigator.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';

class Fazail extends StatefulWidget {
  const Fazail({super.key});

  @override
  State<Fazail> createState() => _FazailState();
}

class _FazailState extends State<Fazail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text(
          "فضائل",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: yellowColor,
          ),
        ),
        leading: BackButton(
          color: yellowColor,
          onPressed: (){
            AppNavigator.toHome(context);
          },
        ),
      ),
    );
  }
}
