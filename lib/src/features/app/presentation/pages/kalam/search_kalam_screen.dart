
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../domain/kalam.dart';

class SearchKalams extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Kalam? selectedResult;
  final List<Kalam> kalams;

  SearchKalams(this.kalams);

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult?.lines[0] ?? ""),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Kalam> suggestionList = [];

    List<Kalam> filteredKalams = kalams
        .where((hamd) =>
            hamd.subject.contains(query) ||
            hamd.poet.contains(query) ||
            hamd.type.contains(query) ||
            hamd.lines
                .where((line) => line.contains(query))
                .toList()
                .isNotEmpty)
        .toList();

    query.isEmpty ? suggestionList = [] : suggestionList.addAll(filteredKalams);

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, position) {
          Kalam kalam = suggestionList[position];
          return ListTile(
            title: AutoSizeText(
                "${kalam.type} | ${kalam.poet} | ${kalam.lines[0]}"),
            onTap: () {
              selectedResult = suggestionList[position];
              showResults(context);
            },
          );
        });
  }
}
