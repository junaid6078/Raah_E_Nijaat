import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/colors.dart';

class BackgroundImage extends StatelessWidget {
  final String file;
  const BackgroundImage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            file,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              blueColor.withOpacity(0.1),
              blueColor.withOpacity(0.2),
              blueColor.withOpacity(0.3),
              blueColor.withOpacity(0.4),
              blueColor.withOpacity(0.5),
              blueColor.withOpacity(0.6),
              blueColor.withOpacity(0.7),
              blueColor.withOpacity(0.8),
              blueColor.withOpacity(0.9),
            ],
          ),
        ),
      ),
    );
  }
}
