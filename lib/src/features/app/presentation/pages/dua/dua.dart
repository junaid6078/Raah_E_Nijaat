import 'package:flutter/material.dart';

class Dua extends StatefulWidget {
  const Dua({super.key});

  @override
  State<Dua> createState() => _DuaState();
}

class _DuaState extends State<Dua> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      title: Text('Dua'),
    );
  }
}
