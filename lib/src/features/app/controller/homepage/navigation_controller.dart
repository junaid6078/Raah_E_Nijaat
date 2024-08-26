import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/comming_soon/comming_soon.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/kalam/kalamList.dart';
import '../../presentation/pages/quran/quranPage.dart';
import '../../presentation/pages/videos/video_List.dart';

class NavigationController extends GetxController {
  void navigateTo(int index) {
    // List of pages to navigate to
    List<Widget> gridPages = [
      //CommingSoon(),
      //QuranHomePage(),
      KalamList(),
      VideosPage(),
      //CommingSoon(),
      //CommingSoon(),
      //CommingSoon(),
      CommingSoon(),
      //CommingSoon(),
      //CommingSoon(),
      //CommingSoon(),
      CommingSoon(),
      // PrayerTimes(),
      // QuranHomePage(),
      // Fazail(),
      // Qaida(),
      // Qibla(),
      // Dua(),
      // Tasbih(),
      // Zakat(),
      // Hadith(),
      // Masjids(),
      // VideosPage(),
      // DonateUs(),
    ];

    // Navigate to the selected page
    Get.to(() => gridPages[index]);
  }
}
