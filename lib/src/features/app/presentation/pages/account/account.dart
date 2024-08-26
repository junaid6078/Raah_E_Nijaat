import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/account/feedback/feedback.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/location/location.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  final List<String> general = [
    'Location',
    'Feedback',
    'About Us',
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _appBar(),
            Container(
              height: 200,
              width: 200,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: yellowColor,
              //   ),
              // ),
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(
              height: 20,
            ),
            _buildMenuItem(
              context,
              Icons.location_on,
              general[0],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Location(),
                ),
              ),
            ),
            _buildMenuItem(
              context,
              Icons.feedback,
              general[1],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackPage(),
                ),
              ),
            ),
            _buildMenuItem(context, Icons.contact_support, general[2]),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar();
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: blueColor,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
