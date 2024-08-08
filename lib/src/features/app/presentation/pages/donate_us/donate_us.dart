import 'package:flutter/material.dart';

class DonateUs extends StatefulWidget {
  const DonateUs({super.key});

  @override
  State<DonateUs> createState() => _DonateUsState();
}

class _DonateUsState extends State<DonateUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      title: Text('Donate Us'),
    );
  }
}
