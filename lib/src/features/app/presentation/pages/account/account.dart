import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:raah_e_nijaat/src/features/app/navigator/navigator.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/account/feedback/feedback.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/location/location.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';
import '../../../../create_account/presentation/sign_in/sign_in.dart';
import '../../home_screen/presentation/home_view.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  final List<String> general = [
    'Theme',
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
            _buildMenuItem(context, Icons.dark_mode, general[0]),
            _buildMenuItem(
              context,
              Icons.location_on,
              general[1],
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
              general[2],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackPage(),
                ),
              ),
            ),
            _buildMenuItem(context, Icons.contact_support, general[3]),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    final size = MediaQuery.of(context).size;
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
