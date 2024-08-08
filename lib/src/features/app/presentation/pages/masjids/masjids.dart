import 'package:flutter/material.dart';

class Masjids extends StatefulWidget {
  const Masjids({super.key});

  @override
  State<Masjids> createState() => _MasjidsState();
}

class _MasjidsState extends State<Masjids> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      title: Text('Masjids'),
    );
  }
}
