import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';

class Hadith extends StatefulWidget {
  const Hadith({super.key});

  @override
  State<Hadith> createState() => _HadithState();
}

class _HadithState extends State<Hadith> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),

    );
  }
  AppBar _appBar(){
    return AppBar(
      title: Text('Hadith'),
    );
  }
}
