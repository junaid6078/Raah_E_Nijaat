import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../domain/adhanTimes/adhanRepository.dart';

class HijriDateController extends GetxController {
  final AdhanRepository adhanRepository;

  HijriDateController(this.adhanRepository);

  Rx<AdhanData?> adhanData = Rx<AdhanData?>(null);
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchAdhanData();
    super.onInit();
  }

  Future<void> fetchAdhanData() async {
    try {
      isLoading(true);
      adhanData.value = await adhanRepository.getAdhanData();
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }

  String formatTime(String time) {
    String timeWithoutPKT = time.replaceAll(" (PKT)", "");
    int hour = int.parse(timeWithoutPKT.split(":")[0]);
    int minute = int.parse(timeWithoutPKT.split(":")[1]);
    String period = hour >= 12 ? "PM" : "AM";

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  int findTodayIndex(List<dynamic> data) {
    DateTime today = DateTime.now();
    String todayDate =
        "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";

    for (int i = 0; i < data.length; i++) {
      String jsonDate = data[i]['date']['gregorian']['date'];
      if (jsonDate == todayDate) {
        return i;
      }
    }

    return -1;
  }

  String getCurrentAdhan(Map<String, dynamic> timings) {
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat("HH:mm");

    DateTime parseTime(String timeString) {
      DateTime parsedTime = timeFormat.parse(timeString.split(" ")[0]);
      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    }

    DateTime fajr = parseTime(timings["Fajr"] as String);
    DateTime sunrise = parseTime(timings["Sunrise"] as String);
    DateTime dhuhr = parseTime(timings["Dhuhr"] as String);
    DateTime asr = parseTime(timings["Asr"] as String);
    DateTime maghrib = parseTime(timings["Maghrib"] as String);
    DateTime isha = parseTime(timings["Isha"] as String);

    List<MapEntry<String, DateTime>> prayerTimes = [
      MapEntry("Fajr", fajr),
      MapEntry("Sunrise", sunrise),
      MapEntry("Dhuhr", dhuhr),
      MapEntry("Asr", asr),
      MapEntry("Maghrib", maghrib),
      MapEntry("Isha", isha),
    ];

    for (int i = 0; i < prayerTimes.length; i++) {
      if (now.isAfter(prayerTimes[i].value) &&
          (i == prayerTimes.length - 1 ||
              now.isBefore(prayerTimes[i + 1].value))) {
        return prayerTimes[i].key;
      }
    }

    return "Isha"; // Adjust as needed
  }

  String getNextAdhanTime(Map<String, dynamic> timings) {
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat("HH:mm");

    DateTime parseTime(String timeString) {
      DateTime parsedTime = timeFormat.parse(timeString.split(" ")[0]);
      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    }

    DateTime fajr = parseTime(timings["Fajr"] as String);
    DateTime sunrise = parseTime(timings["Sunrise"] as String);
    DateTime dhuhr = parseTime(timings["Dhuhr"] as String);
    DateTime asr = parseTime(timings["Asr"] as String);
    DateTime maghrib = parseTime(timings["Maghrib"] as String);
    DateTime isha = parseTime(timings["Isha"] as String);

    List<MapEntry<String, DateTime>> prayerTimes = [
      MapEntry("Fajr", fajr),
      MapEntry("Sunrise", sunrise),
      MapEntry("Dhuhr", dhuhr),
      MapEntry("Asr", asr),
      MapEntry("Maghrib", maghrib),
      MapEntry("Isha", isha),
    ];

    for (int i = 0; i < prayerTimes.length; i++) {
      if (now.isBefore(prayerTimes[i].value)) {
        return timeFormat.format(prayerTimes[i].value);
      }
    }

    return timeFormat.format(fajr); // Adjust as needed
  }

  final List<String> adhanNameList = [
    "Fajr",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha",
  ];

  int getAdhanIndex(String currentAdhan) {
    return adhanNameList.indexOf(currentAdhan);
  }
}
