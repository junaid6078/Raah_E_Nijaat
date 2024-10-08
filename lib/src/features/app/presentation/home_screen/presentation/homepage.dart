import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:raah_e_nijaat/src/features/app/domain/adhanTimes/adhanRepository.dart';
import 'package:raah_e_nijaat/src/features/app/services/Ads/google_ads.dart';
import '../../../controller/location/location_service.dart';
import '../../../utils/colors.dart';
import '../../../controller/homepage/hijri_date_controller.dart';
import '../../../controller/homepage/navigation_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentAddress = "Loading your location...";

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _sendAddressToBackend(_currentAddress);
  }

  Future<void> _loadLocation() async {
    String address = await LocationService().getCurrentLocation();
    setState(() {
      _currentAddress = address;
    });
  }
  void _sendAddressToBackend(String address) async {
    final url = Uri.parse('http://192.168.0.109:5000/submit-address');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"address": address}),
    );

    if (response.statusCode == 200) {
      print('Address sent successfully');
    } else {
      print('Failed to send address');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: blueColor,
      //bottomNavigationBar: AdScreen(),
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          height: size.height.toDouble(),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                height: size.height * 0.4,
                width: size.width,
                child: HijriDate(
                  adhanRepository: AdhanRepositoryImpl(context),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              HomeGridFeatures(),
              SizedBox(
                height: size.height * 0.02,
              ),
              AdScreen(),
              //DailyStory(),
              SizedBox(
                height: size.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: blueColor,
      scrolledUnderElevation: 0,
      title: GestureDetector(
        onTap: () async {
          // Clear saved location and fetch the current one
          await LocationService().clearSavedLocation();
          String address = await LocationService().getCurrentLocation();
          setState(() {
            _currentAddress = address;
            _sendAddressToBackend(_currentAddress);
          });
        },
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              _currentAddress,
              style: TextStyle(
                color: yellowColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HijriDate extends StatefulWidget {
  final AdhanRepository adhanRepository;

  const HijriDate({super.key, required this.adhanRepository});

  @override
  State<HijriDate> createState() => _HijriDateState();
}

class _HijriDateState extends State<HijriDate> {
  String _locationMessage = "Fetching location...";
  Coordinates coordinates = Coordinates(0, 0);
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final permission = await Permission.locationWhenInUse.status;

    if (permission != PermissionStatus.granted) {
      final result = await Permission.locationWhenInUse.request();
      if (result != PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _locationMessage = "Location permission denied";
          });
        }
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (mounted) {
        setState(() {
          coordinates = Coordinates(position.latitude, position.longitude);
          _locationMessage =
              'Location: ${position.latitude}, ${position.longitude}';
          print(_locationMessage);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationMessage = "Failed to get location: $e";
          print(_locationMessage);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // // Specify the calculation parameters for prayer times
    // PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
    // params.madhab = PrayerMadhab.hanafi;
    // // Create a PrayerTimes instance for the specified location
    // PrayerTimes prayerTimes = PrayerTimes(
    //   coordinates: coordinates,
    //   calculationParameters: params,
    //   precision: true,
    //   locationName: 'Europe/London',
    // );

    final HijriDateController controller =
        Get.put(HijriDateController(widget.adhanRepository));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.adhanData.value == null) {
          return const Center(child: Text('No data available'));
        } else {
          AdhanData adhanData = controller.adhanData.value!;
          int todayIndex = controller.findTodayIndex(adhanData.data);
          String currentAdhan =
              controller.getCurrentAdhan(adhanData.data[todayIndex]['timings']);
          int adhanIndex = controller.getAdhanIndex(currentAdhan);

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
                      adhanData.data[todayIndex]['date']['gregorian']['weekday']
                          ['en'],
                      style: TextStyle(
                        fontSize: 14,
                        color: lightBlue,
                      ),
                    ),
                    Text(
                      ", ",
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      adhanData.data[todayIndex]['date']['readable'],
                      style: TextStyle(
                        fontSize: 14,
                        color: lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Container(
                  width: size.width * 0.3,
                  height: size.height * 0.04,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: adhanData
                        .data[todayIndex]['date']['hijri']['holidays'].length,
                    itemBuilder: (BuildContext context, int holidayIndex) {
                      var holidays = adhanData.data[todayIndex]['date']['hijri']
                          ['holidays'];

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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    height: size.height * 0.12,
                    width: size.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Now',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          currentAdhan,
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "End in : ${controller.formatTime(controller.getNextAdhanTime(adhanData.data[todayIndex]['timings']))}",
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "Sunrise : ${controller.formatTime(adhanData.data[todayIndex]['timings']['Sunrise'])}",
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "Sunset : ${controller.formatTime(adhanData.data[todayIndex]['timings']['Sunset'])}",
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    //decoration: BoxDecoration(border: Border.all(color: yellowColor)),
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    height: size.height * 0.1,
                    width: size.width * 0.2,
                    child: Image.asset(
                      'assets/images/adhanIcon/${currentAdhan.toLowerCase()}.png',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                height: size.height * 0.07,
                width: size.width,
                // decoration: BoxDecoration(
                //   color: whiteColor,
                //   borderRadius: BorderRadius.circular(16),
                //   border: Border.all(color: yellowColor),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < controller.adhanNameList.length; i++)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.stop,
                            size: 12,
                            color: i == adhanIndex ? yellowColor : blueColor,
                          ),
                          Text(
                            controller.adhanNameList[i],
                            style: TextStyle(
                              fontSize: size.width * 0.03,
                              color: i == adhanIndex ? yellowColor : blueColor,
                            ),
                          ),
                          Text(
                            controller.formatTime(adhanData.data[todayIndex]
                                ['timings'][controller.adhanNameList[i]]),
                            style: TextStyle(
                              fontSize: size.width * 0.025,
                              color: i == adhanIndex ? yellowColor : blueColor,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class HomeGridFeatures extends StatelessWidget {
  const HomeGridFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the navigation controller
    final NavigationController navigationController =
        Get.put(NavigationController());

    List<String> gridText = [
      //'Prayer Times',
      //'Al Quran',
      'Kalam',
      'Videos',
      //'Qibla',
      //'Dua',
      //'Qaida',
      'Fazail',
      //'Hadith',
      //'Masjids',
      //'Tasbih',
      'Donate Us',
    ];

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: gridText.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            navigationController.navigateTo(index);
          },
          child: Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  'assets/images/without-bg - Copy.png',
                ),
              ),
              Text(
                gridText[index],
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AdScreen extends StatefulWidget {
  AdScreen({super.key});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  late BannerAd _bannerAd;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.HomeBanner(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(
            () {
              isAdLoaded = true;
              print(isAdLoaded);
            },
          );
        },
        onAdFailedToLoad: (ad, err) {
          isAdLoaded = false;
          Text(err.message);
        },
      ),
      request: AdRequest(),
    );
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isAdLoaded
        ? SizedBox(
            height: _bannerAd.size.height.toDouble(),
            width: double.infinity,
            child: AdWidget(ad: _bannerAd),
          )
        : Container(
            height: 0,
          );
  }
}

// class DailyStory extends StatelessWidget {
//   const DailyStory({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final DailyStoryController controller = Get.put(DailyStoryController());
//     final size = MediaQuery.of(context).size;
//
//     BoxDecoration boxDecoration(Color borderColor) => BoxDecoration(
//           border: Border.all(color: borderColor),
//         );
//
//     return Obx(
//       () => Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             height: size.height * 0.3,
//             width: size.width,
//             child: PageView.builder(
//               controller: controller.pageController,
//               itemCount: 3,
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                   width: size.width, // Each card covers the full screen width
//                   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//                   child: Card(
//                     color: Colors.grey.shade50,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(
//                               left: 16, top: 8, right: 16, bottom: 8),
//                           height: size.height * 0.05,
//                           width: size.width * 0.4,
//                           decoration: boxDecoration(Colors
//                               .yellow), // Use Colors.yellow for yellowColor
//                         ),
//                         Container(
//                           padding: EdgeInsets.only(
//                               left: 16, top: 8, right: 16, bottom: 8),
//                           margin:
//                               EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           height: size.height * 0.15,
//                           width: size.width,
//                           decoration: boxDecoration(Colors.yellow),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 8), // Space between PageView and dots
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               3,
//               (index) => AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 margin: EdgeInsets.symmetric(horizontal: 4),
//                 width: controller.currentPage.value == index ? 12 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: controller.currentPage.value == index
//                       ? Colors.yellow
//                       : Colors.grey,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
