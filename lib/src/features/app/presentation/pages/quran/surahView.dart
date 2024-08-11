import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:raah_e_nijaat/src/features/app/presentation/pages/quran/quran_page_view/surah_page_view.dart';

import '../../../utils/colors.dart';


class SurahViewPage extends StatefulWidget {
  const SurahViewPage({super.key});

  @override
  State<SurahViewPage> createState() => _SurahViewPageState();
}

class _SurahViewPageState extends State<SurahViewPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
      itemCount: quran.totalSurahCount,
      itemBuilder: (context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SurahPageView(
                  surahNumber: index,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            height: height * 0.08,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: yellowColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/numberPlaceholder.png',
                              scale: width * 0.02,
                            ),
                            AutoSizeText(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: yellowColor,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          quran.getSurahName(index + 1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: blueColor,
                            fontSize: width * 0.05,
                          ),
                        ),
                        Row(
                          children: [
                            AutoSizeText(
                              "${quran.getVerseCount(index + 1)} Verses",
                              style: TextStyle(
                                color: blueColor,
                                fontSize: 12,
                              ),
                            ),
                            AutoSizeText(
                              " | ${quran.getPlaceOfRevelation(index + 1)}",
                              style: TextStyle(
                                color: blueColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  child: Text(
                    quran.getSurahNameArabic(index + 1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: blueColor,
                      fontSize: width * 0.07,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
              ),
    );
  }
}
