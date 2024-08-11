import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../utils/colors.dart';

class SurahPageView extends StatefulWidget {
  final int surahNumber;
  const SurahPageView({super.key, required this.surahNumber});

  @override
  State<SurahPageView> createState() => _SurahPageViewState();
}

class _SurahPageViewState extends State<SurahPageView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final int surahNumber = widget.surahNumber + 1;

    // Get details of the surah
    final String surahName = quran.getSurahName(surahNumber) ?? 'Unknown Surah';
    final String surahNameEnglish =
        quran.getSurahNameEnglish(surahNumber) ?? 'Unknown Surah';
    final String placeOfRevelation =
        quran.getPlaceOfRevelation(surahNumber) ?? 'Unknown Place';
    final int verseCount = quran.getVerseCount(surahNumber) ?? 0;
    final String surahNameArabic = quran.getSurahNameArabic(surahNumber) ?? '';

    return Scaffold(
      backgroundColor: whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: blueColor,
            pinned: true,
            expandedHeight: height * 0.25,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  //centerTitle: true,
                  title: top <= 100
                      ? AutoSizeText(
                          surahName,
                          style: TextStyle(
                            color: yellowColor,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  background: Container(
                    color: blueColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.05,
                        ), // Space for the AppBar
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        surahName,
                                        style: TextStyle(
                                          color: yellowColor,
                                          fontSize: width * 0.06,
                                        ),
                                      ),
                                      AutoSizeText(
                                        surahNameEnglish,
                                        style: TextStyle(
                                          color: yellowColor,
                                          fontSize: width * 0.03,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          AutoSizeText(
                                            "$placeOfRevelation | ",
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          AutoSizeText(
                                            "$verseCount Verses",
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: AutoSizeText(
                                    surahNameArabic,
                                    style: TextStyle(
                                      fontSize: width * 0.08,
                                      color: yellowColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final verseText = quran.getVerse(surahNumber, index + 1,
                        verseEndSymbol: true) ??
                    'No Verse Text';
                return Container(
                  height: height * 0.5,
                  width: width,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: yellowColor,
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      AutoSizeText(
                        verseText,
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: blueColor,
                        ),
                        textAlign: TextAlign.center,
                        minFontSize: 10,
                        stepGranularity: 1,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Spacer(),
                      // AutoSizeText(
                      //   quran.getVerseTranslation(surahNumber, index+1),
                      //   style: TextStyle(
                      //     fontSize: width * 0.05,
                      //     color: blueColor,
                      //   ),
                      //   textAlign: TextAlign.center,
                      //   minFontSize: 10,
                      //   stepGranularity: 1,
                      //   maxLines: 6,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.volume_up),
                            color: blueColor,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.bookmark),
                            color: blueColor,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.translate),
                            color: blueColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: verseCount,
            ),
          ),
        ],
      ),
    );
  }
}
