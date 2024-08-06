import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/adhanTimes/adhanRepository.dart';
import '../../../../utils/colors.dart';

class adhanTimeCard extends StatefulWidget {
  final AdhanRepository adhanRepository;
  const adhanTimeCard({super.key, required this.adhanRepository});

  @override
  State<adhanTimeCard> createState() => _adhanTimeCardState();
}

class _adhanTimeCardState extends State<adhanTimeCard> {
  // real time code section

  // late String _currentTime;
  // late Timer _timer;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _currentTime =
  //       _formatDateTime(DateTime.now()); // Initialize with current time
  //   _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     setState(() {
  //       _currentTime = _formatDateTime(DateTime.now());
  //     });
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }
  //
  // String _formatDateTime(DateTime dateTime) {
  //   return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  // }
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String Date = DateFormat.yMMMMEEEEd().format(now);

    final heigth = MediaQuery.of(context).size.height;
    final weigth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: heigth * 0.2,
        width: weigth * 0.7,
        child: Card(
          //elevation: 12,
          color: blueColor,
          child: FutureBuilder<AdhanData>(
            future: widget.adhanRepository.getAdhanData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                AdhanData adhanData = snapshot.data!;
                int todayIndex = _findTodayIndex(adhanData.data);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Row(
                        children: [
                          Text(
                            adhanData.data[todayIndex]['date']['gregorian']
                                ['weekday']['en'],
                            style: TextStyle(
                              fontSize: 20,
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              ", ",
                              style:
                                  TextStyle(color: yellowColor, fontSize: 24),
                            ),
                          ),
                          Text(
                            adhanData.data[todayIndex]['date']['readable'],
                            style: TextStyle(
                              fontSize: 20,
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                      child: Row(
                        children: [
                          Text(
                            adhanData.data[todayIndex]['date']['hijri']['day']
                                .toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: weigth * 0.02,
                          ),
                          Text(
                            adhanData.data[todayIndex]['date']['hijri']['month']
                                ['en'],
                            style: TextStyle(
                              fontSize: 14,
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: weigth * 0.02,
                          ),
                          Text(
                            adhanData.data[todayIndex]['date']['hijri']['year'],
                            style: TextStyle(
                              fontSize: 14,
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: weigth * 0.02,
                          ),
                          Text(
                            adhanData.data[todayIndex]['date']['hijri']
                                ['designation']['abbreviated'],
                            style: TextStyle(
                              fontSize: 14,
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 6),
                      child: SizedBox(
                        height: heigth * 0.02,
                        width: weigth * 0.7,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: adhanData
                              .data[todayIndex]['date']['hijri']['holidays']
                              .length,
                          itemBuilder:
                              (BuildContext context, int holidayIndex) {
                            var holidays = adhanData.data[todayIndex]['date']
                                ['hijri']['holidays'];

                            if (holidays.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            String holidaysText = holidays.join(', ');

                            return Row(
                              children: [
                                AutoSizeText(
                                  "Holidays : ",
                                  style: TextStyle(
                                      color: lightBlue,
                                      fontSize: heigth * 0.01),
                                ),
                                AutoSizeText(
                                  holidaysText,
                                  style: TextStyle(
                                      fontSize: heigth * 0.015,
                                      color: yellowColor),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            AutoSizeText(
                              'Current',
                              style: TextStyle(
                                fontSize: heigth * 0.01,
                                color: lightBlue,
                              ),
                            ),
                            AutoSizeText(
                              formatTime(adhanData.data[todayIndex]['timings']
                                  ['Fajr']),
                              style: TextStyle(
                                fontSize: heigth * 0.02,
                                color: yellowColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            AutoSizeText(
                              'Next',
                              style: TextStyle(
                                fontSize: heigth*0.01,
                                color: lightBlue,
                              ),
                            ),
                            AutoSizeText(
                              formatTime(adhanData.data[todayIndex]['timings']
                                  ['Fajr']),
                              style: TextStyle(
                                fontSize: heigth*0.02,
                                color: yellowColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
