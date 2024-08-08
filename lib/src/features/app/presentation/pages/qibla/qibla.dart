import 'package:flutter/material.dart';

class Qibla extends StatefulWidget {
  const Qibla({super.key});

  @override
  State<Qibla> createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      title: Text('Qibla'),
    );
  }
}
