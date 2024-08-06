import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'kalam_line.dart';

class KalamPage extends StatelessWidget {
  final kalam;

  const KalamPage({super.key, required this.kalam});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildKalamHeading(kalam.type, kalam.subject, kalam.poet),
        Expanded(
          child: ListView.builder(
            itemCount: kalam.lines.length,
            physics: const ScrollPhysics(),
            itemBuilder: (context, position) {
              return _buildLineContainer(position);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLineContainer(int position) {
    String line = kalam.lines[position];
    return KalamLine(
      height: 40,
      text: line,
      color: Colors.transparent, fontSize: 5,
    );
  }

  Widget _buildKalamHeading(String type, String subject, String poet) {
    return Container(
      padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 247, 190, 25), width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          AutoSizeText(
            type,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          AutoSizeText(
            poet,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          // AutoSizeText(
          //   subject,
          //   style: TextStyle(fontSize: 16, color: Colors.black45),
          //   textAlign: TextAlign.center,
          // ),
          const SizedBox(
            height: 8.0,
          )
        ],
      ),
    );
  }
}
