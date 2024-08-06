import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../pages/account/account.dart';
import '../../pages/videos/video_List.dart';
import 'homepage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final List _navPages = [
    const HomePage(),
    //const KalamList(),
    const VideosPage(),
    const Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navPages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTabTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: whiteColor,
      selectedItemColor: blueColor,
      unselectedItemColor: lightBlue.withOpacity(0.3),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.book),
        //   label: 'Kalam',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie),
          label: 'Videos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Me',
        ),
      ],
    );
  }
}
