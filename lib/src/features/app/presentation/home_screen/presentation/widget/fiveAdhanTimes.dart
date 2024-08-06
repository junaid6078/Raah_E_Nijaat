
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../../domain/adhanTimes/adhanRepository.dart';
import '../../../../utils/colors.dart';

class FiveAdhanTimes extends StatefulWidget {
  final AdhanRepository adhanRepository;

  const FiveAdhanTimes({super.key, required this.adhanRepository});

  @override
  State<FiveAdhanTimes> createState() => _FiveAdhanTimesState();
}

class _FiveAdhanTimesState extends State<FiveAdhanTimes> {
  final List<String> _adhanNameList = [
    "Fajr",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha",
  ];

  String formatTime(String time) {
    // Remove " (PKT)"
    String timeWithoutPKT = time.replaceAll(" (PKT)", "");

    // Parse the time to extract hour and minute
    int hour = int.parse(timeWithoutPKT.split(":")[0]);
    int minute = int.parse(timeWithoutPKT.split(":")[1]);

    // Determine AM or PM
    String period = hour >= 12 ? "PM" : "AM";

    // Convert to 12-hour format
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    // Format the time as a string
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  int _findTodayIndex(List<dynamic> data) {
    DateTime today = DateTime.now();
    String todayDate = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";
    print("today date: $todayDate");

    // Debugging output
    print('Data length: ${data.length}');

    for (int i = 0; i < data.length; i++) {
      String jsonDate = data[i]['date']['gregorian']['date'];
      print('json file data: $jsonDate');

      if (jsonDate == todayDate) {
        print('Found today\'s index: $i');
        return i;
      }
    }

    return -1;
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ////////adhanTimeCardSizes
    final cardHeight = height * 0.13;
    final cardWidth = width * 0.18;

    return SizedBox(
      height: height * 0.14,
      width: width * 0.95,
      child: FutureBuilder<AdhanData>(
        future: widget.adhanRepository.getAdhanData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // print(snapshot.error);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _adhanNameList.length; i++)
                  SizedBox(
                    height: cardHeight,
                    width: cardWidth,
                    child: Card(
                      color: blueColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                            width: width * 0.2,
                            child: Image.asset(
                              'assets/images/adhanIcon/${_adhanNameList[i].toLowerCase()}.png',
                              scale: 12,
                              color: yellowColor,
                            ),
                          ),
                          AutoSizeText(
                            _adhanNameList[i],
                            style: TextStyle(
                                fontSize: width * 0.01, color: lightBlue),
                          ),
                          AutoSizeText(
                            formatTime(adhanData.data[todayIndex]['timings'][_adhanNameList[i]]),
                            style: TextStyle(
                                fontSize: width * 0.01, color: lightBlue),
                          ),
                        ],
                      ),
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
