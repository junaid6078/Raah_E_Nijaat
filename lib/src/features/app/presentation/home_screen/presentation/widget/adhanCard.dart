import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../domain/adhanTimes/adhanRepository.dart';
import '../../../../utils/colors.dart';
import '../../../features/Fazail.dart';
import '../../../features/Qaida.dart';
import '../../../features/quran/quranPage.dart';

class AdhanCard extends StatefulWidget {
  const AdhanCard({super.key});

  @override
  State<AdhanCard> createState() => _AdhanCardState();
}

class _AdhanCardState extends State<AdhanCard> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _key,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AdhanTimeCard(
                adhanRepository: AdhanRepositoryImpl(context),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              const Books(),
              SizedBox(
                height: height * 0.05,
              ),
              const PosterCard()
            ],
          ),
        ),
      ),
    );
  }
}

class AdhanTimeCard extends StatefulWidget {
  final AdhanRepository adhanRepository;
  const AdhanTimeCard({super.key, required this.adhanRepository});

  @override
  State<AdhanTimeCard> createState() => _AdhanTimeCardState();
}

class _AdhanTimeCardState extends State<AdhanTimeCard> {
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: height * 0.5,
      width: width,
      decoration: BoxDecoration(
        color: blueColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          //_appBar(),
          const Spacer(),
          // Uncomment the following section if you need the dropdown location menu
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          //   child: Container(
          //     height: height * 0.03,
          //     width: width * 0.3,
          //     child: dropDownLocationMenu(),
          //   ),
          // ),
          const Spacer(),
          SizedBox(
            height: height * 0.12,
            width: width * 0.9,
            child: FutureBuilder<AdhanData>(
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.5,
                              child: Row(
                                children: [
                                  Text(
                                    adhanData.data[todayIndex]['date']['hijri']
                                            ['day']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: width * 0.06,
                                      color: yellowColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Text(
                                    adhanData.data[todayIndex]['date']['hijri']
                                        ['month']['ar'],
                                    style: TextStyle(
                                      fontSize: width * 0.06,
                                      color: yellowColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Text(
                                    adhanData.data[todayIndex]['date']['hijri']
                                        ['year'],
                                    style: TextStyle(
                                      fontSize: width * 0.06,
                                      color: yellowColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: width * 0.3,
                              height: height * 0.04,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: adhanData
                                    .data[todayIndex]['date']['hijri']
                                        ['holidays']
                                    .length,
                                itemBuilder:
                                    (BuildContext context, int holidayIndex) {
                                  var holidays = adhanData.data[todayIndex]
                                      ['date']['hijri']['holidays'];

                                  if (holidays.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  String holidaysText = holidays.join(', ');

                                  return Center(
                                    child: Text(
                                      holidaysText,
                                      style: TextStyle(
                                        fontSize: width * 0.05,
                                        color: yellowColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              adhanData.data[todayIndex]['date']['gregorian']
                                  ['weekday']['en'],
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: lightBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ", ",
                              style: TextStyle(color: lightBlue, fontSize: 24),
                            ),
                            Text(
                              adhanData.data[todayIndex]['date']['readable'],
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: lightBlue,
                                fontWeight: FontWeight.bold,
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
          ),
          const Spacer(),
          SizedBox(
            height: height * 0.09,
            width: width * 0.9,
            child: FutureBuilder<AdhanData>(
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
                    children: [
                      SizedBox(
                        width: width * 0.25,
                        child: Column(
                          children: [
                            Text(
                              "Remaining",
                              style: TextStyle(
                                  color: lightBlue, fontSize: width * 0.03),
                            ),
                            Text(
                              "Time",
                              style: TextStyle(
                                  color: lightBlue, fontSize: width * 0.03),
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                fontSize: height * 0.02,
                                color: yellowColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width * 0.3,
                        child: Center(
                          child: Text(
                            'Isha',
                            style: TextStyle(
                              color: yellowColor,
                              fontSize: width * 0.09,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width * 0.25,
                        child: Column(
                          children: [
                            Text(
                              "Next",
                              style: TextStyle(
                                  color: lightBlue, fontSize: width * 0.03),
                            ),
                            Text(
                              "Fajar",
                              style: TextStyle(
                                fontSize: height * 0.02,
                                color: yellowColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatTime(adhanData.data[todayIndex]['timings']
                                  ['Fajr']),
                              style: TextStyle(
                                fontSize: height * 0.02,
                                color: yellowColor,
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
          ),
          const Spacer(),
          SizedBox(
            height: height * 0.1,
            width: width * 0.9,
            child: FutureBuilder<AdhanData>(
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.04,
                              width: width * 0.1,
                              child: Image.asset(
                                'assets/images/adhanIcon/${_adhanNameList[i].toLowerCase()}.png',
                                color: yellowColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _adhanNameList[i],
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: lightBlue,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatTime(adhanData.data[todayIndex]['timings']
                                  [_adhanNameList[i]]),
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: lightBlue,
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
          const Spacer(),
        ],
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
  int _gridIndex = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 0, 8),
          child: Text(
            'Books',
            style: TextStyle(
              color: blueColor,
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: height * 0.15,
              width: width,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SizedBox(
                height: height * 0.13,
                width: width,
                child: _gridView(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  GridView _gridView() {
    final List<String> gridList = [
      "قرآن مجید",
      "قاعدہ",
      "فضائل",
    ];
    final List<Widget> gridPages = [
      const QuranHomePage(),
      const Qaida(),
      const Fazail(),
    ];

    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: gridList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _gridIndex = index;
            });
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => gridPages[_gridIndex],
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.05,
            decoration: BoxDecoration(
              border: Border.all(color: yellowColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 24,
                  color: Colors.black,
                ),
                Text(
                  gridList[index],
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PosterCard extends StatefulWidget {
  const PosterCard({super.key});

  @override
  State<PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends State<PosterCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 0, 8),
          child: Text(
            'Raahe Nijaat Version',
            style: TextStyle(
              color: blueColor,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Posters(
          posters: postersList,
        )
      ],
    );
  }
}

final List<Poster> postersList = [
  Poster("version 1", "assets/images/logo.png"),
  Poster("version 2", "assets/images/logo.png"),
  Poster("version 3", "assets/images/logo.png"),
];

class Poster {
  final String versionName;
  final String imageUrl;

  Poster(this.versionName, this.imageUrl);
}

class Posters extends StatelessWidget {
  final List<Poster> posters;
  const Posters({super.key, required this.posters});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.8, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: posters.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Image.asset(
                  posters[index].imageUrl,
                  fit: BoxFit.cover,
                ),
                Text(posters[index].versionName),
              ],
            ),
          );
        },
      ),
    );
  }
}
