import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'manqabarDomain.dart';


abstract class ManqabatRepository {
  Future<List<Manqabat>> getAllManqabats();
}

class ManqabatRepositoryImpl implements ManqabatRepository {
  final BuildContext _context;

  ManqabatRepositoryImpl(this._context);

  @override
  Future<List<Manqabat>> getAllManqabats() async {
    final String json = await _loadFromAsset();
    final List<Manqabat> manqabats = await _parse(json);

    return manqabats;
  }

  Future<String> _loadFromAsset() async {
    return await DefaultAssetBundle.of(_context).loadString("assets/manqabat.json");
  }

  Future<List<Manqabat>> _parse(String json) async {
    final String jsonString = await _loadFromAsset();
    final List data = jsonDecode(jsonString) as List;
    List<Manqabat> manqabats = data.map((e) => Manqabat.fromJson(e)).toList();

    return manqabats;
  }
}

