import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'naatDomain.dart';


abstract class NaatRepository {
  Future<List<Naat>> getAllNaats();
}

class NaatRepositoryImpl implements NaatRepository {
  final BuildContext _context;

  NaatRepositoryImpl(this._context);

  @override
  Future<List<Naat>> getAllNaats() async {
    final String json = await _loadFromAsset();
    final List<Naat> naats = await _parse(json);

    return naats;
  }

  Future<String> _loadFromAsset() async {
    return await DefaultAssetBundle.of(_context).loadString("assets/naat.json");
  }

  Future<List<Naat>> _parse(String json) async {
    final String jsonString = await _loadFromAsset();
    final List data = jsonDecode(jsonString) as List;
    List<Naat> naats = data.map((e) => Naat.fromJson(e)).toList();

    return naats;
  }
}

