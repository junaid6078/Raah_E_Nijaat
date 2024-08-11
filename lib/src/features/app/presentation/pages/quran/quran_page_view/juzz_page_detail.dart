import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class JuzzPageView extends StatefulWidget {
  final List juzzText;
  const JuzzPageView({super.key, required this.juzzText});

  @override
  State<JuzzPageView> createState() => _JuzzPageViewState();
}

class _JuzzPageViewState extends State<JuzzPageView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: _appBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topCenter,
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4.0),
                  AutoSizeText(
                    "",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: lightBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: whiteColor,
                padding: const EdgeInsets.all(12),
                child: ListView.separated(
                  padding: const EdgeInsets.all(2),
                  itemCount: widget.juzzText.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      child: (widget.juzzText == null)
                          ? null
                          : Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: yellowColor),
                              // ),
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Center(
                                child: AutoSizeText(
                                  widget.juzzText[index].text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 100,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: blueColor,
      title: const AutoSizeText(''),
    );
  }
}
