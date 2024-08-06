
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../features/Fazail.dart';
import '../../../features/favouriteKalam.dart';
import '../../../pages/kalam/kalamList.dart';

class featuresGrids extends StatefulWidget {
  const featuresGrids({super.key});

  @override
  State<featuresGrids> createState() => _featuresGridsState();
}

class _featuresGridsState extends State<featuresGrids> {
  int _gridIndex = 0;
  final List _gridList = [
    "نعتیں",
    "کتابیں",
    "قاعدہ",
    "فضائل",
    "Studio",
    // "سٹوڈیو",
    "Favourite",
  ];
  final _gridPages = [
    const KalamList(),
    const Fazail(),
    const KalamList(),
    const Fazail(),
    const KalamList(),
    FavouriteKalam(),
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        //margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
        //height: heigth * 0.4,
        decoration: const BoxDecoration(
          // border: Border.all(
          //   color: yellowColor,
          // ),
          color: Colors.white,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(18),
          //   topRight: Radius.circular(18),
          // ),
        ),
        child: GridView.builder(
          itemCount: _gridList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(
                      () {
                    _gridIndex = index;
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => _gridPages[_gridIndex],
                      ),
                    );
                  },
                );
              },
              child: Card(
                elevation: 8,
                color: Colors.white,
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "راہِ نجات",
                      style:
                      TextStyle(color: blueColor, fontSize: width * 0.03),
                    ),
                    AutoSizeText(
                      _gridList[index].toString(),
                      style: TextStyle(
                        fontSize: width * 0.07,
                        color: blueColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
