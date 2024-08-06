import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class FavouriteKalam extends StatefulWidget {
  final List<FavouriteKalam> favourites = [];
  FavouriteKalam({super.key});

  @override
  State<FavouriteKalam> createState() => _FavouriteKalamState();
}

class _FavouriteKalamState extends State<FavouriteKalam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: yellowColor,
        ),
        backgroundColor: blueColor,
        title: Text(
          "Favourites",
          style: TextStyle(color: yellowColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.favourites.length,
          itemBuilder: (context, int index) {
            return (widget.favourites == null)
                ? const AutoSizeText("empty")
                : const AutoSizeText("not empty");
          },
        ),
      ),
    );
  }
}
