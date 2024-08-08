import 'package:flutter/material.dart';

class Zakat extends StatefulWidget {
  const Zakat({super.key});

  @override
  State<Zakat> createState() => _ZakatState();
}

class _ZakatState extends State<Zakat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),

    );
  }
  AppBar _appBar(){
    return AppBar(
      title: Text('Zakat'),
    );
  }
}
