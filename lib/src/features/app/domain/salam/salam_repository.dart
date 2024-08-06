import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:raah_e_nijaat/src/features/app/domain/salam/salamDomain.dart';

abstract class SalamRepository {
  Future<List<Salam>> getAllSalams();
}

class SalamRepositoryImpl implements SalamRepository {
  final BuildContext _context;

  SalamRepositoryImpl(this._context);

  @override
  Future<List<Salam>> getAllSalams() async {
    final String json = await _loadFromAsset();
    final List<Salam> salams = await _parse(json);

    return salams;
  }

  Future<String> _loadFromAsset() async {
    return await DefaultAssetBundle.of(_context).loadString("assets/salam.json");
  }

  Future<List<Salam>> _parse(String json) async {
    final String jsonString = await _loadFromAsset();
    final List data = jsonDecode(jsonString) as List;
    List<Salam> salams = data.map((e) => Salam.fromJson(e)).toList();

    return salams;
  }
}

