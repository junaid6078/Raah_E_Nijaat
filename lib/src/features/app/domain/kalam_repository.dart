import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'kalam.dart';

abstract class KalamRepository {
  Future<List<Kalam>> getAllKalams();
}

class KalamRepositoryImpl implements KalamRepository {
  final BuildContext _context;

  KalamRepositoryImpl(this._context);

  @override
  Future<List<Kalam>> getAllKalams() async {
    final String json = await _loadFromAsset();
    final List<Kalam> kalams = await _parse(json);

    return kalams;
  }

  Future<String> _loadFromAsset() async {
    return await DefaultAssetBundle.of(_context).loadString("assets/hamd.json");
  }

  Future<List<Kalam>> _parse(String json) async {
    final String jsonString = await _loadFromAsset();
    final List data = jsonDecode(jsonString) as List;
    List<Kalam> kalams = data.map((e) => Kalam.fromJson(e)).toList();

    return kalams;
  }
}

