import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../navigator/navigator.dart';
import '../../utils/colors.dart';

class Qaida extends StatefulWidget {
  const Qaida({super.key});

  @override
  State<Qaida> createState() => _QaidaState();
}

class _QaidaState extends State<Qaida> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: AutoSizeText(
          "قاعدہ",
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
