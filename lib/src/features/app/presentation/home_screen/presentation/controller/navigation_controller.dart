import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/comming_soon/comming_soon.dart';

import '../../../features/quran/quranPage.dart';
import '../../../pages/donate_us/donate_us.dart';
import '../../../pages/dua/dua.dart';
import '../../../pages/fazail/Fazail.dart';
import '../../../pages/hadith/hadith.dart';
import '../../../pages/masjids/masjids.dart';
import '../../../pages/prayer_times/prayer_times.dart';
import '../../../pages/qaida/Qaida.dart';
import '../../../pages/qibla/qibla.dart';
import '../../../pages/tasbih/tasbih.dart';
import '../../../pages/videos/video_List.dart';
import '../../../pages/zakat/zakat.dart';

class NavigationController extends GetxController {
  void navigateTo(int index) {
    // List of pages to navigate to
    List<Widget> gridPages = [
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
      CommingSoon(),
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
