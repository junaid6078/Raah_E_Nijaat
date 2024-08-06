import 'package:alquran_cloud/alquran_cloud.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:raah_e_nijaat/src/features/app/presentation/features/quran/quran_page_view/juzz_page_detail.dart';

import '../../../utils/colors.dart';

class JuzzViewPage extends StatefulWidget {
  const JuzzViewPage({super.key});

  @override
  State<JuzzViewPage> createState() => _JuzzViewPageState();
}

class _JuzzViewPageState extends State<JuzzViewPage> {
  final juzz = getJuzByNumber;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: quran.totalJuzCount, // Adjusted to total Juz count
        itemBuilder: (context, int index) {
          // // Retrieve ayahs by Juz ID
          // List<Ayahs> juzAyahs = Quran.getJuz(id: index+1);
          // print('\nJuz $index Ayahs:');
          // // juzAyahs.forEach((ayah) {
          // //   print('Ayah ${ayah.numberInSurah}: ${ayah.text}');
          // // });

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const JuzzPageView(
                    juzzText: [],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              height: height * 0.08, // Consistent with SurahViewPage
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: yellowColor), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
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
                                fontSize: width * 0.04, // Adjusted font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AutoSizeText(
                        "Chapter ${index + 1}",
                        style: TextStyle(
                          color: blueColor,
                          fontSize: width * 0.05, // Adjusted font size
                        ),
                      ),
                    ],
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
