import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/navigator/navigator.dart';
import '../../../utils/colors.dart';
import 'category/kalamListPages/hamdList.dart';
import 'category/kalamListPages/manqabatList.dart';
import 'category/kalamListPages/naatList.dart';
import 'category/kalamListPages/salamList.dart';

class KalamList extends StatefulWidget {
  const KalamList({super.key});

  @override
  State<KalamList> createState() => _KalamListState();
}

class _KalamListState extends State<KalamList> {
  final List<Tab> tabs = <Tab>[
    const Tab(text: 'حمد'),
    const Tab(text: 'نعت'),
    const Tab(text: 'منقبت'),
    const Tab(text: 'سللام'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: yellowColor,
          child: Icon(
            Icons.search,
            color: blueColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: _buildAppBar(),
        body: const TabBarView(
          children: [
            HamdList(),
            NaatList(),
            ManqabatList(),
            SalamList(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      bottom: _tabBar(),
      title: AutoSizeText(
        "Kalam",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width *
              0.05, // Fixed size following Material Design
          color: blueColor,
        ),
      ),
      elevation: 0,
      backgroundColor: whiteColor,
    );
  }

  TabBar _tabBar() {
    return TabBar(
      labelStyle:
          const TextStyle(fontSize: 16), // Fixed size following Material Design
      labelColor: yellowColor,
      unselectedLabelColor: lightBlue,
      indicatorColor: yellowColor,
      tabs: tabs,
    );
  }
}
