import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raah_e_nijaat/src/features/app/domain/adhanTimes/adhanRepository.dart';
import 'package:raah_e_nijaat/src/features/app/navigator/navigator.dart';
import '../../../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white70,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //_appBar(),
            Container(
              margin: const EdgeInsets.all(16),
              height: size.height * 0.3,
              width: size.width,
              decoration: BoxDecoration(
                //color: yellowColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: yellowColor)
              ),
              child: HijriDate(
                adhanRepository: AdhanRepositoryImpl(context),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
            //   //padding: EdgeInsets.all(8),
            //   height: size.height * 0.12,
            //   width: size.width,
            //   // decoration: BoxDecoration(
            //   //   color: whiteColor,
            //   //   borderRadius: BorderRadius.circular(16),
            //   //   border: Border.all(color: yellowColor)
            //   // ),
            //   child: Card(
            //     color: whiteColor,
            //     child: AllAdhanTimes(
            //       adhanRepository: AdhanRepositoryImpl(context),
            //     ),
            //   ),
            // ),
            const Books(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: blueColor,
      scrolledUnderElevation: 0,
      title: Text(
        "Home",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          color: yellowColor,
        ),
      ),
    );
  }
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit?'),
        content: Text('Do you really want to exit?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ??
        false; // In case of cancellation
  }
}

class HijriDate extends StatefulWidget {
  final AdhanRepository adhanRepository;
  const HijriDate({super.key, required this.adhanRepository});

  @override
  State<HijriDate> createState() => _HijriDateState();
}

class _HijriDateState extends State<HijriDate> {
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

  int _findTodayIndex(List<dynamic> data) {
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

    // Function to parse times and create DateTime objects
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

    // Extract prayer times and convert them to DateTime objects
    DateTime fajr = parseTime(timings["Fajr"] as String);
    DateTime sunrise = parseTime(timings["Sunrise"] as String);
    DateTime dhuhr = parseTime(timings["Dhuhr"] as String);
    DateTime asr = parseTime(timings["Asr"] as String);
    DateTime maghrib = parseTime(timings["Maghrib"] as String);
    DateTime isha = parseTime(timings["Isha"] as String);

    // List of prayer times with their names
    List<MapEntry<String, DateTime>> prayerTimes = [
      MapEntry("Fajr", fajr),
      MapEntry("Sunrise", sunrise),
      MapEntry("Dhuhr", dhuhr),
      MapEntry("Asr", asr),
      MapEntry("Maghrib", maghrib),
      MapEntry("Isha", isha),
    ];

    // Determine the current Adhan
    for (int i = 0; i < prayerTimes.length; i++) {
      if (now.isAfter(prayerTimes[i].value) &&
          (i == prayerTimes.length - 1 ||
              now.isBefore(prayerTimes[i + 1].value))) {
        return prayerTimes[i].key;
      }
    }

    // If the time does not match any of the prayers, return "No Adhan"
    return "Isha"; // If all prayer times have passed, it will return this
  }

  String getCurrentAdhanTime(Map<String, dynamic> timings) {
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat("HH:mm");

    // Function to parse times and create DateTime objects
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

    // Extract prayer times and convert them to DateTime objects
    DateTime fajr = parseTime(timings["Fajr"] as String);
    DateTime sunrise = parseTime(timings["Sunrise"] as String);
    DateTime dhuhr = parseTime(timings["Dhuhr"] as String);
    DateTime asr = parseTime(timings["Asr"] as String);
    DateTime maghrib = parseTime(timings["Maghrib"] as String);
    DateTime isha = parseTime(timings["Isha"] as String);

    // List of prayer times with their names
    List<MapEntry<String, DateTime>> prayerTimes = [
      MapEntry("Fajr", fajr),
      MapEntry("Sunrise", sunrise),
      MapEntry("Dhuhr", dhuhr),
      MapEntry("Asr", asr),
      MapEntry("Maghrib", maghrib),
      MapEntry("Isha", isha),
    ];

    // Determine the current Adhan time
    for (int i = 0; i < prayerTimes.length; i++) {
      if (i == 0 && now.isBefore(prayerTimes[i].value)) {
        return timeFormat.format(prayerTimes[i].value); // Before Fajr
      } else if (now.isAfter(prayerTimes[i - 1].value) &&
          now.isBefore(prayerTimes[i].value)) {
        return timeFormat
            .format(prayerTimes[i - 1].value); // Between two prayers
      }
    }

    // If all prayer times have passed, return the last prayer time
    return timeFormat.format(prayerTimes.last.value);
  }

  String getNextAdhan(Map<String, dynamic> timings) {
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat("HH:mm");

    // Function to parse times and create DateTime objects
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

    // Extract prayer times and convert them to DateTime objects
    DateTime fajr = parseTime(timings["Fajr"] as String);
    DateTime sunrise = parseTime(timings["Sunrise"] as String);
    DateTime dhuhr = parseTime(timings["Dhuhr"] as String);
    DateTime asr = parseTime(timings["Asr"] as String);
    DateTime maghrib = parseTime(timings["Maghrib"] as String);
    DateTime isha = parseTime(timings["Isha"] as String);

    // List of prayer times with their names
    List<MapEntry<String, DateTime>> prayerTimes = [
      MapEntry("Fajr", fajr),
      MapEntry("Sunrise", sunrise),
      MapEntry("Dhuhr", dhuhr),
      MapEntry("Asr", asr),
      MapEntry("Maghrib", maghrib),
      MapEntry("Isha", isha),
    ];

    // Determine the next Adhan
    for (int i = 0; i < prayerTimes.length; i++) {
      if (now.isBefore(prayerTimes[i].value)) {
        return prayerTimes[i].key;
      }
    }

    // If all prayer times have passed, return Fajr of the next day
    return "Fajr"; // Adjust if needed to handle the transition to the next day
  }

  String getNextAdhanTime(Map<String, dynamic> timings) {
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat("HH:mm");

    // Function to parse times and create DateTime objects
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

    // Extract prayer times and convert them to DateTime objects
    DateTime fajr = parseTime(timings["Fajr"] as String);
    DateTime sunrise = parseTime(timings["Sunrise"] as String);
    DateTime dhuhr = parseTime(timings["Dhuhr"] as String);
    DateTime asr = parseTime(timings["Asr"] as String);
    DateTime maghrib = parseTime(timings["Maghrib"] as String);
    DateTime isha = parseTime(timings["Isha"] as String);

    // List of prayer times with their names
    List<MapEntry<String, DateTime>> prayerTimes = [
      MapEntry("Fajr", fajr),
      MapEntry("Sunrise", sunrise),
      MapEntry("Dhuhr", dhuhr),
      MapEntry("Asr", asr),
      MapEntry("Maghrib", maghrib),
      MapEntry("Isha", isha),
    ];

    // Determine the next Adhan time
    for (int i = 0; i < prayerTimes.length; i++) {
      if (now.isBefore(prayerTimes[i].value)) {
        return timeFormat.format(prayerTimes[i].value);
      }
    }

    // If all prayer times have passed, return Fajr time for the next day
    return timeFormat.format(
        fajr); // Adjust if needed to handle the transition to the next day
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<AdhanData>(
        future: widget.adhanRepository.getAdhanData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            AdhanData adhanData = snapshot.data!;
            int todayIndex = _findTodayIndex(adhanData.data);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                  child: SizedBox(
                    width: size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adhanData.data[todayIndex]['date']['hijri']['day']
                              .toString(),
                          style: TextStyle(
                            fontSize: size.width * 0.07,
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          adhanData.data[todayIndex]['date']['hijri']['month']
                              ['ar'],
                          style: TextStyle(
                            fontSize: size.width * 0.07,
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          adhanData.data[todayIndex]['date']['hijri']['year'],
                          style: TextStyle(
                            fontSize: size.width * 0.07,
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Row(
                    children: [
                      Text(
                        adhanData.data[todayIndex]['date']['gregorian']
                            ['weekday']['en'],
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: lightBlue,
                        ),
                      ),
                      Text(
                        ", ",
                        style: TextStyle(color: lightBlue, fontSize: 24),
                      ),
                      Text(
                        adhanData.data[todayIndex]['date']['readable'],
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: lightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: SizedBox(
                    //decoration: BoxDecoration(border: Border.all(color: yellowColor)),
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: adhanData
                          .data[todayIndex]['date']['hijri']['holidays'].length,
                      itemBuilder: (BuildContext context, int holidayIndex) {
                        var holidays = adhanData.data[todayIndex]['date']
                            ['hijri']['holidays'];

                        if (holidays.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        String holidaysText = holidays.join(', ');

                        return Center(
                          child: Text(
                            holidaysText,
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              color: yellowColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: size.height * 0.1,
                  width: size.width,
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: yellowColor),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        height: size.height,
                        width: size.width * 0.25,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: yellowColor),
                        // ),
                        child: FutureBuilder<AdhanData>(
                          future: widget.adhanRepository.getAdhanData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData) {
                              return const Text('No data available');
                            } else {
                              AdhanData adhanData = snapshot.data!;

                              int todayIndex = _findTodayIndex(adhanData.data);
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    getCurrentAdhan(
                                        adhanData.data[todayIndex]['timings']),
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      AutoSizeText(
                                        "End",
                                        style: TextStyle(
                                          color: blueColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                      AutoSizeText(
                                        getNextAdhanTime(adhanData
                                            .data[todayIndex]['timings']),
                                        style: TextStyle(
                                          color: blueColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height,
                        width: size.width * 0.3,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: yellowColor),
                        // ),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                        height: size.height,
                        width: size.width * 0.25,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: yellowColor),
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Upcoming",
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              getNextAdhan(
                                  adhanData.data[todayIndex]['timings']),
                              style: const TextStyle(
                                fontSize: 16,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              getNextAdhanTime(
                                  adhanData.data[todayIndex]['timings']),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AllAdhanTimes extends StatefulWidget {
  final AdhanRepository adhanRepository;
  const AllAdhanTimes({super.key, required this.adhanRepository});

  @override
  State<AllAdhanTimes> createState() => _AllAdhanTimesState();
}

class _AllAdhanTimesState extends State<AllAdhanTimes> {
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

  int _findTodayIndex(List<dynamic> data) {
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

  final List<String> _adhanNameList = [
    "Fajr",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const adhanIndex = 2;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<AdhanData>(
        future: widget.adhanRepository.getAdhanData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            AdhanData adhanData = snapshot.data!;
            int todayIndex = _findTodayIndex(adhanData.data);

            if (todayIndex == -1) {
              return const Center(child: Text('Today\'s data not found'));
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _adhanNameList.length; i++)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      //border: Border.all(color: yellowColor),
                      color: i == adhanIndex ? blueColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.04,
                          width: size.width * 0.1,
                          child: Image.asset(
                            'assets/images/adhanIcon/${_adhanNameList[i].toLowerCase()}.png',
                            color: i != adhanIndex ? blueColor : yellowColor,
                          ),
                        ),
                        //const Spacer(),
                        Text(
                          _adhanNameList[i],
                          style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: lightBlue,
                          ),
                        ),
                        //const Spacer(),
                        Text(
                          formatTime(adhanData.data[todayIndex]['timings']
                              [_adhanNameList[i]]),
                          style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: lightBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 0, 0),
          child: Text(
            'Books',
            style: TextStyle(
              color: blueColor,
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  AppNavigator.toKalamList(context);
                },
                child: Container(
                  height: height * 0.13,
                  width: width,
                  decoration: BoxDecoration(
                    //color: whiteColor,
                    border: Border.all(color: yellowColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        height: height * 0.2,
                        width: width * 0.3,
                        child: Icon(
                          Icons.menu_book,
                          size: width * 0.15,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Raah E Nijaat',
                        style: TextStyle(
                          fontSize: width * 0.06,
                          color: blueColor,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      //color: whiteColor,
                      border: Border.all(color: yellowColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        AppNavigator.toQuran(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 24,
                            color: Colors.black,
                          ),
                          Text(
                            "قرآن مجید",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      //color: whiteColor,
                      border: Border.all(color: yellowColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        //AppNavigator.toQaida(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 24,
                            color: Colors.black,
                          ),
                          Text(
                            "قاعدہ",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      //color: whiteColor,
                      border: Border.all(color: yellowColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        //AppNavigator.toFazail(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 24,
                            color: Colors.black,
                          ),
                          Text(
                            "فضائل",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

}
