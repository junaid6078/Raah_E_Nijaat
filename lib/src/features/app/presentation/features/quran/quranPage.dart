import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/navigator/navigator.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/features/quran/surahView.dart';

import '../../../utils/colors.dart';
import 'juzzView.dart';

class QuranHomePage extends StatefulWidget {
  const QuranHomePage({super.key});

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  final List<Widget> _tabView = [
    const SurahViewPage(),
    const JuzzViewPage(),
    PageView(), // Assuming this is a placeholder for "Page"
  ];

  final List<Tab> tabs = const <Tab>[
    Tab(text: "Surah"),
    Tab(text: "Juzz"),
    Tab(text: "Page"),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: tabs.length, // Ensure this matches the number of tabs
      child: Scaffold(
        // backgroundColor: backgroundColor,
        appBar: _appBar(),
        body: TabBarView(
          children: _tabView,
        ),
      ),
    );
  }

  AppBar _appBar() {
    final size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: blueColor,
      title: AutoSizeText(
        "Al Quran",
        style: TextStyle(
          fontSize: size.width * 0.05,
          color: yellowColor,
        ),
      ),
      leading: BackButton(
        color: yellowColor,
        onPressed: (){
          AppNavigator.toHome(context);
        },
      ),
      bottom: TabBar(
        tabs: tabs,
        labelColor: yellowColor,
        unselectedLabelColor: lightBlue,
        indicatorColor: yellowColor,
      ),
    );
  }
}
