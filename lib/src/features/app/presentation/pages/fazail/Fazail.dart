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
      appBar: _appBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        "فضائل",
      ),
    );
  }
}
