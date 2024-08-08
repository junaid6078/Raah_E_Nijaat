import 'package:flutter/material.dart';

class Tasbih extends StatefulWidget {
  const Tasbih({super.key});

  @override
  State<Tasbih> createState() => _TasbihState();
}

class _TasbihState extends State<Tasbih> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      title: Text('Tasbih'),
    );
  }
}
