import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/comming_soon/comming_soon.dart';

import '../../presentation/features/quran/quranPage.dart';
import '../../presentation/pages/donate_us/donate_us.dart';
import '../../presentation/pages/dua/dua.dart';
import '../../presentation/pages/fazail/Fazail.dart';
import '../../presentation/pages/hadith/hadith.dart';
import '../../presentation/pages/masjids/masjids.dart';
import '../../presentation/pages/prayer_times/prayer_times.dart';
import '../../presentation/pages/qaida/Qaida.dart';
import '../../presentation/pages/qibla/qibla.dart';
import '../../presentation/pages/tasbih/tasbih.dart';
import '../../presentation/pages/videos/video_List.dart';
import '../../presentation/pages/zakat/zakat.dart';

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
