import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'hamdDomain.dart';



abstract class HamdRepository {
  Future<List<Hamd>> getAllHamds();
}

class HamdRepositoryImpl implements HamdRepository {
  final BuildContext _context;

  HamdRepositoryImpl(this._context);

  @override
  Future<List<Hamd>> getAllHamds() async {
    final String json = await _loadFromAsset();
    final List<Hamd> hamds = await _parse(json);

    return hamds;
  }

  Future<String> _loadFromAsset() async {
    return await DefaultAssetBundle.of(_context).loadString("assets/hamd.json");
  }

  Future<List<Hamd>> _parse(String json) async {
    final String jsonString = await _loadFromAsset();
    final List data = jsonDecode(jsonString) as List;
    List<Hamd> hamds = data.map((e) => Hamd.fromJson(e)).toList();

    return hamds;
  }

}

