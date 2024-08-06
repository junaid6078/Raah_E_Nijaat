import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../../domain/adhanTimes/adhanRepository.dart';
import '../../../../utils/colors.dart';

class adhanNameCard extends StatefulWidget {
  final AdhanRepository adhanRepository;
  const adhanNameCard({super.key, required this.adhanRepository});

  @override
  State<adhanNameCard> createState() => _adhanNameCardState();
}

class _adhanNameCardState extends State<adhanNameCard> {
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

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final weigth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: heigth * 0.2,
        width: weigth * 0.25,
        child: Card(
          elevation: 12,
          color: yellowColor,
          child: FutureBuilder<AdhanData>(
            future: widget.adhanRepository.getAdhanData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText(
                      "Fajar",
                      style: TextStyle(
                        color: blueColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        AutoSizeText(
                          "End",
                          style: TextStyle(
                            color: lightBlue,
                            fontSize: 12,
                          ),
                        ),
                        AutoSizeText(
                          formatTime(
                              adhanData.data[todayIndex]['timings']['Fajr']),
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 12,
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
      ),
    );
  }
}
