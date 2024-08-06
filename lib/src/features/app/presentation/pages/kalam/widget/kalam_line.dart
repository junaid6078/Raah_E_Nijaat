import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';

class KalamLine extends StatelessWidget {
  final Color color;
  final double height;
  final String text;
  final double fontSize;

  const KalamLine({
    super.key,
    required this.color,
    required this.height,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 0),
        color: color,
        height: (height == null) ? 5 : height,
        child: (text == null)
            ? null
            : Container(
          // decoration: BoxDecoration(
          //   border: Border.all(color: yellowColor),
          // ),
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Center(
            child: AutoSizeText(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: blueColor,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }
}
