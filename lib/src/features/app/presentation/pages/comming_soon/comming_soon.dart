import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/home_screen/presentation/widget/reuseable/BackgroundImage.dart';

class CommingSoon extends StatelessWidget {
  const CommingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Comming Soon...'),
      ),
    );
  }
}
